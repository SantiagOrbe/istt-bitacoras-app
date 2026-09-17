from django.db import transaction
import re
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

    def validate_nombre(self, value):
        value = value.strip()
        if not re.fullmatch(r'[A-Za-z0-9\- ]+', value):
            raise serializers.ValidationError(
                'El nombre del periodo solo puede contener letras, números, espacios y guiones.'
            )
        queryset = Periodo.objects.filter(nombre__iexact=value)
        if self.instance:
            queryset = queryset.exclude(pk=self.instance.pk)
        if queryset.exists():
            raise serializers.ValidationError('Ese periodo ya está registrado.')
        return value

    def validate(self, attrs):
        start = attrs.get('fecha_inicio', getattr(self.instance, 'fecha_inicio', None))
        end = attrs.get('fecha_fin', getattr(self.instance, 'fecha_fin', None))
        if start and end and end < start:
            raise serializers.ValidationError({
                'fecha_fin': 'La fecha final no puede ser anterior a la inicial.'
            })
        return attrs


class CarreraSerializer(serializers.ModelSerializer):
    class Meta:
        model = Carrera
        fields = '__all__'

    def validate_nombre(self, value):
        value = value.strip()
        if not re.fullmatch(r'[A-Za-zÁÉÍÓÚáéíóúÜüÑñ0-9.&/°#\'\- ]+', value):
            raise serializers.ValidationError(
                'El nombre de la carrera solo puede contener letras, números y símbolos básicos.'
            )
        return self._check_duplicate('nombre', value, 'El nombre de la carrera')

    def validate_codigo_carrera(self, value):
        return self._code(value, 'El código de la carrera')

    def validate_sigla_carrera(self, value):
        return self._code(value, 'La sigla')

    def validate_descripcion(self, value):
        value = value.strip()
        if not re.fullmatch(r'[A-Za-zÁÉÍÓÚáéíóúÜüÑñ0-9,.;:/&()#°\'\- ]+', value):
            raise serializers.ValidationError(
                'La descripción solo puede contener letras, números y símbolos básicos.'
            )
        return value

    def validate_modalidad(self, value):
        value = value.strip()
        if not value:
            raise serializers.ValidationError('La modalidad es obligatoria.')
        if not re.fullmatch(r'[A-Za-zÁÉÍÓÚáéíóúÜüÑñ0-9/&()\- ]+', value):
            raise serializers.ValidationError(
                'La modalidad solo puede contener letras, números y símbolos básicos comunes.'
            )
        return value

    def validate_total_semestres(self, value):
        if value <= 0:
            raise serializers.ValidationError(
                'El total de semestres debe ser mayor que cero.'
            )
        return value

    def _check_duplicate(self, field, value, label):
        queryset = Carrera.objects.filter(**{f'{field}__iexact': value.strip()})
        if self.instance:
            queryset = queryset.exclude(pk=self.instance.pk)
        if queryset.exists():
            raise serializers.ValidationError(f'{label} ya está registrado.')
        return value.strip()

    def _plain_text(self, value, label):
        value = value.strip()
        if not re.fullmatch(r'[^\W\d_]+(?: [^\W\d_]+)*', value, re.UNICODE):
            raise serializers.ValidationError(
                f'{label} solo puede contener letras, tildes y espacios.'
            )
        return self._check_duplicate('nombre', value, label)

    def _code(self, value, label):
        value = value.strip().upper()
        if not re.fullmatch(r'[A-Z0-9._-]+', value):
            raise serializers.ValidationError(
                f'{label} solo puede contener letras, números, puntos, guiones '
                'y guiones bajos.'
            )
        field = 'codigo_carrera' if label.startswith('El código') else 'sigla_carrera'
        return self._check_duplicate(field, value, label)


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

        if carrera and not carrera.estado:
            raise serializers.ValidationError({
                'carrera': 'La carrera seleccionada está inactiva.'
            })
        if semestre and not semestre.estado:
            raise serializers.ValidationError({
                'semestre': 'El semestre seleccionado está inactivo.'
            })
        if paralelo and not paralelo.estado:
            raise serializers.ValidationError({
                'paralelo': 'El paralelo seleccionado está inactivo.'
            })
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
        active_semesters = list(
            CarreraPeriodo.objects.filter(
                carrera_id=instance.carrera_id,
                periodo_id=instance.periodo_id,
                estado=True,
                semestre__estado=True,
            )
            .exclude(semestre__isnull=True)
            .order_by('semestre__nivel')
            .values_list('semestre__nivel', flat=True)
            .distinct()
        )
        data['active_semesters'] = active_semesters
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

    def validate_nombre(self, value):
        value = value.strip()
        if not re.fullmatch(r'[^\W\d_]+(?: [^\W\d_]+)*', value, re.UNICODE):
            raise serializers.ValidationError(
                'El nombre del semestre solo puede contener letras, tildes y espacios.'
            )
        queryset = Semestre.objects.filter(
            carrera=self.initial_data.get('carrera'), nombre__iexact=value
        )
        if self.instance:
            queryset = queryset.exclude(pk=self.instance.pk)
        if queryset.exists():
            raise serializers.ValidationError('Ese semestre ya existe en la carrera.')
        return value

    def validate_nivel(self, value):
        if value <= 0:
            raise serializers.ValidationError('El nivel debe ser mayor que cero.')
        return value

    def validate(self, attrs):
        carrera = attrs.get('carrera', getattr(self.instance, 'carrera', None))
        nivel = attrs.get('nivel', getattr(self.instance, 'nivel', None))
        if carrera and not carrera.estado:
            raise serializers.ValidationError({
                'carrera': 'La carrera seleccionada está inactiva.'
            })
        if carrera and nivel > carrera.total_semestres:
            raise serializers.ValidationError({
                'nivel': (
                    f'El nivel no puede superar los {carrera.total_semestres} '
                    'semestres configurados para la carrera.'
                )
            })
        queryset = Semestre.objects.filter(carrera=carrera, nivel=nivel)
        if self.instance:
            queryset = queryset.exclude(pk=self.instance.pk)
        if queryset.exists():
            raise serializers.ValidationError({'nivel': 'Ese nivel ya existe en la carrera.'})
        return attrs


class ParaleloSerializer(serializers.ModelSerializer):
    class Meta:
        model = Paralelo
        fields = '__all__'

    def validate_nombre(self, value):
        value = value.strip().upper()
        if not re.fullmatch(r'[A-Z0-9]+', value):
            raise serializers.ValidationError(
                'El nombre del paralelo solo puede contener letras y números.'
            )
        return value

    def validate_jornada(self, value):
        value = value.strip().lower()
        if value not in {'matutina', 'vespertina', 'nocturna'}:
            raise serializers.ValidationError(
                'La jornada debe ser matutina, vespertina o nocturna.'
            )
        return value

    def validate(self, attrs):
        semestre = attrs.get('semestre', getattr(self.instance, 'semestre', None))
        nombre = attrs.get('nombre', getattr(self.instance, 'nombre', ''))
        jornada = attrs.get('jornada', getattr(self.instance, 'jornada', ''))
        if semestre and not semestre.estado:
            raise serializers.ValidationError({
                'semestre': 'El semestre seleccionado está inactivo.'
            })
        if semestre and not semestre.carrera.estado:
            raise serializers.ValidationError({
                'semestre': 'La carrera asociada al semestre está inactiva.'
            })
        queryset = Paralelo.objects.filter(
            semestre=semestre, nombre__iexact=nombre, jornada__iexact=jornada
        )
        if self.instance:
            queryset = queryset.exclude(pk=self.instance.pk)
        if queryset.exists():
            raise serializers.ValidationError(
                'Ese paralelo ya existe para el semestre y jornada seleccionados.'
            )
        return attrs


class ResultadoAprendizajeSerializer(serializers.ModelSerializer):
    class Meta:
        model = ResultadoAprendizaje
        fields = '__all__'