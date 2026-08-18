from django.db import models


class Periodo(models.Model):
    nombre = models.CharField(max_length=100)
    fecha_inicio = models.DateField()
    fecha_fin = models.DateField()
    estado = models.BooleanField(default=True)

    def __str__(self):
        return self.nombre


class Carrera(models.Model):
    nombre = models.CharField(max_length=150)
    descripcion = models.TextField()
    codigo_carrera = models.CharField(max_length=50)
    sigla_carrera = models.CharField(max_length=20)
    modalidad = models.CharField(max_length=50)
    estado = models.BooleanField(default=True)

    def __str__(self):
        return self.nombre


class CarreraPeriodo(models.Model):
    carrera = models.ForeignKey(Carrera, on_delete=models.CASCADE)
    periodo = models.ForeignKey(Periodo, on_delete=models.CASCADE)
    estado = models.BooleanField(default=True)

    def __str__(self):
        return f'{self.carrera} - {self.periodo}'


class Ciclo(models.Model):
    nombre = models.CharField(max_length=50)
    nivel = models.IntegerField()
    estado = models.BooleanField(default=True)
    carrera = models.ForeignKey(Carrera, on_delete=models.CASCADE)

    def __str__(self):
        return self.nombre


class Paralelo(models.Model):
    nombre = models.CharField(max_length=50)
    jornada = models.CharField(max_length=50)
    estado = models.BooleanField(default=True)
    ciclo = models.ForeignKey(Ciclo, on_delete=models.CASCADE)

    def __str__(self):
        return f'{self.ciclo} - {self.nombre}'


class ResultadoAprendizaje(models.Model):
    nombre = models.CharField(max_length=200)
    estado = models.BooleanField(default=True)
    carrera = models.ForeignKey(
        Carrera, on_delete=models.CASCADE, null=True, blank=True
    )

    def __str__(self):
        return self.nombre