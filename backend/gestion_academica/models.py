from django.db import models


class Periodo(models.Model):
    nombre = models.CharField(max_length=100)
    fecha_inicio = models.DateField()
    fecha_fin = models.DateField()
    estado = models.BooleanField(default=True)

    class Meta:
        ordering = ['-estado', '-fecha_inicio', '-id']
        constraints = [
            models.UniqueConstraint(
                fields=['nombre'], name='unique_periodo_nombre'
            ),
        ]

    def __str__(self):
        return self.nombre


class Carrera(models.Model):
    nombre = models.CharField(max_length=150)
    descripcion = models.TextField()
    codigo_carrera = models.CharField(max_length=50)
    sigla_carrera = models.CharField(max_length=20)
    modalidad = models.CharField(max_length=50)
    total_semestres = models.PositiveIntegerField(default=0)
    estado = models.BooleanField(default=True)

    class Meta:
        constraints = [
            models.UniqueConstraint(
                fields=['nombre'], name='unique_carrera_nombre'
            ),
            models.UniqueConstraint(
                fields=['codigo_carrera'], name='unique_carrera_codigo'
            ),
            models.UniqueConstraint(
                fields=['sigla_carrera'], name='unique_carrera_sigla'
            ),
        ]

    def __str__(self):
        return self.nombre


class CarreraPeriodo(models.Model):
    carrera = models.ForeignKey(Carrera, on_delete=models.CASCADE)
    periodo = models.ForeignKey(Periodo, on_delete=models.CASCADE)
    semestre = models.ForeignKey(
        'Semestre', on_delete=models.CASCADE, null=True, blank=True
    )
    paralelo = models.ForeignKey(
        'Paralelo', on_delete=models.CASCADE, null=True, blank=True
    )
    estado = models.BooleanField(default=True)

    def __str__(self):
        return f'{self.carrera} - {self.periodo}'


class Semestre(models.Model):
    nombre = models.CharField(max_length=50)
    nivel = models.IntegerField()
    horas_practicas = models.PositiveIntegerField(default=0)
    estado = models.BooleanField(default=True)
    carrera = models.ForeignKey(Carrera, on_delete=models.CASCADE)

    class Meta:
        constraints = [
            models.UniqueConstraint(
                fields=['carrera', 'nombre'], name='unique_semestre_nombre_carrera'
            ),
            models.UniqueConstraint(
                fields=['carrera', 'nivel'], name='unique_semestre_nivel_carrera'
            ),
        ]

    def __str__(self):
        return self.nombre


class Paralelo(models.Model):
    nombre = models.CharField(max_length=50)
    jornada = models.CharField(max_length=50)
    estado = models.BooleanField(default=True)
    semestre = models.ForeignKey(Semestre, on_delete=models.CASCADE)

    class Meta:
        constraints = [
            models.UniqueConstraint(
                fields=['semestre', 'nombre', 'jornada'],
                name='unique_paralelo_semestre_nombre_jornada',
            ),
        ]

    def __str__(self):
        return f'{self.semestre} - {self.nombre}'


class ResultadoAprendizaje(models.Model):
    nombre = models.CharField(max_length=200)
    estado = models.BooleanField(default=True)
    carrera = models.ForeignKey(
        Carrera, on_delete=models.CASCADE, null=True, blank=True
    )

    def __str__(self):
        return self.nombre