from django.urls import include, path
from rest_framework.routers import DefaultRouter

from .views import ActividadViewSet, RegistroPracticaViewSet

router = DefaultRouter()
router.register('registros', RegistroPracticaViewSet)
router.register('actividades', ActividadViewSet)

urlpatterns = [
    path('', include(router.urls)),
]