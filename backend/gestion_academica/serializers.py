from rest_framework import serializers

from .models import (
    Carrera,
    CarreraPeriodo,
    Ciclo,
    Paralelo,
    Periodo,
    ResultadoAprendizaje,
)


class PeriodoSerializer(serializers.ModelSerializer):
    class Meta:
        model = Periodo
        fields = '__all__'


class CarreraSerializer(serializers.ModelSerializer):
    class Meta:
        model = Carrera
        fields = '__all__'


class CarreraPeriodoSerializer(serializers.ModelSerializer):
    class Meta:
        model = CarreraPeriodo
        fields = '__all__'


class CicloSerializer(serializers.ModelSerializer):
    class Meta:
        model = Ciclo
        fields = '__all__'


class ParaleloSerializer(serializers.ModelSerializer):
    class Meta:
        model = Paralelo
        fields = '__all__'


class ResultadoAprendizajeSerializer(serializers.ModelSerializer):
    class Meta:
        model = ResultadoAprendizaje
        fields = '__all__'