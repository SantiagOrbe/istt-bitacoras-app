from django.contrib.gis.geos import Point
from django.utils import timezone
from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.exceptions import ValidationError
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response

from usuarios.models import Estudiante, TutorAcademico, TutorEmpresarial
from .models import Actividad, RegistroPractica, VisitaTutorAcademico
from .serializers import ActividadSerializer, RegistroPracticaSerializer, VisitaTutorAcademicoSerializer
from .services import GeofencingService


class RegistroPracticaViewSet(viewsets.ModelViewSet):
    queryset = RegistroPractica.objects.all()
    serializer_class = RegistroPracticaSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return RegistroPractica.objects.para_usuario(self.request.user)

    def perform_create(self, serializer):
        user = self.request.user
        estudiante = Estudiante.objects.filter(usuario=user).first()
        if estudiante and not serializer.validated_data.get('estudiante'):
            serializer.save(estudiante=estudiante)
        else:
            serializer.save()

    def update(self, request, *args, **kwargs):
        partial = kwargs.pop('partial', False)
        instance = self.get_object()

        actividad_descripcion = request.data.get('actividad_descripcion')
        if actividad_descripcion is None:
            actividad_descripcion = request.data.get('descripcion')

        if actividad_descripcion is not None:
            actividad = instance.actividades.order_by('-id').first()
            if actividad is None:
                Actividad.objects.create(
                    registro_practica=instance,
                    descripcion=str(actividad_descripcion),
                    estado=True,
                )
            else:
                actividad.descripcion = str(actividad_descripcion)
                actividad.save(update_fields=['descripcion'])

        if 'estado' in request.data:
            estado_raw = request.data.get('estado')
            if isinstance(estado_raw, str):
                estado_value = estado_raw.strip().lower() not in {'false', '0', 'no', 'inactivo', 'desactivado'}
            else:
                estado_value = bool(estado_raw)
            instance.estado = estado_value
            instance.save(update_fields=['estado'])

        serializer = self.get_serializer(instance, data=request.data, partial=partial)
        serializer.is_valid(raise_exception=True)
        self.perform_update(serializer)
        return Response(serializer.data)

    @action(detail=False, methods=['get'], url_path='mi-avance')
    def mi_avance(self, request):
        usuario = request.user
        estudiante = Estudiante.objects.filter(usuario=usuario).first()

        if not estudiante:
            return Response(
                {'error': 'El usuario autenticado no tiene un perfil de estudiante asociado.'},
                status=status.HTTP_404_NOT_FOUND,
            )

        avance = estudiante.get_avance_practicas()
        return Response(avance, status=status.HTTP_200_OK)

    @action(detail=False, methods=['post'], url_path='check-in')
    def check_in(self, request):
        user = request.user
        estudiante = Estudiante.objects.filter(usuario=user).first()
        latitud = request.data.get('latitud')
        longitud = request.data.get('longitud')

        try:
            registro = GeofencingService.realizar_check_in(estudiante, latitud, longitud)
            serializer = self.get_serializer(registro)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        except ValidationError as e:
            detail = e.detail if hasattr(e, 'detail') else {'error': str(e)}
            return Response(detail, status=status.HTTP_400_BAD_REQUEST)

    @action(detail=False, methods=['post'], url_path='check-out')
    def check_out(self, request):
        user = request.user
        estudiante = Estudiante.objects.filter(usuario=user).first()
        latitud = request.data.get('latitud')
        longitud = request.data.get('longitud')

        try:
            registro = GeofencingService.realizar_check_out(estudiante, latitud, longitud)
            serializer = self.get_serializer(registro)
            return Response(serializer.data, status=status.HTTP_200_OK)
        except ValidationError as e:
            detail = e.detail if hasattr(e, 'detail') else {'error': str(e)}
            status_code = status.HTTP_404_NOT_FOUND if 'No se encontró' in str(detail) else status.HTTP_400_BAD_REQUEST
            return Response(detail, status=status_code)


class VisitaTutorAcademicoViewSet(viewsets.ModelViewSet):
    serializer_class = VisitaTutorAcademicoSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return VisitaTutorAcademico.objects.filter(tutor__usuario=self.request.user).select_related('empresa')

    def _serialize_state(self, visita):
        data = self.get_serializer(visita).data
        has_entry = visita is not None
        has_exit = has_entry and visita.hora_salida is not None
        has_activities = has_entry and bool(visita.actividades.strip())
        data.update({
            'tiene_entrada': has_entry,
            'tiene_salida': has_exit,
            'tiene_actividades': has_activities,
            'puede_registrar_entrada': not has_entry,
            'puede_registrar_salida': has_activities and not has_exit,
            'puede_registrar_actividades': has_entry and not has_exit and not has_activities,
        })
        return data

    def perform_create(self, serializer):
        tutor = TutorAcademico.objects.filter(usuario=self.request.user).select_related('empresa').first()
        if tutor is None:
            raise ValidationError({'detail': 'El usuario no es tutor académico.'})
        empresa = tutor.get_empresa_asignada()
        if empresa is None:
            raise ValidationError({'detail': 'El tutor académico no tiene una empresa asignada.'})
        serializer.save(tutor=tutor, empresa=empresa)

    @action(detail=False, methods=['get'], url_path='estado-hoy')
    def estado_hoy(self, request):
        visita = self.get_queryset().filter(fecha=timezone.localdate()).first()
        return Response(
            self._serialize_state(visita) if visita else {
                'tiene_entrada': False,
                'tiene_salida': False,
                'puede_registrar_entrada': True,
                'puede_registrar_salida': False,
                'puede_registrar_actividades': False,
            }
        )

    @action(detail=False, methods=['post'], url_path='entrada')
    def entrada(self, request):
        tutor = TutorAcademico.objects.filter(usuario=request.user).select_related('empresa').first()
        empresa = tutor.get_empresa_asignada() if tutor else None
        if tutor is None or empresa is None:
            raise ValidationError({'detail': 'El tutor académico no tiene una empresa asignada.'})
        if self.get_queryset().filter(fecha=timezone.localdate(), hora_salida__isnull=True).exists():
            raise ValidationError({'detail': 'Ya existe una visita activa para hoy.'})

        latitud = request.data.get('latitud')
        longitud = request.data.get('longitud')
        if latitud is None or longitud is None:
            raise ValidationError({'detail': 'Se requieren latitud y longitud.'})

        lat = float(latitud)
        lon = float(longitud)
        distancia = GeofencingService._distancia_a_empresa(empresa, lat, lon)
        if distancia is None or distancia > (empresa.radio_permitido or 50.0):
            raise ValidationError({'detail': 'El tutor está fuera del rango permitido de la empresa.'})

        visita = VisitaTutorAcademico.objects.create(
            tutor=tutor,
            empresa=empresa,
            fecha=timezone.localdate(),
            hora_entrada=timezone.localtime().time(),
            ubicacion_entrada=Point(lon, lat, srid=4326),
        )
        return Response(self.get_serializer(visita).data, status=status.HTTP_201_CREATED)

    @action(detail=False, methods=['post'], url_path='salida')
    def salida(self, request):
        visita = self.get_queryset().filter(fecha=timezone.localdate(), hora_salida__isnull=True).first()
        if visita is None:
            raise ValidationError({'detail': 'No existe una visita activa para cerrar.'})
        if not visita.actividades.strip():
            raise ValidationError({'detail': 'Debes registrar las actividades antes de registrar la salida.'})

        latitud = request.data.get('latitud')
        longitud = request.data.get('longitud')
        if latitud is None or longitud is None:
            raise ValidationError({'detail': 'Se requieren latitud y longitud para registrar la salida.'})

        try:
            lat = float(latitud)
            lon = float(longitud)
        except (TypeError, ValueError):
            raise ValidationError({'detail': 'Latitud y longitud deben ser valores numéricos válidos.'})

        distancia = GeofencingService._distancia_a_empresa(visita.empresa, lat, lon)
        if distancia is None or distancia > (visita.empresa.radio_permitido or 50.0):
            raise ValidationError({'detail': 'El tutor está fuera del rango permitido de la empresa.'})

        visita.hora_salida = timezone.localtime().time()
        visita.ubicacion_salida = Point(lon, lat, srid=4326)
        visita.estado = False
        visita.save(update_fields=['hora_salida', 'ubicacion_salida', 'estado'])
        return Response(self.get_serializer(visita).data)


class ActividadViewSet(viewsets.ModelViewSet):
    queryset = Actividad.objects.all()
    serializer_class = ActividadSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        user = self.request.user
        if user.is_staff or user.is_superuser:
            return Actividad.objects.all()

        estudiante = Estudiante.objects.filter(usuario=user).first()
        if estudiante:
            return Actividad.objects.filter(registro_practica__estudiante=estudiante)

        tutor_academico = TutorAcademico.objects.filter(usuario=user).first()
        if tutor_academico:
            return Actividad.objects.filter(registro_practica__estudiante__tutor_academico=tutor_academico)

        tutor_empresarial = TutorEmpresarial.objects.filter(usuario=user).first()
        if tutor_empresarial:
            return Actividad.objects.filter(registro_practica__estudiante__tutor_empresarial=tutor_empresarial)

        rol = getattr(user, 'rol', None)
        if rol == 'coordinador':
            return Actividad.objects.all()

        return Actividad.objects.none()

    def perform_create(self, serializer):
        user = self.request.user
        estudiante = Estudiante.objects.filter(usuario=user).first()
        if estudiante:
            registro_practica = serializer.validated_data.get('registro_practica')
            if registro_practica and registro_practica.estudiante != estudiante:
                from rest_framework.exceptions import PermissionDenied
                raise PermissionDenied("No puedes crear actividades para registros de práctica de otros estudiantes.")
        serializer.save()
