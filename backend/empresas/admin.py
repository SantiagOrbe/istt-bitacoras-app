from django.contrib.gis import admin

from .models import Empresa


@admin.register(Empresa)
class EmpresaAdmin(admin.GISModelAdmin):
    pass