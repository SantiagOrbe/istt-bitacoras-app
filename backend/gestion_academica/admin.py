from django.contrib import admin

from .models import (
    Carrera,
    CarreraPeriodo,
    Ciclo,
    Paralelo,
    Periodo,
    ResultadoAprendizaje,
)

admin.site.register(Periodo)
admin.site.register(Carrera)
admin.site.register(CarreraPeriodo)
admin.site.register(Ciclo)
admin.site.register(Paralelo)
admin.site.register(ResultadoAprendizaje)