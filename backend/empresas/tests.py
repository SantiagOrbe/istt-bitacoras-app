from django.contrib.auth import get_user_model
from django.urls import reverse
from rest_framework import status
from rest_framework.test import APITestCase

from empresas.models import Empresa
from usuarios.models import Estudiante

Usuario = get_user_model()


class EmpresaDesactivacionTests(APITestCase):
    def setUp(self):
        self.admin = Usuario.objects.create_user(
            username='admin_empresa',
            email='admin_empresa@est.itstena.edu.ec',
            password='ClaveSegura123',
            rol='admin',
        )
        self.client.force_authenticate(user=self.admin)

    def test_desactiva_empresa_y_desvincula_estudiantes_confirmados(self):
        empresa = Empresa.objects.create(
            nombre='Empresa prueba',
            direccion='Dirección prueba',
            telefono='0999999999',
            correo='empresa@empresa.com',
            latitud=-0.1807,
            longitud=-78.4834,
            radio_permitido=50,
            estado=True,
        )
        usuario = Usuario.objects.create_user(
            username='estudiante_empresa',
            email='estudiante_empresa@est.itstena.edu.ec',
            password='ClaveSegura123',
            rol='estudiante',
        )
        estudiante = Estudiante.objects.create(
            usuario=usuario,
            empresa=empresa,
            cedula='1700000002',
        )

        response = self.client.patch(
            reverse('empresa-detail', args=[empresa.pk]),
            {'estado': False, 'unlink_students': True},
            format='json',
        )

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        empresa.refresh_from_db()
        estudiante.refresh_from_db()
        self.assertFalse(empresa.estado)
        self.assertIsNone(estudiante.empresa_id)

    def test_reactiva_empresa_con_nombre_y_direccion_con_simbolos_validos(self):
        empresa = Empresa.objects.create(
            nombre='Empresa & Cía.',
            direccion='Av. 10 de Agosto / Calle 8',
            telefono='0999999999',
            correo='empresa@empresa.com',
            latitud=-0.1807,
            longitud=-78.4834,
            radio_permitido=50,
            estado=False,
        )

        response = self.client.put(
            reverse('empresa-detail', args=[empresa.pk]),
            {
                'nombre': 'Empresa & Cía.',
                'direccion': 'Av. 10 de Agosto / Calle 8',
                'telefono': '0999999999',
                'correo': 'empresa@empresa.com',
                'latitud': -0.1807,
                'longitud': -78.4834,
                'radio_permitido': 50,
                'estado': True,
            },
            format='json',
        )

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        empresa.refresh_from_db()
        self.assertTrue(empresa.estado)
