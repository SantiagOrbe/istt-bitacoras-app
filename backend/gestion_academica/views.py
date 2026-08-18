from rest_framework import viewsets
from rest_framework.permissions import IsAuthenticated

from .models import (
    Carrera,
    CarreraPeriodo,
    Ciclo,
    Paralelo,
    Periodo,
    ResultadoAprendizaje,
)
from .serializers import (
    CarreraPeriodoSerializer,
    CarreraSerializer,
    CicloSerializer,
    ParaleloSerializer,
    PeriodoSerializer,
    ResultadoAprendizajeSerializer,
)


class PeriodoViewSet(viewsets.ModelViewSet):
    queryset = Periodo.objects.all()
    serializer_class = PeriodoSerializer
    permission_classes = [IsAuthenticated]


class CarreraViewSet(viewsets.ModelViewSet):
    queryset = Carrera.objects.all()
    serializer_class = CarreraSerializer
    permission_classes = [IsAuthenticated]


class CarreraPeriodoViewSet(viewsets.ModelViewSet):
    queryset = CarreraPeriodo.objects.all()
    serializer_class = CarreraPeriodoSerializer
    permission_classes = [IsAuthenticated]


class CicloViewSet(viewsets.ModelViewSet):
    queryset = Ciclo.objects.all()
    serializer_class = CicloSerializer
    permission_classes = [IsAuthenticated]


class ParaleloViewSet(viewsets.ModelViewSet):
    queryset = Paralelo.objects.all()
    serializer_class = ParaleloSerializer
    permission_classes = [IsAuthenticated]


class ResultadoAprendizajeViewSet(viewsets.ModelViewSet):
    queryset = ResultadoAprendizaje.objects.all()
    serializer_class = ResultadoAprendizajeSerializer
    permission_classes = [IsAuthenticated]