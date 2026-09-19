import logging

from django.db import DatabaseError, IntegrityError
from django.db.models import Q
from rest_framework import viewsets
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from .models import (
    Coordinador,
    Docente,
    Estudiante,
    ResponsablePracticas,
    TutorAcademico,
    TutorEmpresarial,
    Usuario,
)
from .serializers import (
    CoordinadorSerializer,
    DocenteSerializer,
    EstudianteSerializer,
    ResponsablePracticasSerializer,
    TutorAcademicoSerializer,
    TutorEmpresarialSerializer,
    RegistroSerializer,
    UsuarioAdminSerializer,
    UsuarioSerializer,
)

logger = logging.getLogger(__name__)


class RegistroView(APIView):
    permission_classes = []

    def post(self, request):
        serializer = RegistroSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        try:
            usuario = serializer.save()
        except IntegrityError:
            logger.exception('Error de integridad durante el registro')
            return Response(
                {
                    'detail': (
                        'No fue posible crear la cuenta porque los datos '
                        'entran en conflicto con un registro existente.'
                    )
                },
                status=409,
            )
        except DatabaseError:
            logger.exception('Error de base de datos durante el registro')
            return Response(
                {
                    'detail': (
                        'No fue posible completar el registro. '
                        'Inténtelo nuevamente.'
                    )
                },
                status=503,
            )
        except Exception:
            logger.exception('Error inesperado durante el registro')
            return Response(
                {
                    'detail': (
                        'Ocurrió un error inesperado al crear la cuenta.'
                    )
                },
                status=500,
            )
        return Response(
            UsuarioSerializer(usuario).data,
            status=201,
        )


class UsuarioViewSet(viewsets.ModelViewSet):
    queryset = Usuario.objects.all().order_by('id')
    serializer_class = UsuarioAdminSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        queryset = super().get_queryset()
        is_active = self.request.query_params.get('is_active')
        role = self.request.query_params.get('rol')
        search = self.request.query_params.get('search', '').strip()

        if is_active is not None:
            normalized = is_active.lower()
            if normalized in {'true', '1', 'si', 'sí'}:
                queryset = queryset.filter(estado=True, is_active=True)
            elif normalized in {'false', '0', 'no'}:
                queryset = queryset.filter(estado=False, is_active=False)

        if role and role.lower() != 'todos':
            queryset = queryset.filter(rol__iexact=role.strip())

        if search:
            queryset = queryset.filter(
                Q(first_name__icontains=search)
                | Q(last_name__icontains=search)
                | Q(email__icontains=search)
            )
        return queryset

    def destroy(self, request, *args, **kwargs):
        usuario = self.get_object()
        usuario.estado = False
        usuario.is_active = False
        usuario.save(update_fields=['estado', 'is_active'])
        return Response(status=204)


class PerfilView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        usuario = request.user
        data = UsuarioSerializer(usuario).data

        perfil_map = {
            'estudiante': (Estudiante, EstudianteSerializer),
            'docente': (Docente, DocenteSerializer),
            'coordinador': (Coordinador, CoordinadorSerializer),
            'responsable_practicas': (
                ResponsablePracticas,
                ResponsablePracticasSerializer,
            ),
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


class ResponsablePracticasDatosView(APIView):
    permission_classes = [IsAuthenticated]

    def _responsable(self, request):
        if request.user.rol != 'responsable_practicas':
            return None
        return ResponsablePracticas.objects.select_related('carrera').filter(
            usuario=request.user
        ).first()

    def get(self, request):
        responsable = self._responsable(request)
        if responsable is None:
            return Response(
                {'detail': 'El usuario no es responsable de prácticas.'},
                status=403,
            )
        if responsable.carrera_id is None:
            return Response(
                {'detail': 'El responsable no tiene una carrera asignada.'},
                status=400,
            )

        from empresas.models import Empresa
        from gestion_academica.models import CarreraPeriodo, Paralelo, Semestre

        carrera_id = responsable.carrera_id
        semestres = Semestre.objects.filter(
            carrera_id=carrera_id,
            estado=True,
            carreraperiodo__estado=True,
        ).distinct().order_by('nivel', 'id')
        paralelos = Paralelo.objects.filter(
            semestre__carrera_id=carrera_id,
            semestre__estado=True,
            estado=True,
            semestre__carreraperiodo__estado=True,
        ).select_related('semestre').order_by('semestre__nivel', 'nombre')
        estudiantes = Estudiante.objects.filter(
            carrera_id=carrera_id,
            semestre__estado=True,
            paralelo__estado=True,
            semestre__carreraperiodo__estado=True,
            paralelo__semestre__carreraperiodo__estado=True,
        ).select_related(
            'usuario', 'semestre', 'paralelo', 'empresa',
            'tutor_academico__usuario', 'tutor_empresarial__usuario',
        ).order_by('paralelo__semestre__nivel', 'paralelo__nombre', 'usuario__last_name')
        tutores_academicos = TutorAcademico.objects.filter(
            carrera_id=carrera_id,
            usuario__estado=True,
            usuario__is_active=True,
        ).select_related('usuario', 'empresa')
        tutores_empresariales = TutorEmpresarial.objects.filter(
            empresa__estado=True,
            usuario__estado=True,
            usuario__is_active=True,
        ).select_related('usuario', 'empresa')

        return Response({
            'carrera': {
                'id': carrera_id,
                'nombre': responsable.carrera.nombre,
            },
            'empresas': [
                {
                    'id': empresa.id,
                    'nombre': empresa.nombre,
                    'direccion': empresa.direccion,
                    'telefono': empresa.telefono,
                    'correo': empresa.correo,
                    'latitud': empresa.latitud,
                    'longitud': empresa.longitud,
                    'radio_permitido': empresa.radio_permitido,
                    'estado': empresa.estado,
                }
                for empresa in Empresa.objects.filter(estado=True).order_by('nombre')
            ],
            'semestres': [
                {'id': semestre.id, 'nombre': semestre.nombre, 'nivel': semestre.nivel}
                for semestre in semestres
            ],
            'paralelos': [
                {
                    'id': paralelo.id,
                    'nombre': paralelo.nombre,
                    'jornada': paralelo.jornada,
                    'semestre_id': paralelo.semestre_id,
                }
                for paralelo in paralelos
            ],
            'estudiantes': [
                {
                    'id': estudiante.id,
                    'nombre': estudiante.usuario.get_full_name() or estudiante.usuario.email,
                    'email': estudiante.usuario.email,
                    'cedula': estudiante.cedula,
                    'semestre_id': estudiante.semestre_id,
                    'paralelo_id': estudiante.paralelo_id,
                    'empresa_id': estudiante.empresa_id,
                    'tutor_academico_id': estudiante.tutor_academico_id,
                    'tutor_empresarial_id': estudiante.tutor_empresarial_id,
                }
                for estudiante in estudiantes
            ],
            'tutores_academicos': [
                {
                    'id': tutor.id,
                    'nombre': tutor.usuario.get_full_name() or tutor.usuario.email,
                    'empresa_id': tutor.empresa_id,
                }
                for tutor in tutores_academicos
            ],
            'tutores_empresariales': [
                {
                    'id': tutor.id,
                    'nombre': tutor.usuario.get_full_name() or tutor.usuario.email,
                    'empresa_id': tutor.empresa_id,
                    'empresa_nombre': tutor.empresa.nombre,
                }
                for tutor in tutores_empresariales
            ],
        })

    def post(self, request):
        from empresas.models import Empresa

        responsable = self._responsable(request)
        if responsable is None:
            return Response({'detail': 'No autorizado.'}, status=403)
        estudiante = Estudiante.objects.filter(
            pk=request.data.get('estudiante_id'),
            carrera_id=responsable.carrera_id,
        ).first()
        if estudiante is None:
            return Response({'detail': 'El estudiante no pertenece a su carrera.'}, status=400)

        academic_tutor_id = request.data.get('tutor_academico_id')
        company_tutor_id = request.data.get('tutor_empresarial_id')
        company_id = request.data.get('empresa_id')
        academic_tutor = TutorAcademico.objects.filter(
            pk=academic_tutor_id,
            carrera_id=responsable.carrera_id,
            usuario__estado=True,
            usuario__is_active=True,
        ).first()
        company_tutor = TutorEmpresarial.objects.filter(
            pk=company_tutor_id,
            empresa__estado=True,
            usuario__estado=True,
            usuario__is_active=True,
        ).first()
        company = Empresa.objects.filter(pk=company_id, estado=True).first()
        if not academic_tutor or not company_tutor or not company:
            return Response({'detail': 'La asignación seleccionada no es válida.'}, status=400)
        if company_tutor.empresa_id != company.id:
            return Response({'detail': 'El tutor empresarial no pertenece a la empresa.'}, status=400)

        estudiante.tutor_academico = academic_tutor
        estudiante.tutor_empresarial = company_tutor
        estudiante.empresa = company
        estudiante.save(update_fields=['tutor_academico', 'tutor_empresarial', 'empresa'])
        return Response({'detail': 'Asignación guardada correctamente.'})