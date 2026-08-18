from django.contrib.gis import admin

from .models import Actividad, RegistroPractica


@admin.register(RegistroPractica)
class RegistroPracticaAdmin(admin.GISModelAdmin):
    pass


admin.site.register(Actividad)