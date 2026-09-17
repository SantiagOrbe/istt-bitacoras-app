import re

from django.contrib.gis.geos import Point
from rest_framework import serializers

from .models import Empresa


class EmpresaSerializer(serializers.ModelSerializer):
    def validate_nombre(self, value):
        nombre = value.strip()
        if not re.fullmatch(r"[A-Za-zÁÉÍÓÚáéíóúÜüÑñ0-9.&/°#'\- ]+", nombre):
            raise serializers.ValidationError(
                'El nombre solo puede contener letras, números y símbolos básicos como &, . , /, #, °, - y apóstrofos.'
            )
        return nombre

    def validate_direccion(self, value):
        direccion = value.strip()
        if not re.fullmatch(r"[A-Za-zÁÉÍÓÚáéíóúÜüÑñ0-9.,#/°&()\- ]+", direccion):
            raise serializers.ValidationError(
                'La dirección solo puede contener letras, números y símbolos básicos comunes para direcciones.'
            )
        return direccion

    def validate_telefono(self, value):
        telefono = value.strip()
        if telefono and not re.fullmatch(r'(09\d{8}|\+5939\d{8})', telefono):
            raise serializers.ValidationError(
                'Ingresa un número válido (09XXXXXXXX o +5939XXXXXXXX).'
            )
        return telefono

    def validate_correo(self, value):
        correo = value.strip().lower()
        if not re.fullmatch(
            r'[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}',
            correo,
        ):
            raise serializers.ValidationError(
                'Ingresa un correo válido con @ y punto, '
                'por ejemplo nombre@empresa.com.'
            )
        return correo

    class Meta:
        model = Empresa
        fields = '__all__'

    def validate(self, attrs):
        latitud = attrs.get('latitud', getattr(self.instance, 'latitud', None))
        longitud = attrs.get('longitud', getattr(self.instance, 'longitud', None))
        radio = attrs.get(
            'radio_permitido', getattr(self.instance, 'radio_permitido', None)
        )

        if radio is not None and radio <= 0:
            raise serializers.ValidationError({
                'radio_permitido': 'El radio permitido debe ser mayor que cero.'
            })

        if latitud is not None and longitud is not None:
            attrs['ubicacion'] = Point(float(longitud), float(latitud), srid=4326)

        return attrs

    def create(self, validated_data):
        latitud = validated_data.get('latitud')
        longitud = validated_data.get('longitud')
        empresa = super().create(validated_data)
        if latitud is not None and longitud is not None:
            empresa.guardar_ubicacion(latitud, longitud)
            empresa.save(update_fields=['latitud', 'longitud', 'ubicacion'])
        return empresa

    def update(self, instance, validated_data):
        latitud = validated_data.get('latitud', instance.latitud)
        longitud = validated_data.get('longitud', instance.longitud)
        empresa = super().update(instance, validated_data)
        if latitud is not None and longitud is not None:
            empresa.guardar_ubicacion(latitud, longitud)
            empresa.save(update_fields=['latitud', 'longitud', 'ubicacion'])
        return empresa