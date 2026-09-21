from django.contrib import admin
from django.contrib.auth.admin import UserAdmin

from .models import (
    Coordinador,
    Estudiante,
    TutorAcademico,
    TutorEmpresarial,
    Usuario,
)


@admin.register(Usuario)
class UsuarioAdmin(UserAdmin):
    pass


admin.site.register(Coordinador)
admin.site.register(TutorAcademico)
admin.site.register(TutorEmpresarial)
admin.site.register(Estudiante)