from django.contrib.gis.db import models

from usuarios.models import Estudiante
from usuarios.models import TutorAcademico
from empresas.models import Empresa
from .managers import RegistroPracticaManager


class RegistroPractica(models.Model):
    fecha = models.DateField()
    hora_entrada = models.TimeField()
    hora_salida = models.TimeField(null=True, blank=True)
    ubicacion_entrada = models.PointField(
        srid=4326, geography=True, null=True, blank=True
    )
    ubicacion_salida = models.PointField(
        srid=4326, geography=True, null=True, blank=True
    )
    estado = models.BooleanField(default=True)
    estudiante = models.ForeignKey(Estudiante, on_delete=models.CASCADE)

    objects = RegistroPracticaManager()

    def __str__(self):
        return f'{self.estudiante} - {self.fecha}'


class VisitaTutorAcademico(models.Model):
    tutor = models.ForeignKey(TutorAcademico, on_delete=models.CASCADE, related_name='visitas')
    empresa = models.ForeignKey(Empresa, on_delete=models.PROTECT, related_name='visitas_tutor_academico')
    fecha = models.DateField()
    hora_entrada = models.TimeField()
    hora_salida = models.TimeField(null=True, blank=True)
    ubicacion_entrada = models.PointField(srid=4326, geography=True, null=True, blank=True)
    ubicacion_salida = models.PointField(srid=4326, geography=True, null=True, blank=True)
    actividades = models.TextField(blank=True)
    estado = models.BooleanField(default=True)

    class Meta:
        ordering = ['-fecha', '-hora_entrada', '-id']

    def __str__(self):
        return f'{self.tutor.usuario} - {self.empresa} - {self.fecha}'


class Actividad(models.Model):
    descripcion = models.TextField()
    estado = models.BooleanField(default=True)
    registro_practica = models.ForeignKey(
        RegistroPractica, on_delete=models.CASCADE, related_name='actividades'
    )

    def __str__(self):
        return self.descripcion[:50]
