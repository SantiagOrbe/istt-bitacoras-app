from django.db import transaction
from rest_framework import status, viewsets
from rest_framework.decorators import action
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response

from .models import (
    Carrera,
    CarreraPeriodo,
    Semestre,
    Paralelo,
    Periodo,
    ResultadoAprendizaje,
)
from .serializers import (
    CarreraPeriodoSerializer,
    CarreraSerializer,
    SemestreSerializer,
    ParaleloSerializer,
    PeriodoSerializer,
    ResultadoAprendizajeSerializer,
)
from usuarios.models import Estudiante


class SoftDeleteViewSet(viewsets.ModelViewSet):
    status_field = 'estado'

    def destroy(self, request, *args, **kwargs):
        instance = self.get_object()
        setattr(instance, self.status_field, False)
        instance.save(update_fields=[self.status_field])
        return Response(status=status.HTTP_204_NO_CONTENT)


class PeriodoViewSet(SoftDeleteViewSet):
    queryset = Periodo.objects.all()
    serializer_class = PeriodoSerializer
    permission_classes = [IsAuthenticated]


class CarreraViewSet(SoftDeleteViewSet):
    queryset = Carrera.objects.all()
    serializer_class = CarreraSerializer
    permission_classes = [IsAuthenticated]


class CarreraPeriodoViewSet(SoftDeleteViewSet):
    queryset = CarreraPeriodo.objects.all()
    serializer_class = CarreraPeriodoSerializer
    permission_classes = [IsAuthenticated]


class SemestreViewSet(SoftDeleteViewSet):
    queryset = Semestre.objects.all()
    serializer_class = SemestreSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        queryset = Semestre.objects.all()
        carrera_id = self.request.query_params.get('carrera')
        if carrera_id:
            queryset = queryset.filter(carrera_id=carrera_id)
        return queryset


class ParaleloViewSet(SoftDeleteViewSet):
    queryset = Paralelo.objects.all()
    serializer_class = ParaleloSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        queryset = Paralelo.objects.all()
        semestre_id = self.request.query_params.get('semestre')
        carrera_id = self.request.query_params.get('carrera')
        if semestre_id:
            queryset = queryset.filter(semestre_id=semestre_id)
        if carrera_id:
            queryset = queryset.filter(semestre__carrera_id=carrera_id)
        return queryset

    @action(detail=True, methods=['get', 'post', 'delete'], url_path='estudiantes')
    def estudiantes(self, request, pk=None):
        paralelo = self.get_object()
        carrera_id = paralelo.semestre.carrera_id
        estudiantes = Estudiante.objects.filter(carrera_id=carrera_id).select_related(
            'usuario', 'paralelo'
        )
        if request.method == 'DELETE':
            removed = estudiantes.filter(paralelo=paralelo).update(
                semestre=None,
                paralelo=None,
            )
            return Response({'retirados': removed})

        if request.method == 'GET':
            return Response([
                {
                    'id': estudiante.id,
                    'usuario_id': estudiante.usuario_id,
                    'nombre': estudiante.usuario.get_full_name(),
                    'email': estudiante.usuario.email,
                    'cedula': estudiante.cedula,
                    'paralelo_id': estudiante.paralelo_id,
                    'seleccionado': estudiante.paralelo_id == paralelo.id,
                    'bloqueado': (
                        estudiante.paralelo_id is not None
                        and estudiante.paralelo_id != paralelo.id
                    ),
                }
                for estudiante in estudiantes
            ])

        student_ids = request.data.get('estudiante_ids')
        if not isinstance(student_ids, list):
            return Response(
                {'estudiante_ids': 'Debe enviar una lista de estudiantes.'},
                status=status.HTTP_400_BAD_REQUEST,
            )
        selected = estudiantes.filter(id__in=student_ids)
        with transaction.atomic():
            requested = estudiantes.select_for_update().filter(id__in=student_ids)
            conflicts = requested.exclude(paralelo__isnull=True).exclude(
                paralelo=paralelo
            )
            if conflicts.exists():
                return Response(
                    {
                        'detail': (
                            'Uno o más estudiantes ya pertenecen a otro paralelo '
                            'de esta carrera.'
                        ),
                        'estudiante_ids': list(
                            conflicts.values_list('id', flat=True)
                        ),
                    },
                    status=status.HTTP_409_CONFLICT,
                )

            selected = requested
            selected.update(
                semestre=paralelo.semestre,
                paralelo=paralelo,
            )
            estudiantes.filter(paralelo=paralelo).exclude(
                id__in=student_ids
            ).update(paralelo=None)
        return Response({'asignados': selected.count()})


class ResultadoAprendizajeViewSet(SoftDeleteViewSet):
    queryset = ResultadoAprendizaje.objects.all()
    serializer_class = ResultadoAprendizajeSerializer
    permission_classes = [IsAuthenticated]