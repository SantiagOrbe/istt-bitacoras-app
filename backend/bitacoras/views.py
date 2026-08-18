from rest_framework import viewsets
from rest_framework.permissions import IsAuthenticated

from .models import Actividad, RegistroPractica
from .serializers import ActividadSerializer, RegistroPracticaSerializer


class RegistroPracticaViewSet(viewsets.ModelViewSet):
    queryset = RegistroPractica.objects.all()
    serializer_class = RegistroPracticaSerializer
    permission_classes = [IsAuthenticated]


class ActividadViewSet(viewsets.ModelViewSet):
    queryset = Actividad.objects.all()
    serializer_class = ActividadSerializer
    permission_classes = [IsAuthenticated]