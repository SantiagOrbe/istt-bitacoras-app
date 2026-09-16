from django.contrib.auth import get_user_model
from django.urls import reverse
from rest_framework import status
from rest_framework.test import APITestCase

from usuarios.models import Estudiante

from .models import Carrera, Paralelo, Semestre


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
