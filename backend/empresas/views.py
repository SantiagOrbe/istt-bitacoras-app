from rest_framework import status, viewsets
from rest_framework.decorators import action
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response

from usuarios.models import Estudiante

from .models import Empresa
from .serializers import EmpresaSerializer


class EmpresaViewSet(viewsets.ModelViewSet):
    queryset = Empresa.objects.all()
    serializer_class = EmpresaSerializer
    permission_classes = [IsAuthenticated]

    @action(detail=True, methods=['get'], url_path='estudiantes-vinculados')
    def estudiantes_vinculados(self, request, pk=None):
        empresa = self.get_object()
        estudiantes = Estudiante.objects.filter(empresa=empresa).select_related(
            'usuario'
        )
        return Response([
            {
                'id': estudiante.id,
                'nombre': estudiante.usuario.get_full_name() or estudiante.usuario.email,
                'email': estudiante.usuario.email,
            }
            for estudiante in estudiantes
        ])

    def update(self, request, *args, **kwargs):
        empresa = self.get_object()
        estado_nuevo = request.data.get('estado')
        if estado_nuevo is not None:
            estado_nuevo = str(estado_nuevo).lower() not in {'false', '0', 'no'}
        unlink_students = str(request.data.get('unlink_students', 'false')).lower() in {
            'true', '1', 'yes', 'y'
        }

        if estado_nuevo is False and not unlink_students:
            estudiantes = Estudiante.objects.filter(empresa=empresa).select_related(
                'usuario'
            )
            if estudiantes.exists():
                return Response(
                    {
                        'detail': (
                            'La empresa tiene estudiantes vinculados; confirma la '
                            'desvinculación para continuar.'
                        ),
                        'linked_students': [
                            {
                                'id': estudiante.id,
                                'nombre': estudiante.usuario.get_full_name()
                                or estudiante.usuario.email,
                            }
                            for estudiante in estudiantes
                        ],
                    },
                    status=status.HTTP_400_BAD_REQUEST,
                )

        if estado_nuevo is False and unlink_students:
            Estudiante.objects.filter(empresa=empresa).update(empresa=None)

        return super().update(request, *args, **kwargs)

    def destroy(self, request, *args, **kwargs):
        empresa = self.get_object()
        unlink_students = str(request.data.get('unlink_students', 'false')).lower() in {
            'true', '1', 'yes', 'y'
        }
        estudiantes = Estudiante.objects.filter(empresa=empresa)
        if estudiantes.exists() and not unlink_students:
            return Response(
                {
                    'detail': 'La empresa tiene estudiantes vinculados; confirma la desvinculación.',
                    'linked_students': [
                        {
                            'id': estudiante.id,
                            'nombre': estudiante.usuario.get_full_name() or estudiante.usuario.email,
                        }
                        for estudiante in estudiantes.select_related('usuario')
                    ],
                },
                status=status.HTTP_400_BAD_REQUEST,
            )
        if unlink_students:
            estudiantes.update(empresa=None)
        empresa.estado = False
        empresa.save(update_fields=['estado'])
        return Response(status=status.HTTP_204_NO_CONTENT)