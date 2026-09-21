from rest_framework import serializers

from .models import Actividad, RegistroPractica, VisitaTutorAcademico


class ActividadSerializer(serializers.ModelSerializer):
    class Meta:
        model = Actividad
        fields = '__all__'


class VisitaTutorAcademicoSerializer(serializers.ModelSerializer):
    empresa_nombre = serializers.CharField(source='empresa.nombre', read_only=True)

    class Meta:
        model = VisitaTutorAcademico
        fields = '__all__'


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
