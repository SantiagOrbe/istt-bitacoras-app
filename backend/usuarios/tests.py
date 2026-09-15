from django.contrib.auth import get_user_model
from django.db import IntegrityError
from django.urls import reverse
from rest_framework import status
from rest_framework.test import APITestCase
from unittest.mock import patch

from .models import Estudiante


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
