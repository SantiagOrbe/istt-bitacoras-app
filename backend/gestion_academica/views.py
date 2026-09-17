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
    queryset = Periodo.objects.all().order_by('-estado', '-fecha_inicio', '-id')
    serializer_class = PeriodoSerializer
    permission_classes = [IsAuthenticated]

    @staticmethod
    def _parse_estado(value):
        if isinstance(value, bool):
            return value
        if value is None:
            return None
        if isinstance(value, (int, float)):
            return bool(value)
        text = str(value).strip().lower()
        if text in {'false', '0', 'no', 'off'}:
            return False
        if text in {'true', '1', 'yes', 'on'}:
            return True
        return bool(text)

    def _check_desactivacion_confirmada(self, periodo, request):
        estado_nuevo = self._parse_estado(request.data.get('estado'))
        if estado_nuevo is not False:
            return None
        if request.data.get('confirm_desactivate') in {True, 'true', '1', 1}:
            return None

        semestres_vinculados = CarreraPeriodo.objects.filter(periodo=periodo).exists()
        if not semestres_vinculados:
            return None

        return Response(
            {
                'detail': (
                    'Este periodo tiene semestres asignados de carreras y debe '
                    'confirmarse la desactivación para continuar.'
                ),
                'semestres_vinculados': True,
            },
            status=status.HTTP_400_BAD_REQUEST,
        )

    def update(self, request, *args, **kwargs):
        periodo = self.get_object()
        blocked = self._check_desactivacion_confirmada(periodo, request)
        if blocked is not None:
            return blocked
        return super().update(request, *args, **kwargs)

    def partial_update(self, request, *args, **kwargs):
        periodo = self.get_object()
        blocked = self._check_desactivacion_confirmada(periodo, request)
        if blocked is not None:
            return blocked
        return super().partial_update(request, *args, **kwargs)


class CarreraViewSet(SoftDeleteViewSet):
    queryset = Carrera.objects.all()
    serializer_class = CarreraSerializer
    permission_classes = [IsAuthenticated]

    @staticmethod
    def _parse_estado(value):
        if isinstance(value, bool):
            return value
        if value is None:
            return None
        if isinstance(value, (int, float)):
            return bool(value)
        text = str(value).strip().lower()
        if text in {'false', '0', 'no', 'off'}:
            return False
        if text in {'true', '1', 'yes', 'on'}:
            return True
        return bool(text)

    def _sync_semestres_y_relaciones(self, carrera, estado):
        Semestre.objects.filter(carrera=carrera).update(estado=estado)
        CarreraPeriodo.objects.filter(carrera=carrera).update(estado=estado)

    def _check_desactivacion_confirmada(self, carrera, request):
        estado_nuevo = self._parse_estado(request.data.get('estado'))
        if estado_nuevo is not False:
            return None
        if request.data.get('confirm_desactivate') in {True, 'true', '1', 1}:
            return None

        usuarios_vinculados = Estudiante.objects.filter(carrera=carrera).count()
        semestres_vinculados = Semestre.objects.filter(carrera=carrera).count()
        if not usuarios_vinculados and not semestres_vinculados:
            return None

        return Response(
            {
                'detail': (
                    'La carrera tiene usuarios o semestres vinculados; '
                    'confirma la desactivación para continuar.'
                ),
                'usuarios_vinculados': usuarios_vinculados,
                'semestres_vinculados': semestres_vinculados,
            },
            status=status.HTTP_400_BAD_REQUEST,
        )

    def update(self, request, *args, **kwargs):
        carrera = self.get_object()
        blocked = self._check_desactivacion_confirmada(carrera, request)
        if blocked is not None:
            return blocked

        estado = self._parse_estado(request.data.get('estado'))
        if estado is not None:
            self._sync_semestres_y_relaciones(carrera, estado)

        return super().update(request, *args, **kwargs)

    def partial_update(self, request, *args, **kwargs):
        carrera = self.get_object()
        blocked = self._check_desactivacion_confirmada(carrera, request)
        if blocked is not None:
            return blocked

        estado = self._parse_estado(request.data.get('estado'))
        if estado is not None:
            self._sync_semestres_y_relaciones(carrera, estado)

        return super().partial_update(request, *args, **kwargs)

    def destroy(self, request, *args, **kwargs):
        carrera = self.get_object()
        if request.data.get('confirm_desactivate') not in {True, 'true', '1', 1}:
            usuarios_vinculados = Estudiante.objects.filter(carrera=carrera).count()
            semestres_vinculados = Semestre.objects.filter(carrera=carrera).count()
            if usuarios_vinculados or semestres_vinculados:
                return Response(
                    {
                        'detail': (
                            'La carrera tiene usuarios o semestres vinculados; '
                            'confirma la desactivación para continuar.'
                        ),
                        'usuarios_vinculados': usuarios_vinculados,
                        'semestres_vinculados': semestres_vinculados,
                    },
                    status=status.HTTP_400_BAD_REQUEST,
                )
        self._sync_semestres_y_relaciones(carrera, False)
        return super().destroy(request, *args, **kwargs)


class CarreraPeriodoViewSet(SoftDeleteViewSet):
    queryset = CarreraPeriodo.objects.all()
    serializer_class = CarreraPeriodoSerializer
    permission_classes = [IsAuthenticated]


class SemestreViewSet(SoftDeleteViewSet):
    queryset = Semestre.objects.all()
    serializer_class = SemestreSerializer
    permission_classes = [IsAuthenticated]

    @staticmethod
    def _parse_estado(value):
        if value is None:
            return None
        if isinstance(value, bool):
            return value
        text = str(value).strip().lower()
        if text in {'true', '1', 'yes', 'on'}:
            return True
        if text in {'false', '0', 'no', 'off'}:
            return False
        return None

    def _sync_carrera_periodos(self, semestre, estado):
        CarreraPeriodo.objects.filter(semestre=semestre).update(estado=estado)

    def update(self, request, *args, **kwargs):
        semestre = self.get_object()
        estado = self._parse_estado(request.data.get('estado'))
        if estado is not None:
            self._sync_carrera_periodos(semestre, estado)
        return super().update(request, *args, **kwargs)

    def partial_update(self, request, *args, **kwargs):
        semestre = self.get_object()
        estado = self._parse_estado(request.data.get('estado'))
        if estado is not None:
            self._sync_carrera_periodos(semestre, estado)
        return super().partial_update(request, *args, **kwargs)

    def destroy(self, request, *args, **kwargs):
        semestre = self.get_object()
        self._sync_carrera_periodos(semestre, False)
        return super().destroy(request, *args, **kwargs)

    def get_queryset(self):
        queryset = Semestre.objects.all()
        carrera_id = self.request.query_params.get('carrera')
        if carrera_id:
            queryset = queryset.filter(carrera_id=carrera_id)

        estado = self._parse_estado(self.request.query_params.get('estado'))
        if estado is not None:
            queryset = queryset.filter(estado=estado)
        return queryset


class ParaleloViewSet(SoftDeleteViewSet):
    queryset = Paralelo.objects.all()
    serializer_class = ParaleloSerializer
    permission_classes = [IsAuthenticated]

    @staticmethod
    def _parse_estado(value):
        if value is None:
            return None
        if isinstance(value, bool):
            return value
        text = str(value).strip().lower()
        if text in {'true', '1', 'yes', 'on'}:
            return True
        if text in {'false', '0', 'no', 'off'}:
            return False
        return None

    def get_queryset(self):
        queryset = Paralelo.objects.all()
        semestre_id = self.request.query_params.get('semestre')
        carrera_id = self.request.query_params.get('carrera')
        if semestre_id:
            queryset = queryset.filter(semestre_id=semestre_id)
        if carrera_id:
            queryset = queryset.filter(semestre__carrera_id=carrera_id)

        estado = self._parse_estado(self.request.query_params.get('estado'))
        if estado is not None:
            queryset = queryset.filter(estado=estado)
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