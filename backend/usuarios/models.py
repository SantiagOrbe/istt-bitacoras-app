from django.contrib.auth.models import AbstractUser
from django.db import models

from empresas.models import Empresa
from gestion_academica.models import Carrera, Ciclo, Paralelo


class Usuario(AbstractUser):
    telefono = models.CharField(max_length=15, blank=True)
    rol = models.CharField(max_length=30)
    estado = models.BooleanField(default=True)
    email = models.EmailField(unique=True)

    def __str__(self):
        return self.username


class Docente(models.Model):
    usuario = models.OneToOneField(Usuario, on_delete=models.CASCADE)
    cedula = models.CharField(max_length=10)

    def __str__(self):
        return self.usuario.username


class Coordinador(models.Model):
    usuario = models.OneToOneField(Usuario, on_delete=models.CASCADE)
    cedula = models.CharField(max_length=10)

    def __str__(self):
        return self.usuario.username


class TutorAcademico(models.Model):
    usuario = models.OneToOneField(Usuario, on_delete=models.CASCADE)
    cedula = models.CharField(max_length=10)

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
    matricula = models.CharField(max_length=20)
    cedula = models.CharField(max_length=10)
    carrera = models.ForeignKey(Carrera, on_delete=models.CASCADE)
    ciclo = models.ForeignKey(Ciclo, on_delete=models.CASCADE)
    paralelo = models.ForeignKey(Paralelo, on_delete=models.CASCADE)
    empresa = models.ForeignKey(
        Empresa, on_delete=models.CASCADE, null=True, blank=True
    )
    tutor_academico = models.ForeignKey(
        TutorAcademico, on_delete=models.CASCADE, null=True, blank=True
    )
    tutor_empresarial = models.ForeignKey(
        TutorEmpresarial, on_delete=models.CASCADE, null=True, blank=True
    )

    def __str__(self):
        return f'{self.usuario.username} - {self.matricula}'