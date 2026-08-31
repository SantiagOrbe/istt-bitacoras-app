from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.exceptions import ValidationError
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response

from usuarios.models import Estudiante, TutorAcademico, TutorEmpresarial
from .models import Actividad, RegistroPractica
from .serializers import ActividadSerializer, RegistroPracticaSerializer
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
        if rol in ['coordinador', 'docente']:
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
