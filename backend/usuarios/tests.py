from django.contrib.auth import get_user_model
from django.db import IntegrityError
from django.urls import reverse
from rest_framework import status
from rest_framework.test import APITestCase
from unittest.mock import patch

from empresas.models import Empresa
from .models import Estudiante
from .models import Coordinador
from .models import ResponsablePracticas
from .models import TutorAcademico
from gestion_academica.models import Carrera


Usuario = get_user_model()


class AutenticacionTests(APITestCase):
	def setUp(self):
		self.email = 'estudiante@est.itstena.edu.ec'
		self.password = 'ClaveSegura123'
		Usuario.objects.create_user(
			username='estudiante',
			email=self.email,
			password=self.password,
			rol='estudiante',
		)
		self.admin = Usuario.objects.create_user(
			username='admin',
			email='admin@est.itstena.edu.ec',
			password='ClaveSegura123',
			rol='admin',
		)

	def test_login_con_correo_devuelve_tokens(self):
		response = self.client.post(
			reverse('token_obtain_pair'),
			{'email': self.email, 'password': self.password},
			format='json',
		)

		self.assertEqual(response.status_code, status.HTTP_200_OK)
		self.assertIn('access', response.data)
		self.assertIn('refresh', response.data)

	def test_login_rechaza_correo_no_institucional(self):
		response = self.client.post(
			reverse('token_obtain_pair'),
			{'email': 'usuario@gmail.com', 'password': self.password},
			format='json',
		)

		self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
		self.assertIn('email', response.data)

	def test_login_devuelve_error_de_password(self):
		response = self.client.post(
			reverse('token_obtain_pair'),
			{'email': self.email, 'password': 'incorrecta'},
			format='json',
		)

		self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
		self.assertEqual(
			response.data['password'],
			['La contraseña ingresada es incorrecta.'],
		)

	def test_login_informa_cuenta_desactivada(self):
		usuario = Usuario.objects.get(email=self.email)
		usuario.estado = False
		usuario.is_active = False
		usuario.save(update_fields=['estado', 'is_active'])

		response = self.client.post(
			reverse('token_obtain_pair'),
			{'email': self.email, 'password': self.password},
			format='json',
		)

		self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
		self.assertIn('desactivada', response.data['email'][0])

	def test_registro_crea_usuario_con_password_hasheada(self):
		email = 'nuevo@est.itstena.edu.ec'
		response = self.client.post(
			reverse('register'),
			{
				'email': email,
				'password': 'NuevaClave123',
				'confirm_password': 'NuevaClave123',
			},
			format='json',
		)

		self.assertEqual(response.status_code, status.HTTP_201_CREATED)
		usuario = Usuario.objects.get(email=email)
		self.assertTrue(usuario.check_password('NuevaClave123'))
		self.assertTrue(
			Estudiante.objects.filter(usuario=usuario).exists()
		)

	@patch('usuarios.serializers.Estudiante.objects.get_or_create')
	def test_registro_revierte_usuario_si_falla_perfil(self, get_or_create):
		get_or_create.side_effect = IntegrityError('fallo de perfil')
		email = 'fallo@est.itstena.edu.ec'

		response = self.client.post(
			reverse('register'),
			{
				'email': email,
				'password': 'NuevaClave123',
				'confirm_password': 'NuevaClave123',
			},
			format='json',
		)

		self.assertEqual(response.status_code, status.HTTP_409_CONFLICT)
		self.assertIn('detail', response.data)
		self.assertFalse(Usuario.objects.filter(email=email).exists())

	def test_registro_rechaza_passwords_diferentes(self):
		response = self.client.post(
			reverse('register'),
			{
				'email': 'nuevo@est.itstena.edu.ec',
				'password': 'NuevaClave123',
				'confirm_password': 'OtraClave123',
			},
			format='json',
		)

		self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
		self.assertIn('confirm_password', response.data)

	def test_crud_usuario_expone_lista_y_desactiva_sin_borrar(self):
		self.client.force_authenticate(user=self.admin)
		response = self.client.get(reverse('usuario-list'))

		self.assertEqual(response.status_code, status.HTTP_200_OK)
		self.assertGreaterEqual(len(response.data), 2)

		student = Usuario.objects.get(email=self.email)
		delete_response = self.client.delete(
			reverse('usuario-detail', args=[student.pk])
		)

		self.assertEqual(delete_response.status_code, status.HTTP_204_NO_CONTENT)
		student.refresh_from_db()
		self.assertFalse(student.estado)
		self.assertFalse(student.is_active)
		self.assertTrue(Usuario.objects.filter(pk=student.pk).exists())

	def test_admin_puede_crear_usuario_con_email_sin_error_500(self):
		self.client.force_authenticate(user=self.admin)
		response = self.client.post(
			reverse('usuario-list'),
			{
				'email': 'nuevo.admin@est.itstena.edu.ec',
				'first_name': 'Nuevo',
				'last_name': 'Administrador',
				'telefono': '0999999999',
				'rol': 'coordinador',
				'estado': True,
				'is_active': True,
				'password': 'ClaveSegura123',
			},
			format='json',
		)

		self.assertEqual(response.status_code, status.HTTP_201_CREATED)
		usuario = Usuario.objects.get(email='nuevo.admin@est.itstena.edu.ec')
		self.assertTrue(usuario.check_password('ClaveSegura123'))
		self.assertEqual(usuario.username, usuario.email)

	def test_perfil_incluye_empresa_asignada_para_estudiante(self):
		usuario = Usuario.objects.get(email=self.email)
		empresa = Empresa.objects.create(
			nombre='Empresa Prueba',
			direccion='Dirección de prueba',
			telefono='0999999999',
			correo='empresa@prueba.com',
			latitud=-0.1807,
			longitud=-78.4834,
			radio_permitido=80.0,
		)
		Estudiante.objects.filter(usuario=usuario).update(empresa=empresa)

		self.client.force_authenticate(user=usuario)
		response = self.client.get(reverse('perfil'))

		self.assertEqual(response.status_code, status.HTTP_200_OK)
		self.assertEqual(response.data['empresa_id'], empresa.id)
		self.assertEqual(response.data['company_name'], empresa.nombre)

	def test_admin_rechaza_cedula_y_telefono_repetidos(self):
		self.client.force_authenticate(user=self.admin)
		base_data = {
			'email': 'coordinador.base@est.itstena.edu.ec',
			'first_name': 'Coordinador',
			'last_name': 'Base',
			'telefono': '0991234567',
			'rol': 'coordinador',
			'cedula': '1500000003',
			'password': 'ClaveSegura123',
		}
		created = self.client.post(
			reverse('usuario-list'), base_data, format='json'
		)
		self.assertEqual(created.status_code, status.HTTP_201_CREATED)

		duplicate_phone = dict(base_data)
		duplicate_phone.update({
			'email': 'coordinador.telefono@est.itstena.edu.ec',
			'cedula': '1500000011',
		})
		phone_response = self.client.post(
			reverse('usuario-list'), duplicate_phone, format='json'
		)
		self.assertEqual(phone_response.status_code, status.HTTP_400_BAD_REQUEST)
		self.assertIn('telefono', phone_response.data)

		duplicate_cedula = dict(base_data)
		duplicate_cedula.update({
			'email': 'coordinador.cedula@est.itstena.edu.ec',
			'telefono': '0997654321',
		})
		cedula_response = self.client.post(
			reverse('usuario-list'), duplicate_cedula, format='json'
		)
		self.assertEqual(cedula_response.status_code, status.HTTP_400_BAD_REQUEST)
		self.assertIn('cedula', cedula_response.data)

	def test_admin_crea_perfil_de_tutor_academico_en_la_misma_operacion(self):
		self.client.force_authenticate(user=self.admin)
		carrera = Carrera.objects.create(
			nombre='Desarrollo de Software',
			descripcion='Carrera de prueba',
			codigo_carrera='DS',
			sigla_carrera='DS',
			modalidad='Presencial',
		)
		response = self.client.post(
			reverse('usuario-list'),
			{
				'email': 'tutor@est.itstena.edu.ec',
				'first_name': 'Tutor',
				'rol': 'TUTOR_ACADEMICO',
				'cedula': '1500000003',
				'carrera_id': carrera.pk,
				'password': 'ClaveSegura123',
			},
			format='json',
		)

		self.assertEqual(response.status_code, status.HTTP_201_CREATED)
		usuario = Usuario.objects.get(email='tutor@est.itstena.edu.ec')
		self.assertTrue(TutorAcademico.objects.filter(usuario=usuario).exists())

	def test_tutor_academico_recibe_sus_estudiantes_asignados(self):
		carrera = Carrera.objects.create(
			nombre='Desarrollo de Software',
			descripcion='Carrera de prueba',
			codigo_carrera='DS2',
			sigla_carrera='DS2',
			modalidad='Presencial',
		)
		usuario_tutor = Usuario.objects.create_user(
			username='tutor2',
			email='tutor2@est.itstena.edu.ec',
			password='ClaveSegura123',
			rol='tutor_academico',
			first_name='Ana',
			last_name='Tutor',
		)
		tutor = TutorAcademico.objects.create(
			usuario=usuario_tutor,
			cedula='1500000100',
			carrera=carrera,
		)
		usuario_estudiante = Usuario.objects.create_user(
			username='estudiante2',
			email='estudiante2@est.itstena.edu.ec',
			password='ClaveSegura123',
			rol='estudiante',
			first_name='Luis',
			last_name='Estudiante',
		)
		Estudiante.objects.create(
			usuario=usuario_estudiante,
			cedula='1500000101',
			carrera=carrera,
			tutor_academico=tutor,
		)

		self.client.force_authenticate(user=usuario_tutor)
		response = self.client.get(reverse('tutor-academico-mis-tutoriados'))

		self.assertEqual(response.status_code, status.HTTP_200_OK)
		self.assertEqual(response.data['total'], 1)
		self.assertEqual(response.data['estudiantes'][0]['student']['name'], 'Luis Estudiante')

	def test_coordinador_muestra_empresa_del_estudiante_en_tutor_academico(self):
		carrera = Carrera.objects.create(
			nombre='Redes y Telecomunicaciones',
			descripcion='Carrera de prueba',
			codigo_carrera='RT1',
			sigla_carrera='RT',
			modalidad='Presencial',
		)
		empresa = Empresa.objects.create(
			nombre='Empresa del estudiante',
			direccion='Av. Principal',
			telefono='0999999999',
			correo='empresa@prueba.com',
			latitud=-0.1807,
			longitud=-78.4834,
		)
		usuario_coordinador = Usuario.objects.create_user(
			username='coordinador.rt',
			email='coordinador.rt@est.itstena.edu.ec',
			password='ClaveSegura123',
			rol='coordinador',
		)
		Coordinador.objects.create(
			usuario=usuario_coordinador,
			cedula='1500000200',
			carrera=carrera,
		)
		usuario_tutor = Usuario.objects.create_user(
			username='tutor.rt',
			email='tutor.rt@est.itstena.edu.ec',
			password='ClaveSegura123',
			rol='tutor_academico',
		)
		tutor = TutorAcademico.objects.create(
			usuario=usuario_tutor,
			cedula='1500000201',
			carrera=carrera,
		)
		usuario_estudiante = Usuario.objects.create_user(
			username='estudiante.rt',
			email='estudiante.rt@est.itstena.edu.ec',
			password='ClaveSegura123',
			rol='estudiante',
		)
		Estudiante.objects.create(
			usuario=usuario_estudiante,
			cedula='1500000202',
			carrera=carrera,
			empresa=empresa,
			tutor_academico=tutor,
		)

		self.client.force_authenticate(user=usuario_coordinador)
		response = self.client.get(reverse('coordinador-datos'))

		self.assertEqual(response.status_code, status.HTTP_200_OK)
		self.assertEqual(response.data['tutores'][0]['empresa_id'], empresa.id)
		self.assertEqual(response.data['tutores'][0]['empresa_nombre'], empresa.nombre)

	def test_admin_crea_perfil_de_responsable_de_practicas(self):
		self.client.force_authenticate(user=self.admin)
		response = self.client.post(
			reverse('usuario-list'),
			{
				'email': 'responsable@est.itstena.edu.ec',
				'first_name': 'Responsable',
				'last_name': 'Practicas',
				'rol': 'responsable_practicas',
				'cedula': '1500000003',
				'password': 'ClaveSegura123',
			},
			format='json',
		)

		self.assertEqual(response.status_code, status.HTTP_201_CREATED)
		usuario = Usuario.objects.get(
			email='responsable@est.itstena.edu.ec'
		)
		perfil = ResponsablePracticas.objects.get(usuario=usuario)
		self.assertEqual(perfil.cedula, '1500000003')
		self.assertEqual(response.data['cedula'], '1500000003')

	def test_admin_rechaza_empresa_y_carrera_inactivas_al_crear_estudiante(self):
		self.client.force_authenticate(user=self.admin)
		carrera = Carrera.objects.create(
			nombre='Carrera inactiva',
			descripcion='Carrera de prueba',
			codigo_carrera='CI',
			sigla_carrera='CI',
			modalidad='Presencial',
			estado=False,
		)
		empresa = Empresa.objects.create(
			nombre='Empresa inactiva',
			direccion='Dirección prueba',
			telefono='0999999999',
			correo='empresa.inactiva@empresa.com',
			latitud=-0.1807,
			longitud=-78.4834,
			radio_permitido=50,
			estado=False,
		)

		response = self.client.post(
			reverse('usuario-list'),
			{
				'email': 'estudiante.inactivo@est.itstena.edu.ec',
				'first_name': 'Estudiante',
				'last_name': 'Inactivo',
				'telefono': '0991234567',
				'rol': 'estudiante',
				'cedula': '1700000001',
				'carrera_id': carrera.pk,
				'empresa_id': empresa.pk,
				'password': 'ClaveSegura123',
			},
			format='json',
		)

		self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
		self.assertIn('carrera_id', response.data)
		self.assertIn('empresa_id', response.data)

	def test_listado_filtra_por_estado_rol_y_busqueda(self):
		self.client.force_authenticate(user=self.admin)
		student = Usuario.objects.get(email=self.email)
		student.estado = False
		student.is_active = False
		student.save(update_fields=['estado', 'is_active'])

		response = self.client.get(
			reverse('usuario-list'),
			{'is_active': 'false', 'rol': 'ESTUDIANTE', 'search': 'estudiante'},
		)

		self.assertEqual(response.status_code, status.HTTP_200_OK)
		self.assertEqual(len(response.data), 1)
