from rest_framework import serializers

from .models import (
    Coordinador,
    Docente,
    Estudiante,
    TutorAcademico,
    TutorEmpresarial,
    Usuario,
)


class UsuarioSerializer(serializers.ModelSerializer):
    class Meta:
        model = Usuario
        fields = [
            'id',
            'username',
            'email',
            'first_name',
            'last_name',
            'telefono',
            'rol',
            'estado',
        ]


class DocenteSerializer(serializers.ModelSerializer):
    usuario = UsuarioSerializer(read_only=True)

    class Meta:
        model = Docente
        fields = ['id', 'usuario', 'cedula']


class CoordinadorSerializer(serializers.ModelSerializer):
    usuario = UsuarioSerializer(read_only=True)

    class Meta:
        model = Coordinador
        fields = ['id', 'usuario', 'cedula']


class TutorAcademicoSerializer(serializers.ModelSerializer):
    usuario = UsuarioSerializer(read_only=True)

    class Meta:
        model = TutorAcademico
        fields = ['id', 'usuario', 'cedula']


class TutorEmpresarialSerializer(serializers.ModelSerializer):
    usuario = UsuarioSerializer(read_only=True)

    class Meta:
        model = TutorEmpresarial
        fields = ['id', 'usuario', 'cedula', 'cargo', 'empresa']


class EstudianteSerializer(serializers.ModelSerializer):
    usuario = UsuarioSerializer(read_only=True)

    class Meta:
        model = Estudiante
        fields = [
            'id',
            'usuario',
            'matricula',
            'cedula',
            'carrera',
            'ciclo',
            'paralelo',
            'empresa',
            'tutor_academico',
            'tutor_empresarial',
        ]