from django.db import transaction
from rest_framework import serializers

from .models import (
    Carrera,
    CarreraPeriodo,
    Semestre,
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
    active_semesters = serializers.ListField(
        child=serializers.IntegerField(min_value=1),
        write_only=True,
        required=False,
    )

    class Meta:
        model = CarreraPeriodo
        fields = '__all__'

    def validate(self, attrs):
        carrera = attrs.get('carrera', getattr(self.instance, 'carrera', None))
        semestre = attrs.get('semestre', getattr(self.instance, 'semestre', None))
        paralelo = attrs.get(
            'paralelo', getattr(self.instance, 'paralelo', None)
        )

        if semestre and carrera and semestre.carrera_id != carrera.id:
            raise serializers.ValidationError({
                'semestre': 'El semestre no pertenece a la carrera seleccionada.'
            })
        if paralelo and semestre and paralelo.semestre_id != semestre.id:
            raise serializers.ValidationError({
                'paralelo': 'El paralelo no pertenece al semestre seleccionado.'
            })
        return attrs

    def to_representation(self, instance):
        data = super().to_representation(instance)
        data['active_semesters'] = (
            [instance.semestre.nivel] if instance.semestre_id else []
        )
        return data

    @transaction.atomic
    def create(self, validated_data):
        active_levels = validated_data.pop('active_semesters', None)
        if active_levels is None:
            return super().create(validated_data)

        carrera = validated_data['carrera']
        periodo = validated_data['periodo']
        first = None
        for semestre in Semestre.objects.filter(
            carrera=carrera, nivel__in=active_levels
        ):
            instance, _ = CarreraPeriodo.objects.update_or_create(
                carrera=carrera,
                periodo=periodo,
                semestre=semestre,
                defaults={'estado': True},
            )
            first = first or instance
        return first or CarreraPeriodo.objects.create(
            **validated_data, estado=False
        )


class SemestreSerializer(serializers.ModelSerializer):
    class Meta:
        model = Semestre
        fields = '__all__'


class ParaleloSerializer(serializers.ModelSerializer):
    class Meta:
        model = Paralelo
        fields = '__all__'


class ResultadoAprendizajeSerializer(serializers.ModelSerializer):
    class Meta:
        model = ResultadoAprendizaje
        fields = '__all__'