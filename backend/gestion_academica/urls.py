from django.urls import include, path
from rest_framework.routers import DefaultRouter

from .views import (
    CarreraPeriodoViewSet,
    CarreraViewSet,
    CicloViewSet,
    ParaleloViewSet,
    PeriodoViewSet,
    ResultadoAprendizajeViewSet,
)

router = DefaultRouter()
router.register('periodos', PeriodoViewSet)
router.register('carreras', CarreraViewSet)
router.register('carreras-periodos', CarreraPeriodoViewSet)
router.register('ciclos', CicloViewSet)
router.register('paralelos', ParaleloViewSet)
router.register('resultados-aprendizaje', ResultadoAprendizajeViewSet)

urlpatterns = [
    path('', include(router.urls)),
]