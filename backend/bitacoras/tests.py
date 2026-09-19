from django.contrib.gis.geos import Point
from django.urls import reverse
from rest_framework import status
from rest_framework.test import APITestCase

from empresas.models import Empresa
from gestion_academica.models import Carrera, Paralelo, Semestre
from usuarios.models import Estudiante, TutorAcademico, TutorEmpresarial, Usuario
from bitacoras.models import Actividad, RegistroPractica


class BitacorasGeofencingTests(APITestCase):
    def setUp(self):
        self.carrera = Carrera.objects.create(
            nombre='Ingeniería de Software',
            descripcion='Carrera de Software',
            codigo_carrera='ISW01',
            sigla_carrera='SW',
            modalidad='Presencial'
        )
        self.semestre = Semestre.objects.create(
            nombre='Octavo',
            nivel=8,
            carrera=self.carrera
        )
        self.paralelo = Paralelo.objects.create(
            nombre='A',
            jornada='Matutina',
            semestre=self.semestre
        )

        # Create Empresa with location (Quito center) and 100m radius
        self.empresa = Empresa.objects.create(
            nombre='Tech Corp',
            direccion='Av. Amazonas',
            telefono='0999999999',
            correo='contact@techcorp.com',
            radio_permitido=100.0,
            ubicacion=Point(-78.4834, -0.1807, srid=4326)
        )

        # Create Tutors
        self.user_tutor_acad = Usuario.objects.create_user(username='tutor_acad', email='acad@test.com', password='password123', rol='tutor_academico')
        self.tutor_acad = TutorAcademico.objects.create(usuario=self.user_tutor_acad, cedula='1111111111')

        self.user_tutor_emp = Usuario.objects.create_user(username='tutor_emp', email='emp@test.com', password='password123', rol='tutor_empresarial')
        self.tutor_emp = TutorEmpresarial.objects.create(usuario=self.user_tutor_emp, cedula='2222222222', cargo='Jefe', empresa=self.empresa)

        # Create Student
        self.user_estudiante = Usuario.objects.create_user(username='estudiante1', email='est@test.com', password='password123', rol='estudiante')
        self.estudiante = Estudiante.objects.create(
            usuario=self.user_estudiante,
            matricula='M001',
            cedula='3333333333',
            carrera=self.carrera,
                semestre=self.semestre,
            paralelo=self.paralelo,
            empresa=self.empresa,
            tutor_academico=self.tutor_acad,
            tutor_empresarial=self.tutor_emp
        )

        self.check_in_url = reverse('registropractica-check-in')
        self.check_out_url = reverse('registropractica-check-out')
        self.mi_avance_url = reverse('registropractica-mi-avance')
        self.registros_url = reverse('registropractica-list')
        self.actividades_url = reverse('actividad-list')

    def test_check_in_within_range(self):
        self.client.force_authenticate(user=self.user_estudiante)
        # Point very close to company (-78.4834, -0.1807)
        data = {
            'latitud': -0.1807,
            'longitud': -78.4834
        }
        response = self.client.post(self.check_in_url, data, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertIn('hora_entrada', response.data)
        self.assertIsNotNone(response.data['hora_entrada'])

    def test_check_in_out_of_range(self):
        self.client.force_authenticate(user=self.user_estudiante)
        # Point far away
        data = {
            'latitud': -2.1894,
            'longitud': -79.8891
        }
        response = self.client.post(self.check_in_url, data, format='json')
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertIn('error', response.data)

    def test_check_out_success(self):
        self.client.force_authenticate(user=self.user_estudiante)
        # First check in
        self.client.post(self.check_in_url, {'latitud': -0.1807, 'longitud': -78.4834}, format='json')

        # Then check out
        response = self.client.post(self.check_out_url, {'latitud': -0.1807, 'longitud': -78.4834}, format='json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn('hora_salida', response.data)
        self.assertIsNotNone(response.data['hora_salida'])

    def test_check_out_out_of_range(self):
        self.client.force_authenticate(user=self.user_estudiante)
        self.client.post(
            self.check_in_url,
            {'latitud': -0.1807, 'longitud': -78.4834},
            format='json',
        )

        response = self.client.post(
            self.check_out_url,
            {'latitud': -2.1894, 'longitud': -79.8891},
            format='json',
        )

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertIn('error', response.data)

    def test_role_based_permissions_and_queries(self):
        # Student creates check-in
        self.client.force_authenticate(user=self.user_estudiante)
        self.client.post(self.check_in_url, {'latitud': -0.1807, 'longitud': -78.4834}, format='json')

        # Student lists records
        response = self.client.get(self.registros_url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        records = response.data['results'] if 'results' in response.data else response.data
        self.assertEqual(len(records), 1)

        # Tutor academico lists records
        self.client.force_authenticate(user=self.user_tutor_acad)
        response = self.client.get(self.registros_url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        records = response.data['results'] if 'results' in response.data else response.data
        self.assertEqual(len(records), 1)

        # Tutor empresarial lists records
        self.client.force_authenticate(user=self.user_tutor_emp)
        response = self.client.get(self.registros_url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        records = response.data['results'] if 'results' in response.data else response.data
        self.assertEqual(len(records), 1)

    def test_mi_avance_returns_hours_and_blocks_new_checkin_when_goal_is_reached(self):
        from datetime import time

        self.semestre.horas_practicas = 6
        self.semestre.save(update_fields=['horas_practicas'])
        self.estudiante.semestre = self.semestre
        self.estudiante.save(update_fields=['semestre'])

        RegistroPractica.objects.create(
            estudiante=self.estudiante,
            fecha='2026-09-19',
            hora_entrada=time(8, 0),
            hora_salida=time(14, 0),
            estado=False,
        )

        self.client.force_authenticate(user=self.user_estudiante)
        advance_response = self.client.get(self.mi_avance_url)
        self.assertEqual(advance_response.status_code, status.HTTP_200_OK)
        self.assertEqual(float(advance_response.data['horas_acumuladas']), 6.0)
        self.assertEqual(float(advance_response.data['horas_requeridas']), 6.0)
        self.assertEqual(float(advance_response.data['porcentaje']), 100.0)
        self.assertTrue(advance_response.data['completo'])

        response = self.client.post(self.check_in_url, {'latitud': -0.1807, 'longitud': -78.4834}, format='json')
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertIn('horas de práctica', str(response.data))
