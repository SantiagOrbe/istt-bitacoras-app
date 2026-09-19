from django.urls import include, path
from rest_framework.routers import DefaultRouter
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView

from .serializers import LoginTokenSerializer
from .views import (
    PerfilView,
    RegistroView,
    ResponsablePracticasDatosView,
    UsuarioViewSet,
)

router = DefaultRouter()
router.register('', UsuarioViewSet, basename='usuario')


class LoginTokenView(TokenObtainPairView):
    serializer_class = LoginTokenSerializer

urlpatterns = [
    path('register/', RegistroView.as_view(), name='register'),
    path('login/', LoginTokenView.as_view(), name='token_obtain_pair'),
    path('refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    path('perfil/', PerfilView.as_view(), name='perfil'),
    path(
        'responsable-practicas/datos/',
        ResponsablePracticasDatosView.as_view(),
        name='responsable-practicas-datos',
    ),
    path('', include(router.urls)),
]