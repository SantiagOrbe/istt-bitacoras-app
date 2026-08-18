from rest_framework import serializers

from .models import Actividad, RegistroPractica


class ActividadSerializer(serializers.ModelSerializer):
    class Meta:
        model = Actividad
        fields = '__all__'


class RegistroPracticaSerializer(serializers.ModelSerializer):
    actividades = ActividadSerializer(many=True, read_only=True)

    class Meta:
        model = RegistroPractica
        fields = '__all__'