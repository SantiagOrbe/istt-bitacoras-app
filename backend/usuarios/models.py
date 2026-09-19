from datetime import datetime, timedelta

from django.contrib.auth.models import AbstractUser
from django.db import models
from django.db.models import Q

from empresas.models import Empresa
from gestion_academica.models import Carrera, Paralelo, Semestre
""" Modelos de los usuarios y de todos los roles correspondientes de la app en Django."""

class Usuario(AbstractUser):
    telefono = models.CharField(max_length=15, blank=True)
    rol = models.CharField(max_length=30)
    estado = models.BooleanField(default=True)
    email = models.EmailField(unique=True)

    class Meta:
        verbose_name = 'user'
        verbose_name_plural = 'users'
        constraints = [
            models.UniqueConstraint(
                fields=['telefono'],
                condition=~Q(telefono=''),
                name='unique_usuario_telefono',
            ),
        ]

    def __str__(self):
        return self.username


class Docente(models.Model):
    usuario = models.OneToOneField(Usuario, on_delete=models.CASCADE)
    cedula = models.CharField(max_length=10)

    def __str__(self):
        return self.usuario.username


class ResponsablePracticas(models.Model):
    usuario = models.OneToOneField(Usuario, on_delete=models.CASCADE)
    cedula = models.CharField(max_length=10)
    carrera = models.ForeignKey(
        Carrera, on_delete=models.SET_NULL, null=True, blank=True
    )

    def __str__(self):
        return self.usuario.username


class Coordinador(models.Model):
    usuario = models.OneToOneField(Usuario, on_delete=models.CASCADE)
    cedula = models.CharField(max_length=10)
    carrera = models.ForeignKey(
        Carrera, on_delete=models.SET_NULL, null=True, blank=True
    )

    def __str__(self):
        return self.usuario.username


class TutorAcademico(models.Model):
    usuario = models.OneToOneField(Usuario, on_delete=models.CASCADE)
    cedula = models.CharField(max_length=10)
    carrera = models.ForeignKey(
        Carrera, on_delete=models.SET_NULL, null=True, blank=True
    )
    empresa = models.ForeignKey(
        Empresa, on_delete=models.CASCADE, null=True, blank=True
    )

    def __str__(self):
        return self.usuario.username


class TutorEmpresarial(models.Model):
    usuario = models.OneToOneField(Usuario, on_delete=models.CASCADE)
    cedula = models.CharField(max_length=10)
    cargo = models.CharField(max_length=100)
    empresa = models.ForeignKey(Empresa, on_delete=models.CASCADE)

    def __str__(self):
        return self.usuario.username


class Estudiante(models.Model):
    usuario = models.OneToOneField(Usuario, on_delete=models.CASCADE)
    matricula = models.CharField(max_length=20, null=True, blank=True)
    cedula = models.CharField(max_length=10, null=True, blank=True)
    carrera = models.ForeignKey(
        Carrera, on_delete=models.CASCADE, null=True, blank=True
    )
    semestre = models.ForeignKey(
        Semestre, on_delete=models.CASCADE, null=True, blank=True
    )
    paralelo = models.ForeignKey(
        Paralelo, on_delete=models.CASCADE, null=True, blank=True
    )
    empresa = models.ForeignKey(
        Empresa, on_delete=models.CASCADE, null=True, blank=True
    )
    tutor_academico = models.ForeignKey(
        TutorAcademico, on_delete=models.CASCADE, null=True, blank=True
    )
    tutor_empresarial = models.ForeignKey(
        TutorEmpresarial, on_delete=models.CASCADE, null=True, blank=True
    )
    horas_acumuladas = models.FloatField(default=0.0)

    def recalcular_horas_acumuladas(self):
        from bitacoras.models import RegistroPractica

        total_horas = 0.0
        registros = RegistroPractica.objects.filter(
            estudiante=self,
            hora_salida__isnull=False,
        )

        for registro in registros:
            if not registro.hora_entrada or not registro.hora_salida:
                continue

            entrada = datetime.combine(registro.fecha, registro.hora_entrada)
            salida = datetime.combine(registro.fecha, registro.hora_salida)

            if salida < entrada:
                salida += timedelta(days=1)

            total_horas += (salida - entrada).total_seconds() / 3600

        self.horas_acumuladas = round(total_horas, 2)
        self.save(update_fields=['horas_acumuladas'])
        return self.horas_acumuladas

    def get_avance_practicas(self):
        horas_requeridas = self.semestre.horas_practicas if self.semestre else 0
        horas_acumuladas = self.recalcular_horas_acumuladas()
        porcentaje = 0.0

        if horas_requeridas:
            porcentaje = round((horas_acumuladas / horas_requeridas) * 100, 2)
            porcentaje = min(porcentaje, 100.0)

        return {
            'horas_acumuladas': round(horas_acumuladas, 2),
            'horas_requeridas': horas_requeridas,
            'porcentaje': porcentaje,
            'completo': horas_requeridas > 0 and horas_acumuladas >= horas_requeridas,
        }

    def __str__(self):
        return f'{self.usuario.username} - {self.matricula}'