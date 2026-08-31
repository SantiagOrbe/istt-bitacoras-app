from datetime import date
from django.contrib.gis.db.models.functions import Distance
from django.contrib.gis.geos import Point
from django.utils import timezone
from rest_framework.exceptions import ValidationError

from empresas.models import Empresa
from usuarios.models import Estudiante
from .models import RegistroPractica


class GeofencingService:
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

        # Calculate distance using manager (.con_distancia_a_empresa) or fallback to Empresa annotation
        existing_rp = RegistroPractica.objects.filter(estudiante=estudiante).con_distancia_a_empresa(punto_enviado).first()
        if existing_rp and hasattr(existing_rp, 'distancia_empresa') and existing_rp.distancia_empresa:
            distancia_metros = existing_rp.distancia_empresa.m
        else:
            empresa_annotated = Empresa.objects.filter(pk=empresa.pk).annotate(
                dist=Distance('ubicacion', punto_enviado)
            ).first()
            distancia_metros = empresa_annotated.dist.m if empresa_annotated and empresa_annotated.dist else 0.0

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

        ubicacion_salida = None
        if latitud is not None and longitud is not None:
            try:
                lat = float(latitud)
                lon = float(longitud)
                ubicacion_salida = Point(lon, lat, srid=4326)
            except (ValueError, TypeError):
                pass

        registro.hora_salida = timezone.now().time()
        if ubicacion_salida:
            registro.ubicacion_salida = ubicacion_salida
        registro.save()

        return registro
