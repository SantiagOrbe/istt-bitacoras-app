import logging

from django.db import DatabaseError, IntegrityError
from django.db.models import Q
from rest_framework import viewsets
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from .models import (
    Coordinador,
    Docente,
    Estudiante,
    ResponsablePracticas,
    TutorAcademico,
    TutorEmpresarial,
    Usuario,
)
from .serializers import (
    CoordinadorSerializer,
    DocenteSerializer,
    EstudianteSerializer,
    ResponsablePracticasSerializer,
    TutorAcademicoSerializer,
    TutorEmpresarialSerializer,
    RegistroSerializer,
    UsuarioAdminSerializer,
    UsuarioSerializer,
)

logger = logging.getLogger(__name__)


class RegistroView(APIView):
    permission_classes = []

    def post(self, request):
        serializer = RegistroSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        try:
            usuario = serializer.save()
        except IntegrityError:
            logger.exception('Error de integridad durante el registro')
            return Response(
                {
                    'detail': (
                        'No fue posible crear la cuenta porque los datos '
                        'entran en conflicto con un registro existente.'
                    )
                },
                status=409,
            )
        except DatabaseError:
            logger.exception('Error de base de datos durante el registro')
            return Response(
                {
                    'detail': (
                        'No fue posible completar el registro. '
                        'Inténtelo nuevamente.'
                    )
                },
                status=503,
            )
        except Exception:
            logger.exception('Error inesperado durante el registro')
            return Response(
                {
                    'detail': (
                        'Ocurrió un error inesperado al crear la cuenta.'
                    )
                },
                status=500,
            )
        return Response(
            UsuarioSerializer(usuario).data,
            status=201,
        )


class UsuarioViewSet(viewsets.ModelViewSet):
    queryset = Usuario.objects.all().order_by('id')
    serializer_class = UsuarioAdminSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        queryset = super().get_queryset()
        is_active = self.request.query_params.get('is_active')
        role = self.request.query_params.get('rol')
        search = self.request.query_params.get('search', '').strip()

        if is_active is not None:
            normalized = is_active.lower()
            if normalized in {'true', '1', 'si', 'sí'}:
                queryset = queryset.filter(estado=True, is_active=True)
            elif normalized in {'false', '0', 'no'}:
                queryset = queryset.filter(estado=False, is_active=False)

        if role and role.lower() != 'todos':
            queryset = queryset.filter(rol__iexact=role.strip())

        if search:
            queryset = queryset.filter(
                Q(first_name__icontains=search)
                | Q(last_name__icontains=search)
                | Q(email__icontains=search)
            )
        return queryset

    def destroy(self, request, *args, **kwargs):
        usuario = self.get_object()
        usuario.estado = False
        usuario.is_active = False
        usuario.save(update_fields=['estado', 'is_active'])
        return Response(status=204)


class PerfilView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        usuario = request.user
        data = UsuarioSerializer(usuario).data

        perfil_map = {
            'estudiante': (Estudiante, EstudianteSerializer),
            'docente': (Docente, DocenteSerializer),
            'coordinador': (Coordinador, CoordinadorSerializer),
            'responsable_practicas': (
                ResponsablePracticas,
                ResponsablePracticasSerializer,
            ),
            'tutor_academico': (TutorAcademico, TutorAcademicoSerializer),
            'tutor_empresarial': (
                TutorEmpresarial,
                TutorEmpresarialSerializer,
            ),
        }

        perfil = None
        if usuario.rol in perfil_map:
            model, serializer_class = perfil_map[usuario.rol]
            instancia = model.objects.filter(usuario=usuario).first()
            if instancia:
                perfil = serializer_class(instancia).data

        data['perfil'] = perfil
        return Response(data)