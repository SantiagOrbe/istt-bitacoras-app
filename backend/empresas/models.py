from django.contrib.gis.db import models
from django.contrib.gis.geos import Point


""" Modelos de la Entidad Empresa """
class Empresa(models.Model):
    nombre = models.CharField(max_length=150)
    direccion = models.CharField(max_length=255)
    telefono = models.CharField(max_length=15)
    correo = models.EmailField()
    latitud = models.FloatField(
        null=True,
        blank=True,
        help_text='Latitud WGS84, ejemplo: -0.1807',
    )
    longitud = models.FloatField(
        null=True,
        blank=True,
        help_text='Longitud WGS84, ejemplo: -78.4834',
    )
    radio_permitido = models.FloatField(default=50.0)
    estado = models.BooleanField(default=True)
    ubicacion = models.PointField(
        srid=4326, geography=True, null=True, blank=True
    )

    @property
    def coordenadas(self):
        if self.ubicacion:
            return {
                'latitud': self.ubicacion.y,
                'longitud': self.ubicacion.x,
            }
        return {
            'latitud': self.latitud,
            'longitud': self.longitud,
        }

    def guardar_ubicacion(self, latitud, longitud):
        self.latitud = float(latitud)
        self.longitud = float(longitud)
        self.ubicacion = Point(float(longitud), float(latitud), srid=4326)
        return self

    def esta_dentro_del_rango(self, latitud, longitud):
        if self.ubicacion is None and (self.latitud is None or self.longitud is None):
            return False

        punto_actual = Point(float(longitud), float(latitud), srid=4326)
        punto_empresa = self.ubicacion or Point(
            float(self.longitud), float(self.latitud), srid=4326
        )
        distancia_metros = punto_empresa.distance(punto_actual)
        return distancia_metros <= (self.radio_permitido or 0)

    def __str__(self):
        return self.nombre