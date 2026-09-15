from django.contrib.auth import authenticate
from django.db import transaction
from rest_framework import serializers
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer

from .models import (
    Coordinador,
    Docente,
    Estudiante,
    TutorAcademico,
    TutorEmpresarial,
    Usuario,
)


INSTITUTIONAL_EMAIL_DOMAIN = '@est.itstena.edu.ec'


def validate_institutional_email(value):
    email = value.strip().lower()
    if not email.endswith(INSTITUTIONAL_EMAIL_DOMAIN):
        raise serializers.ValidationError(
            'El correo debe pertenecer a la institución y terminar en '
            '@est.itstena.edu.ec.'
        )
    return email


class LoginTokenSerializer(TokenObtainPairSerializer):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.fields.pop(self.username_field, None)
        self.fields['email'] = serializers.EmailField(write_only=True)

    def validate_email(self, value):
        return validate_institutional_email(value)

    def validate(self, attrs):
        email = attrs['email']
        password = attrs.get('password', '')
        usuario = Usuario.objects.filter(email__iexact=email).first()

        if usuario is None:
            raise serializers.ValidationError({
                'email': [
                    'El correo electrónico no está registrado.'
                ]
            })

        authenticated_user = authenticate(
            username=usuario.get_username(),
            password=password,
        )
        if authenticated_user is None:
            raise serializers.ValidationError({
                'password': ['La contraseña ingresada es incorrecta.']
            })

        refresh = self.get_token(authenticated_user)
        return {
            'refresh': str(refresh),
            'access': str(refresh.access_token),
        }


class RegistroSerializer(serializers.ModelSerializer):
    email = serializers.EmailField()
    password = serializers.CharField(write_only=True, min_length=8)
    confirm_password = serializers.CharField(write_only=True)

    class Meta:
        model = Usuario
        fields = ['email', 'password', 'confirm_password']

    def validate_email(self, value):
        email = validate_institutional_email(value)
        if Usuario.objects.filter(email__iexact=email).exists():
            raise serializers.ValidationError(
                'Este correo electrónico ya está registrado.'
            )
        return email

    def validate(self, attrs):
        if attrs['password'] != attrs['confirm_password']:
            raise serializers.ValidationError({
                'confirm_password': ['Las contraseñas no coinciden.']
            })
        return attrs

    def create(self, validated_data):
        validated_data.pop('confirm_password')
        email = validated_data['email']
        with transaction.atomic():
            usuario = Usuario.objects.create_user(
                username=email,
                email=email,
                password=validated_data['password'],
                rol='estudiante',
            )
            Estudiante.objects.get_or_create(usuario=usuario)
        return usuario


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