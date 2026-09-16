from rest_framework import status, viewsets
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


class ResultadoAprendizajeViewSet(SoftDeleteViewSet):
    queryset = ResultadoAprendizaje.objects.all()
    serializer_class = ResultadoAprendizajeSerializer
    permission_classes = [IsAuthenticated]