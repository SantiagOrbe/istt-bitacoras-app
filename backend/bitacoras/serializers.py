import re

from rest_framework import serializers

from .models import Actividad, RegistroPractica, VisitaTutorAcademico


def validar_descripcion_actividad(value):
    descripcion = str(value).strip()
    if not descripcion:
        raise serializers.ValidationError('La actividad no puede estar vacía.')
    if not re.fullmatch(r'[A-Za-zÁÉÍÓÚÜÑáéíóúüñ\s]+', descripcion):
        raise serializers.ValidationError(
            'La actividad solo puede contener letras y espacios, sin números ni símbolos.'
        )
    if len(re.findall(r'[A-Za-zÁÉÍÓÚÜÑáéíóúüñ]', descripcion)) < 20:
        raise serializers.ValidationError(
            'Cada actividad debe tener al menos 20 letras.'
        )
    return descripcion


class ActividadSerializer(serializers.ModelSerializer):
    class Meta:
        model = Actividad
        fields = '__all__'

    def validate_descripcion(self, value):
        return validar_descripcion_actividad(value)


class VisitaTutorAcademicoSerializer(serializers.ModelSerializer):
    empresa_nombre = serializers.CharField(source='empresa.nombre', read_only=True)

    class Meta:
        model = VisitaTutorAcademico
        fields = '__all__'

    def validate_actividades(self, value):
        if value is None:
            return value

        texto = str(value).strip()
        if not texto:
            return texto

        actividades = [linea.strip() for linea in texto.splitlines() if linea.strip()]
        for actividad in actividades:
            validar_descripcion_actividad(actividad)

        return '\n'.join(actividades)


class RegistroPracticaSerializer(serializers.ModelSerializer):
    actividades = ActividadSerializer(many=True, read_only=True)
    actividad_id = serializers.SerializerMethodField()
    actividad_descripcion = serializers.SerializerMethodField()

    class Meta:
        model = RegistroPractica
        fields = [
            'id',
            'fecha',
            'hora_entrada',
            'hora_salida',
            'ubicacion_entrada',
            'ubicacion_salida',
            'estado',
            'estudiante',
            'actividades',
            'actividad_id',
            'actividad_descripcion',
        ]

    def get_actividad_id(self, obj):
        actividad = obj.actividades.order_by('-id').first()
        return actividad.id if actividad else None

    def get_actividad_descripcion(self, obj):
        actividad = obj.actividades.order_by('-id').first()
        return actividad.descripcion if actividad else ''
