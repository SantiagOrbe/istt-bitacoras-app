from django.contrib.gis.db import models
from django.contrib.gis.db.models.functions import Distance

from usuarios.models import Estudiante, TutorAcademico, TutorEmpresarial


class RegistroPracticaQuerySet(models.QuerySet):
    def para_usuario(self, user):
        if not user or not user.is_authenticated:
            return self.none()

        if user.is_staff or user.is_superuser:
            return self.all()

        estudiante = Estudiante.objects.filter(usuario=user).first()
        if estudiante:
            return self.filter(estudiante=estudiante)

        tutor_academico = TutorAcademico.objects.filter(usuario=user).first()
        if tutor_academico:
            return self.filter(estudiante__tutor_academico=tutor_academico)

        tutor_empresarial = TutorEmpresarial.objects.filter(usuario=user).first()
        if tutor_empresarial:
            return self.filter(estudiante__tutor_empresarial=tutor_empresarial)

        rol = getattr(user, 'rol', None)
        if rol in ['coordinador', 'docente']:
            return self.all()

        return self.none()

    def con_distancia_a_empresa(self, punto_enviado):
        return self.annotate(
            distancia_empresa=Distance('estudiante__empresa__ubicacion', punto_enviado)
        )


RegistroPracticaManager = models.Manager.from_queryset(RegistroPracticaQuerySet)
