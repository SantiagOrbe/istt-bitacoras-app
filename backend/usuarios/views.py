import logging

from django.db import DatabaseError, IntegrityError
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from .models import (
    Coordinador,
    Docente,
    Estudiante,
    TutorAcademico,
    TutorEmpresarial,
)
from .serializers import (
    CoordinadorSerializer,
    DocenteSerializer,
    EstudianteSerializer,
    TutorAcademicoSerializer,
    TutorEmpresarialSerializer,
    RegistroSerializer,
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


class PerfilView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        usuario = request.user
        data = UsuarioSerializer(usuario).data

        perfil_map = {
            'estudiante': (Estudiante, EstudianteSerializer),
            'docente': (Docente, DocenteSerializer),
            'coordinador': (Coordinador, CoordinadorSerializer),
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