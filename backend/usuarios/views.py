from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from .models import (
    Coordinador,
    Docente,
    Estudiante,
    TutorAcademico,
    TutorEmpresarial,
)
from .serializers import (
    CoordinadorSerializer,
    DocenteSerializer,
    EstudianteSerializer,
    TutorAcademicoSerializer,
    TutorEmpresarialSerializer,
    UsuarioSerializer,
)


class PerfilView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        usuario = request.user
        data = UsuarioSerializer(usuario).data

        perfil_map = {
            'estudiante': (Estudiante, EstudianteSerializer),
            'docente': (Docente, DocenteSerializer),
            'coordinador': (Coordinador, CoordinadorSerializer),
            'tutor_academico': (TutorAcademico, TutorAcademicoSerializer),
            'tutor_empresarial': (
                TutorEmpresarial,
                TutorEmpresarialSerializer,
            ),
        }

        perfil = None
        if usuario.rol in perfil_map:
            model, serializer_class = perfil_map[usuario.rol]
            instancia = model.objects.filter(usuario=usuario).first()
            if instancia:
                perfil = serializer_class(instancia).data

        data['perfil'] = perfil
        return Response(data)