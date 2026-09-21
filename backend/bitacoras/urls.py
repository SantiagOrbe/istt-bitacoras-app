from django.urls import include, path
from rest_framework.routers import DefaultRouter

from .views import ActividadViewSet, RegistroPracticaViewSet, VisitaTutorAcademicoViewSet

router = DefaultRouter()
router.register('registros', RegistroPracticaViewSet)
router.register('actividades', ActividadViewSet)
router.register('visitas-tutor', VisitaTutorAcademicoViewSet, basename='visita-tutor')

urlpatterns = [
    path('', include(router.urls)),
]