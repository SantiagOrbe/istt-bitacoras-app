from datetime import date
from math import asin, cos, radians, sin, sqrt
from django.contrib.gis.geos import Point
from django.utils import timezone
from rest_framework.exceptions import ValidationError

from empresas.models import Empresa
from usuarios.models import Estudiante
from .models import RegistroPractica


class GeofencingService:
    @staticmethod
    def _distancia_a_empresa(empresa, latitud, longitud):
        if empresa.ubicacion:
            empresa_latitud = empresa.ubicacion.y
            empresa_longitud = empresa.ubicacion.x
        elif empresa.latitud is not None and empresa.longitud is not None:
            empresa_latitud = empresa.latitud
            empresa_longitud = empresa.longitud
        else:
            return None

        radio_tierra_metros = 6_371_000
        lat1, lat2 = radians(float(empresa_latitud)), radians(float(latitud))
        delta_lat = radians(float(latitud) - float(empresa_latitud))
        delta_lon = radians(float(longitud) - float(empresa_longitud))
        valor = (
            sin(delta_lat / 2) ** 2
            + cos(lat1) * cos(lat2) * sin(delta_lon / 2) ** 2
        )
        return 2 * radio_tierra_metros * asin(sqrt(valor))

    @staticmethod
    def realizar_check_in(estudiante, latitud, longitud):
        if not estudiante:
            raise ValidationError({'error': 'El usuario autenticado no tiene un perfil de estudiante asociado.'})

        if not estudiante.empresa:
            raise ValidationError({'error': 'El estudiante no tiene una empresa asignada.'})

        if latitud is None or longitud is None:
            raise ValidationError({'error': 'Se requieren latitud y longitud.'})

        try:
            lat = float(latitud)
            lon = float(longitud)
        except (ValueError, TypeError):
            raise ValidationError({'error': 'Latitud y longitud deben ser valores numéricos válidos.'})

        today = date.today()
        existing_active = RegistroPractica.objects.filter(
            estudiante=estudiante,
            fecha=today,
            hora_salida__isnull=True
        ).first()

        if existing_active:
            raise ValidationError({'error': 'Ya existe un registro de práctica activo para hoy sin hora de salida.'})

        punto_enviado = Point(lon, lat, srid=4326)
        empresa = estudiante.empresa

        if not empresa.ubicacion:
            raise ValidationError({'error': 'La empresa asignada no tiene una ubicación GPS configurada.'})

        distancia_metros = GeofencingService._distancia_a_empresa(
            empresa, lat, lon
        )
        if distancia_metros is None:
            raise ValidationError({
                'error': 'La empresa asignada no tiene una ubicación GPS configurada.'
            })

        radio_permitido = empresa.radio_permitido if empresa.radio_permitido is not None else 50.0

        if distancia_metros <= radio_permitido:
            registro = RegistroPractica.objects.create(
                fecha=today,
                hora_entrada=timezone.now().time(),
                ubicacion_entrada=punto_enviado,
                estudiante=estudiante,
                estado=True
            )
            return registro
        else:
            raise ValidationError({
                'error': 'Estás fuera del rango permitido de la empresa.',
                'distancia_metros': round(distancia_metros, 2),
                'radio_permitido': radio_permitido
            })

    @staticmethod
    def realizar_check_out(estudiante, latitud, longitud):
        if not estudiante:
            raise ValidationError({'error': 'El usuario autenticado no tiene un perfil de estudiante asociado.'})

        today = date.today()
        registro = RegistroPractica.objects.filter(
            estudiante=estudiante,
            fecha=today,
            hora_salida__isnull=True
        ).first()

        if not registro:
            raise ValidationError({'error': 'No se encontró un registro de práctica activo (entrada sin salida) para el día de hoy.'})

        if latitud is None or longitud is None:
            raise ValidationError({'error': 'Se requieren latitud y longitud para registrar la salida.'})

        try:
            lat = float(latitud)
            lon = float(longitud)
        except (ValueError, TypeError):
            raise ValidationError({'error': 'Latitud y longitud deben ser valores numéricos válidos.'})

        punto_salida = Point(lon, lat, srid=4326)
        empresa = estudiante.empresa
        if not empresa:
            raise ValidationError({'error': 'El estudiante no tiene una empresa asignada.'})
        if not empresa.ubicacion and (empresa.latitud is None or empresa.longitud is None):
            raise ValidationError({'error': 'La empresa asignada no tiene una ubicación GPS configurada.'})

        distancia_metros = GeofencingService._distancia_a_empresa(
            empresa, lat, lon
        )
        if distancia_metros is None:
            raise ValidationError({
                'error': 'La empresa asignada no tiene una ubicación GPS configurada.'
            })
        radio_permitido = empresa.radio_permitido if empresa.radio_permitido is not None else 50.0
        if distancia_metros > radio_permitido:
            raise ValidationError({
                'error': 'Estás fuera del rango permitido de la empresa.',
                'distancia_metros': round(distancia_metros, 2),
                'radio_permitido': radio_permitido,
            })

        registro.hora_salida = timezone.now().time()
        registro.ubicacion_salida = punto_salida
        registro.estado = False
        registro.save()

        return registro
