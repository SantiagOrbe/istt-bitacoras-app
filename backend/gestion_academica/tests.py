import uuid

from django.contrib.auth import get_user_model
from django.urls import reverse
from rest_framework import status
from rest_framework.test import APITestCase

from usuarios.models import Estudiante

from .models import Carrera, CarreraPeriodo, Paralelo, Periodo, Semestre
from .serializers import (
    CarreraPeriodoSerializer,
    ParaleloSerializer,
    PeriodoSerializer,
    SemestreSerializer,
)


Usuario = get_user_model()


class ParaleloEstudiantesTests(APITestCase):
	def setUp(self):
		self.admin = Usuario.objects.create_user(
			username='admin',
			email='admin@est.itstena.edu.ec',
			password='ClaveSegura123',
			rol='admin',
		)
		self.client.force_authenticate(user=self.admin)
		self.carrera = Carrera.objects.create(
			nombre='Administracion',
			descripcion='Gestion empresarial',
			codigo_carrera='ADM-101',
			sigla_carrera='ADM',
			modalidad='Presencial',
			total_semestres=8,
		)
		semestre = Semestre.objects.create(
			nombre='Primero', nivel=1, carrera=self.carrera
		)
		self.first_parallel = Paralelo.objects.create(
			nombre='A', jornada='matutina', semestre=semestre
		)
		self.second_parallel = Paralelo.objects.create(
			nombre='B', jornada='matutina', semestre=semestre
		)
		student_user = Usuario.objects.create_user(
			username='estudiante',
			email='estudiante@est.itstena.edu.ec',
			password='ClaveSegura123',
			rol='estudiante',
		)
		self.student = Estudiante.objects.create(
			usuario=student_user,
			carrera=self.carrera,
			paralelo=self.first_parallel,
		)

	def test_no_permite_mover_estudiante_ya_asignado_a_otro_paralelo(self):
		url = reverse(
			'paralelo-estudiantes', args=[self.second_parallel.pk]
		)

		response = self.client.get(url)
		self.assertEqual(response.status_code, status.HTTP_200_OK)
		self.assertTrue(response.data[0]['bloqueado'])

		response = self.client.post(
			url,
			{'estudiante_ids': [self.student.pk]},
			format='json',
		)

		self.assertEqual(response.status_code, status.HTTP_409_CONFLICT)
		self.student.refresh_from_db()
		self.assertEqual(self.student.paralelo_id, self.first_parallel.pk)

	def test_asignar_estudiante_guarda_semestre_y_paralelo(self):
		student_user = Usuario.objects.create_user(
			username='estudiante2',
			email='estudiante2@est.itstena.edu.ec',
			password='ClaveSegura123',
			rol='estudiante',
		)
		student = Estudiante.objects.create(
			usuario=student_user,
			carrera=self.carrera,
		)
		url = reverse(
			'paralelo-estudiantes', args=[self.second_parallel.pk]
		)

		response = self.client.post(
			url,
			{'estudiante_ids': [student.pk]},
			format='json',
		)

		self.assertEqual(response.status_code, status.HTTP_200_OK)
		student.refresh_from_db()
		self.assertEqual(student.semestre_id, self.second_parallel.semestre_id)
		self.assertEqual(student.paralelo_id, self.second_parallel.pk)

	def test_retira_todos_y_conserva_la_carrera(self):
		url = reverse(
			'paralelo-estudiantes', args=[self.first_parallel.pk]
		)

		response = self.client.delete(url)

		self.assertEqual(response.status_code, status.HTTP_200_OK)
		self.student.refresh_from_db()
		self.assertIsNone(self.student.semestre_id)
		self.assertIsNone(self.student.paralelo_id)
		self.assertEqual(self.student.carrera_id, self.carrera.pk)

	def test_rechaza_carrera_semestre_y_paralelo_inactivos(self):
		inactive_carrera = Carrera.objects.create(
			nombre='Carrera inactiva',
			descripcion='Carrera de prueba',
			codigo_carrera='CI-2026',
			sigla_carrera='CI',
			modalidad='Presencial',
			total_semestres=5,
			estado=False,
		)
		inactive_semestre = Semestre.objects.create(
			nombre='Primero',
			nivel=1,
			carrera=inactive_carrera,
			estado=False,
		)
		inactive_paralelo = Paralelo.objects.create(
			nombre='A',
			jornada='matutina',
			semestre=inactive_semestre,
			estado=False,
		)

		carrera_serializer = Carrera.objects.filter(pk=inactive_carrera.pk).first()
		self.assertIsNotNone(carrera_serializer)
		self.assertFalse(carrera_serializer.estado)

		semestre_serializer = SemestreSerializer(
			data={
				'nombre': 'Segundo',
				'nivel': 2,
				'carrera': inactive_carrera.pk,
				'estado': True,
			}
		)
		self.assertFalse(semestre_serializer.is_valid())
		self.assertIn('carrera', semestre_serializer.errors)

		paralelo_serializer = ParaleloSerializer(
			data={
				'nombre': 'B',
				'jornada': 'vespertina',
				'semestre': inactive_semestre.pk,
				'estado': True,
			}
		)
		self.assertFalse(paralelo_serializer.is_valid())
		self.assertIn('semestre', paralelo_serializer.errors)

		periodo = Periodo.objects.create(
			nombre='2026-IS',
			fecha_inicio='2026-01-05',
			fecha_fin='2026-06-30',
		)
		config_serializer = CarreraPeriodoSerializer(data={
			'carrera': inactive_carrera.pk,
			'periodo': periodo.pk,
			'active_semesters': [1],
		})
		self.assertFalse(config_serializer.is_valid())
		self.assertIn('carrera', config_serializer.errors)

	def test_periodo_puede_aceptar_nombre_con_guion_y_guardar_semestres_activos(self):
		periodo = Periodo.objects.create(
			nombre=f'2026-IS-EXISTENTE-{uuid.uuid4().hex[:8]}',
			fecha_inicio='2026-01-05',
			fecha_fin='2026-06-30',
		)
		self.assertIsNotNone(periodo.pk)

		validator_name = f'2026-IS-VALIDA-{uuid.uuid4().hex[:8]}'
		serializer = PeriodoSerializer(data={
			'nombre': validator_name,
			'fecha_inicio': '2026-01-05',
			'fecha_fin': '2026-06-30',
		})
		self.assertTrue(serializer.is_valid(), serializer.errors)

		carrera = Carrera.objects.create(
			nombre='Software',
			descripcion='Ingenieria de software',
			codigo_carrera='SW-101',
			sigla_carrera='SW',
			modalidad='Presencial',
			total_semestres=8,
		)
		for nivel in [1, 3, 5]:
			Semestre.objects.create(
				nombre=f'S{nivel}',
				nivel=nivel,
				carrera=carrera,
			)

		config_serializer = CarreraPeriodoSerializer(data={
			'carrera': carrera.pk,
			'periodo': periodo.pk,
			'active_semesters': [1, 3],
		})
		self.assertTrue(config_serializer.is_valid(), config_serializer.errors)
		config = config_serializer.save()

		self.assertEqual(config.periodo_id, periodo.pk)
		self.assertEqual(config.carrera_id, carrera.pk)
		self.assertEqual(
			set(CarreraPeriodoSerializer(instance=config).data['active_semesters']),
			{1, 3},
		)

	def test_desactiva_carrera_requiere_confirmacion_si_tiene_relaciones(self):
		carrera = Carrera.objects.create(
			nombre='Contabilidad',
			descripcion='Carrera con relaciones',
			codigo_carrera='CON-2026',
			sigla_carrera='CON',
			modalidad='Presencial',
			total_semestres=4,
		)
		Semestre.objects.create(nombre='Primero', nivel=1, carrera=carrera)
		user = Usuario.objects.create_user(
			username='estudiante_con',
			email='estudiante_con@est.itstena.edu.ec',
			password='ClaveSegura123',
			rol='estudiante',
		)
		Estudiante.objects.create(usuario=user, carrera=carrera)

		url = reverse('carrera-detail', args=[carrera.pk])
		response = self.client.put(
			url,
			{'estado': False},
			format='json',
		)
		self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
		self.assertIn('detail', response.data)

		response = self.client.patch(
			url,
			{'estado': False, 'confirm_desactivate': True},
			format='json',
		)
		self.assertEqual(response.status_code, status.HTTP_200_OK)
		carrera.refresh_from_db()
		self.assertFalse(carrera.estado)

	def test_reactiva_carrera_con_nombre_y_descripcion_reales(self):
		carrera = Carrera.objects.create(
			nombre='Ingeniería de Sistemas & Redes',
			descripcion='Carrera 2 con práctica y especialización.',
			codigo_carrera='ISR-2025',
			sigla_carrera='ISR',
			modalidad='Presencial',
			total_semestres=8,
			estado=False,
		)

		response = self.client.put(
			reverse('carrera-detail', args=[carrera.pk]),
			{
				'nombre': 'Ingeniería de Sistemas & Redes',
				'descripcion': 'Carrera 2 con práctica y especialización.',
				'codigo_carrera': 'ISR-2025',
				'sigla_carrera': 'ISR',
				'modalidad': 'Presencial',
				'total_semestres': 8,
				'estado': True,
			},
			format='json',
		)

		self.assertEqual(response.status_code, status.HTTP_200_OK)
		carrera.refresh_from_db()
		self.assertTrue(carrera.estado)

	def test_desactivar_semestre_desactiva_relaciones_carrera_periodo(self):
		carrera = Carrera.objects.create(
			nombre='Carrera semestres',
			descripcion='Carrera de prueba',
			codigo_carrera='SEM-2026',
			sigla_carrera='SEM',
			modalidad='Presencial',
			total_semestres=4,
		)
		semestre = Semestre.objects.create(
			nombre='Primero', nivel=1, carrera=carrera, estado=True,
		)
		periodo = Periodo.objects.create(
			nombre='2026-P',
			fecha_inicio='2026-01-05',
			fecha_fin='2026-06-30',
		)
		config = CarreraPeriodo.objects.create(
			carrera=carrera,
			periodo=periodo,
			semestre=semestre,
			estado=True,
		)

		response = self.client.patch(
			reverse('semestre-detail', args=[semestre.pk]),
			{'estado': False},
			format='json',
		)

		self.assertEqual(response.status_code, status.HTTP_200_OK)
		config.refresh_from_db()
		self.assertFalse(config.estado)

	def test_desactivar_carrera_desactiva_semestres_y_relaciones(self):
		carrera = Carrera.objects.create(
			nombre='Carrera con semestres',
			descripcion='Carrera de prueba',
			codigo_carrera='CSS-2026',
			sigla_carrera='CSS',
			modalidad='Presencial',
			total_semestres=4,
		)
		semestre_1 = Semestre.objects.create(
			nombre='Primero', nivel=1, carrera=carrera, estado=True,
		)
		semestre_2 = Semestre.objects.create(
			nombre='Segundo', nivel=2, carrera=carrera, estado=True,
		)
		periodo = Periodo.objects.create(
			nombre='2026-Q',
			fecha_inicio='2026-01-05',
			fecha_fin='2026-06-30',
		)
		config = CarreraPeriodo.objects.create(
			carrera=carrera,
			periodo=periodo,
			semestre=semestre_1,
			estado=True,
		)

		response = self.client.patch(
			reverse('carrera-detail', args=[carrera.pk]),
			{'estado': False, 'confirm_desactivate': True},
			format='json',
		)

		self.assertEqual(response.status_code, status.HTTP_200_OK)
		carrera.refresh_from_db()
		semestre_1.refresh_from_db()
		semestre_2.refresh_from_db()
		config.refresh_from_db()
		self.assertFalse(carrera.estado)
		self.assertFalse(semestre_1.estado)
		self.assertFalse(semestre_2.estado)
		self.assertFalse(config.estado)

		response = self.client.patch(
			reverse('carrera-detail', args=[carrera.pk]),
			{'estado': True},
			format='json',
		)
		self.assertEqual(response.status_code, status.HTTP_200_OK)
		carrera.refresh_from_db()
		semestre_1.refresh_from_db()
		semestre_2.refresh_from_db()
		self.assertTrue(carrera.estado)
		self.assertTrue(semestre_1.estado)
		self.assertTrue(semestre_2.estado)

	def test_filtro_estado_en_semestres_y_paralelos(self):
		carrera = Carrera.objects.create(
			nombre='Carrera filtro',
			descripcion='Carrera de prueba',
			codigo_carrera='FIL-2026',
			sigla_carrera='FIL',
			modalidad='Presencial',
			total_semestres=4,
		)
		semestre_activo = Semestre.objects.create(
			nombre='Primero', nivel=1, carrera=carrera, estado=True,
		)
		semestre_inactivo = Semestre.objects.create(
			nombre='Segundo', nivel=2, carrera=carrera, estado=False,
		)
		Paralelo.objects.create(
			nombre='A', jornada='matutina', semestre=semestre_activo, estado=True,
		)
		Paralelo.objects.create(
			nombre='B', jornada='vespertina', semestre=semestre_inactivo, estado=False,
		)

		response = self.client.get(
			reverse('semestre-list'),
			{'carrera': carrera.pk, 'estado': 'true'},
		)
		self.assertEqual(response.status_code, status.HTTP_200_OK)
		self.assertEqual(len(response.data), 1)
		self.assertEqual(response.data[0]['id'], semestre_activo.id)

		response = self.client.get(
			reverse('paralelo-list'),
			{'semestre': semestre_inactivo.pk, 'estado': 'false'},
		)
		self.assertEqual(response.status_code, status.HTTP_200_OK)
		self.assertEqual(len(response.data), 1)
		self.assertEqual(response.data[0]['id'], response.data[0]['id'])
		self.assertFalse(response.data[0]['estado'])
