from django.contrib.gis.db import models


class Empresa(models.Model):
    nombre = models.CharField(max_length=150)
    direccion = models.CharField(max_length=255)
    telefono = models.CharField(max_length=15)
    correo = models.EmailField()
    radio_permitido = models.FloatField()
    estado = models.BooleanField(default=True)
    ubicacion = models.PointField(
        srid=4326, geography=True, null=True, blank=True
    )

    def __str__(self):
        return self.nombre