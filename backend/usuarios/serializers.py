from django.contrib.auth import authenticate
from django.db import transaction
import re
from rest_framework import serializers
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer

from empresas.models import Empresa
from gestion_academica.models import (
    Carrera,
    CarreraPeriodo,
    Paralelo,
    Semestre,
)

from .models import (
    Coordinador,
    Docente,
    Estudiante,
    ResponsablePracticas,
    TutorAcademico,
    TutorEmpresarial,
    Usuario,
)


INSTITUTIONAL_EMAIL_DOMAIN = '@est.itstena.edu.ec'


def validate_institutional_email(value):
    email = value.strip().lower()
    if not re.fullmatch(
        r'[a-z]+(?:[._-][a-z]+)*@est\.itstena\.edu\.ec',
        email,
    ):
        raise serializers.ValidationError(
            'El correo debe usar letras sin tildes ni números, puede incluir '
            'punto, guion o guion bajo, y terminar en '
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

        if not usuario.is_active or not usuario.estado:
            raise serializers.ValidationError({
                'email': [
                    'Esta cuenta está desactivada.'
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


class UsuarioAdminSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True, required=False, min_length=8)
    cedula = serializers.CharField(write_only=True, required=False, allow_blank=True)
    cargo = serializers.CharField(write_only=True, required=False, allow_blank=True)
    carrera_id = serializers.PrimaryKeyRelatedField(
        source='carrera',
        queryset=Carrera.objects.filter(estado=True),
        write_only=True,
        required=False,
        allow_null=True,
    )
    semestre = serializers.PrimaryKeyRelatedField(
        queryset=Semestre.objects.filter(estado=True),
        write_only=True,
        required=False,
        allow_null=True,
    )
    paralelo = serializers.PrimaryKeyRelatedField(
        queryset=Paralelo.objects.filter(estado=True),
        write_only=True,
        required=False,
        allow_null=True,
    )
    empresa_id = serializers.PrimaryKeyRelatedField(
        source='empresa',
        queryset=Empresa.objects.filter(estado=True),
        write_only=True,
        required=False,
        allow_null=True,
    )

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
            'is_active',
            'password',
            'cedula',
            'cargo',
            'carrera_id',
            'semestre',
            'paralelo',
            'empresa_id',
        ]
        read_only_fields = ['id', 'username']

    def validate_email(self, value):
        email = validate_institutional_email(value)
        queryset = Usuario.objects.filter(email__iexact=email)
        if self.instance:
            queryset = queryset.exclude(pk=self.instance.pk)
        if queryset.exists():
            raise serializers.ValidationError(
                'Este correo electrónico ya está registrado.'
            )
        return email

    def validate_first_name(self, value):
        return self._validate_plain_text(value, 'Los nombres')

    def validate_last_name(self, value):
        return self._validate_plain_text(value, 'Los apellidos')

    def validate_cargo(self, value):
        return self._validate_plain_text(value, 'El cargo')

    @staticmethod
    def _validate_plain_text(value, label):
        text = value.strip()
        if text and not re.fullmatch(r'[A-Za-z ]+', text):
            raise serializers.ValidationError(
                f'{label} solo pueden contener letras sin tildes ni símbolos.'
            )
        return text

    def validate_telefono(self, value):
        telefono = value.strip()
        if telefono and not re.fullmatch(r'(09\d{8}|\+5939\d{8})', telefono):
            raise serializers.ValidationError(
                'Ingresa un número válido (09XXXXXXXX o +5939XXXXXXXX).'
            )
        queryset = Usuario.objects.filter(telefono=telefono)
        if self.instance:
            queryset = queryset.exclude(pk=self.instance.pk)
        if telefono and queryset.exists():
            raise serializers.ValidationError(
                'Este número de teléfono ya está registrado.'
            )
        return telefono

    def validate_cedula(self, value):
        if value in (None, ''):
            return value
        cedula = value.strip()
        if len(cedula) != 10 or not cedula.isdigit():
            raise serializers.ValidationError(
                'La cédula debe tener exactamente 10 dígitos.'
            )
        if not 1 <= int(cedula[:2]) <= 24:
            raise serializers.ValidationError(
                'La cédula no pertenece a una región válida.'
            )
        total = 0
        for index, digit in enumerate(map(int, cedula[:9])):
            if index % 2 == 0:
                digit *= 2
                if digit > 9:
                    digit -= 9
            total += digit
        if (10 - total % 10) % 10 != int(cedula[-1]):
            raise serializers.ValidationError('La cédula no es válida.')
        profile_querysets = (
            Estudiante.objects.filter(cedula=cedula),
            Docente.objects.filter(cedula=cedula),
            Coordinador.objects.filter(cedula=cedula),
            ResponsablePracticas.objects.filter(cedula=cedula),
            TutorAcademico.objects.filter(cedula=cedula),
            TutorEmpresarial.objects.filter(cedula=cedula),
        )
        if self.instance:
            profile_querysets = tuple(
                queryset.exclude(usuario=self.instance)
                for queryset in profile_querysets
            )
        if any(queryset.exists() for queryset in profile_querysets):
            raise serializers.ValidationError(
                'Esta cédula ya está registrada.'
            )
        return cedula

    def validate_rol(self, value):
        allowed_roles = {
            'admin',
            'estudiante',
            'docente',
            'coordinador',
            'tutor_academico',
            'tutor_empresarial',
            'responsable_practicas',
        }
        normalized_role = value.strip().lower()
        if normalized_role not in allowed_roles:
            raise serializers.ValidationError('El rol seleccionado no es válido.')
        return normalized_role

    def validate(self, attrs):
        role = attrs.get('rol', self.instance.rol if self.instance else None)

        for field_name, field_label in (
            ('empresa', 'La empresa'),
            ('carrera', 'La carrera'),
            ('semestre', 'El semestre'),
            ('paralelo', 'El paralelo'),
        ):
            value = attrs.get(field_name)
            if value is not None and hasattr(value, 'estado') and not value.estado:
                raise serializers.ValidationError({
                    field_name: [
                        f'{field_label} está inactiva y no puede seleccionarse.'
                    ]
                })

        if role == 'tutor_empresarial' and not attrs.get('empresa'):
            existing_profile = (
                TutorEmpresarial.objects.filter(usuario=self.instance).first()
                if self.instance else None
            )
            if existing_profile is None:
                raise serializers.ValidationError({
                    'empresa_id': [
                        'La empresa es obligatoria para este rol de tutor.'
                    ]
                })
        if role in {'coordinador', 'tutor_academico'} and not attrs.get('carrera'):
            existing_profile = None
            if self.instance:
                profile_model = (
                    Coordinador if role == 'coordinador' else TutorAcademico
                )
                existing_profile = profile_model.objects.filter(
                    usuario=self.instance
                ).first()
            if existing_profile is None or existing_profile.carrera_id is None:
                raise serializers.ValidationError({
                    'carrera_id': ['La carrera es obligatoria para este rol.']
                })
        return attrs

    def _sync_profile(self, usuario, profile_data):
        if usuario.rol == 'estudiante':
            defaults = {
                key: profile_data[key]
                for key in (
                    'cedula', 'carrera', 'semestre', 'paralelo',
                    'empresa', 'tutor_academico', 'tutor_empresarial',
                )
                if key in profile_data
            }
            Estudiante.objects.update_or_create(usuario=usuario, defaults=defaults)
        elif usuario.rol == 'tutor_academico':
            TutorAcademico.objects.update_or_create(
                usuario=usuario,
                defaults={
                    'cedula': profile_data.get('cedula', ''),
                    'carrera': profile_data.get('carrera'),
                },
            )
        elif usuario.rol == 'tutor_empresarial':
            current_profile = TutorEmpresarial.objects.filter(
                usuario=usuario
            ).first()
            TutorEmpresarial.objects.update_or_create(
                usuario=usuario,
                defaults={
                    'cedula': profile_data.get(
                        'cedula', current_profile.cedula if current_profile else ''
                    ),
                    'cargo': profile_data.get(
                        'cargo', current_profile.cargo if current_profile else ''
                    ),
                    'empresa': profile_data.get(
                        'empresa', current_profile.empresa if current_profile else None
                    ),
                },
            )
        elif usuario.rol == 'docente':
            Docente.objects.update_or_create(
                usuario=usuario,
                defaults={'cedula': profile_data.get('cedula', '')},
            )
        elif usuario.rol == 'coordinador':
            Coordinador.objects.update_or_create(
                usuario=usuario,
                defaults={
                    'cedula': profile_data.get('cedula', ''),
                    'carrera': profile_data.get('carrera'),
                },
            )
        elif usuario.rol == 'responsable_practicas':
            ResponsablePracticas.objects.update_or_create(
                usuario=usuario,
                defaults={'cedula': profile_data.get('cedula', '')},
            )

    @transaction.atomic
    def create(self, validated_data):
        password = validated_data.pop('password', None)
        email = validated_data.pop('email')
        profile_data = {
            field: validated_data.pop(field)
            for field in (
                'cedula', 'cargo', 'carrera', 'semestre',
                'paralelo', 'empresa',
            )
            if field in validated_data
        }
        usuario = Usuario(
            username=email,
            email=email,
            **validated_data,
        )
        if password:
            usuario.set_password(password)
        else:
            usuario.set_unusable_password()
        usuario.save()
        self._sync_profile(usuario, profile_data)
        return usuario

    @transaction.atomic
    def update(self, instance, validated_data):
        password = validated_data.pop('password', None)
        profile_data = {
            field: validated_data.pop(field)
            for field in (
                'cedula', 'cargo', 'carrera', 'semestre',
                'paralelo', 'empresa',
            )
            if field in validated_data
        }
        for field, value in validated_data.items():
            setattr(instance, field, value)
        if password:
            instance.set_password(password)
        instance.save()
        self._sync_profile(instance, profile_data)
        return instance

    def to_representation(self, instance):
        data = super().to_representation(instance)
        profile = None
        if instance.rol == 'estudiante':
            profile = Estudiante.objects.filter(usuario=instance).first()
            if profile:
                data.update({
                    'cedula': profile.cedula,
                    'empresa': profile.empresa_id,
                    'empresa_id': profile.empresa_id,
                    'company_name': (
                        profile.empresa.nombre if profile.empresa else None
                    ),
                    'carrera_id': profile.carrera_id,
                })
                data['career_name'] = (
                    profile.carrera.nombre if profile.carrera else None
                )
                period = None
                if profile.carrera_id and profile.semestre_id:
                    period = CarreraPeriodo.objects.filter(
                        carrera_id=profile.carrera_id,
                        semestre_id=profile.semestre_id,
                        estado=True,
                    ).select_related('periodo').first()
                data['period_name'] = period.periodo.nombre if period else None
        elif instance.rol == 'tutor_academico':
            profile = TutorAcademico.objects.filter(usuario=instance).first()
            if profile:
                data['cedula'] = profile.cedula
                data['empresa_id'] = profile.empresa_id
                data['carrera_id'] = profile.carrera_id
                data['career_name'] = (
                    profile.carrera.nombre if profile.carrera else None
                )
                data['company_name'] = (
                    profile.empresa.nombre if profile.empresa else None
                )
        elif instance.rol == 'tutor_empresarial':
            profile = TutorEmpresarial.objects.filter(usuario=instance).first()
            if profile:
                data.update({
                    'cedula': profile.cedula,
                    'cargo': profile.cargo,
                    'empresa': profile.empresa_id,
                    'empresa_id': profile.empresa_id,
                    'company_name': profile.empresa.nombre,
                })
        elif instance.rol == 'docente':
            profile = Docente.objects.filter(usuario=instance).first()
            if profile:
                data['cedula'] = profile.cedula
        elif instance.rol == 'coordinador':
            profile = Coordinador.objects.filter(usuario=instance).first()
            if profile:
                data['cedula'] = profile.cedula
                data['carrera_id'] = profile.carrera_id
                data['career_name'] = (
                    profile.carrera.nombre if profile.carrera else None
                )
        elif instance.rol == 'responsable_practicas':
            profile = ResponsablePracticas.objects.filter(usuario=instance).first()
            if profile:
                data['cedula'] = profile.cedula
        return data


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


class ResponsablePracticasSerializer(serializers.ModelSerializer):
    usuario = UsuarioSerializer(read_only=True)

    class Meta:
        model = ResponsablePracticas
        fields = ['id', 'usuario', 'cedula']


class TutorAcademicoSerializer(serializers.ModelSerializer):
    usuario = UsuarioSerializer(read_only=True)

    class Meta:
        model = TutorAcademico
        fields = ['id', 'usuario', 'cedula', 'empresa']


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
            'cedula',
            'carrera',
            'semestre',
            'paralelo',
            'empresa',
            'tutor_academico',
            'tutor_empresarial',
        ]