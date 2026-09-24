import logging

from django.db import DatabaseError, IntegrityError
from django.db.models import Q
from rest_framework import viewsets
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView
from gestion_academica.models import Paralelo, Semestre

from .models import (
    Coordinador,
    Estudiante,
    ResponsablePracticas,
    TutorAcademico,
    TutorEmpresarial,
    Usuario,
)
from .serializers import (
    CoordinadorSerializer,
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


class CoordinadorDatosView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        coordinador = Coordinador.objects.select_related('carrera').filter(
            usuario=request.user,
        ).first()
        if coordinador is None:
            return Response({'detail': 'El usuario no es coordinador.'}, status=403)
        if coordinador.carrera_id is None:
            return Response({'detail': 'El coordinador no tiene una carrera asignada.'}, status=400)

        estudiantes = Estudiante.objects.filter(
            carrera_id=coordinador.carrera_id,
        ).select_related(
            'usuario', 'semestre', 'paralelo', 'empresa',
            'tutor_academico__usuario', 'tutor_empresarial__usuario',
            'tutor_empresarial__empresa', 'carrera',
        ).order_by('semestre__nivel', 'paralelo__nombre', 'usuario__last_name')
        tutores = TutorAcademico.objects.filter(
            carrera_id=coordinador.carrera_id,
        ).select_related('usuario', 'carrera').order_by('usuario__last_name')

        return Response({
            'carrera': {
                'id': coordinador.carrera_id,
                'nombre': coordinador.carrera.nombre,
            },
            'semestres': [
                {
                    'id': semestre.id,
                    'nombre': semestre.nombre,
                    'nivel': semestre.nivel,
                    'horas_practicas': semestre.horas_practicas,
                    'estado': semestre.estado,
                }
                for semestre in Semestre.objects.filter(
                    carrera_id=coordinador.carrera_id,
                ).order_by('nivel', 'id')
            ],
            'paralelos': [
                {
                    'id': paralelo.id,
                    'nombre': paralelo.nombre,
                    'jornada': paralelo.jornada,
                    'semestre_id': paralelo.semestre_id,
                    'estado': paralelo.estado,
                }
                for paralelo in Paralelo.objects.filter(
                    semestre__carrera_id=coordinador.carrera_id,
                ).select_related('semestre').order_by('semestre__nivel', 'nombre')
            ],
            'estudiantes': [
                {
                    'id': estudiante.id,
                    'nombre': estudiante.usuario.get_full_name() or estudiante.usuario.email,
                    'username': estudiante.usuario.username,
                    'email': estudiante.usuario.email,
                    'telefono': estudiante.usuario.telefono,
                    'estado': estudiante.usuario.estado and estudiante.usuario.is_active,
                    'cedula': estudiante.cedula,
                    'matricula': estudiante.matricula,
                    'carrera_nombre': estudiante.carrera.nombre if estudiante.carrera else None,
                    'semestre_id': estudiante.semestre_id,
                    'semestre_nombre': estudiante.semestre.nombre if estudiante.semestre else None,
                    'paralelo_id': estudiante.paralelo_id,
                    'paralelo_nombre': estudiante.paralelo.nombre if estudiante.paralelo else None,
                    'empresa_nombre': estudiante.empresa.nombre if estudiante.empresa else None,
                    'tutor_empresarial': (
                        estudiante.tutor_empresarial.usuario.get_full_name()
                        if estudiante.tutor_empresarial else None
                    ),
                    'tutor_empresarial_cedula': (
                        estudiante.tutor_empresarial.cedula
                        if estudiante.tutor_empresarial else None
                    ),
                    'tutor_empresarial_cargo': (
                        estudiante.tutor_empresarial.cargo
                        if estudiante.tutor_empresarial else None
                    ),
                    'tutor_academico': (
                        estudiante.tutor_academico.usuario.get_full_name()
                        if estudiante.tutor_academico else None
                    ),
                    'tutor_academico_cedula': (
                        estudiante.tutor_academico.cedula
                        if estudiante.tutor_academico else None
                    ),
                    'horas_acumuladas': estudiante.horas_acumuladas,
                    'horas_requeridas': (
                        estudiante.semestre.horas_practicas
                        if estudiante.semestre else 0
                    ),
                }
                for estudiante in estudiantes
            ],
            'tutores': [
                {
                    'id': tutor.id,
                    'nombre': tutor.usuario.get_full_name() or tutor.usuario.email,
                    'email': tutor.usuario.email,
                    'telefono': tutor.usuario.telefono,
                    'cedula': tutor.cedula,
                    'carrera_id': tutor.carrera_id,
                    'carrera_nombre': tutor.carrera.nombre if tutor.carrera else None,
                    'empresa_id': tutor.get_empresa_asignada().id if tutor.get_empresa_asignada() else None,
                    'empresa_nombre': tutor.get_empresa_asignada().nombre if tutor.get_empresa_asignada() else None,
                    'estado': tutor.usuario.estado and tutor.usuario.is_active,
                }
                for tutor in tutores
            ],
        })


class TutorAcademicoDatosView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        tutor = TutorAcademico.objects.select_related(
            'usuario',
            'carrera',
            'empresa',
        ).filter(usuario=request.user).first()

        if tutor is None:
            return Response(
                {'detail': 'El usuario no es tutor académico.'},
                status=403,
            )

        from bitacoras.models import RegistroPractica

        estudiantes = (
            Estudiante.objects.filter(tutor_academico=tutor)
            .select_related(
                'usuario',
                'carrera',
                'semestre',
                'empresa',
                'tutor_empresarial__usuario',
                'tutor_empresarial__empresa',
            )
            .order_by('usuario__last_name', 'usuario__first_name', 'id')
        )

        estudiantes_data = []
        registros_data = []

        for estudiante in estudiantes:
            avance = estudiante.get_avance_practicas()
            ultimo_registro = (
                RegistroPractica.objects.filter(estudiante=estudiante)
                .order_by('-fecha', '-hora_entrada', '-id')
                .select_related('estudiante__usuario', 'estudiante__empresa')
                .first()
            )
            ultima_actividad = None
            if ultimo_registro is not None:
                ultima_actividad = ultimo_registro.actividades.order_by('-id').first()

            nombre_completo = estudiante.usuario.get_full_name() or estudiante.usuario.email
            company_tutor = estudiante.tutor_empresarial
            company_tutor_name = (
                company_tutor.usuario.get_full_name() or company_tutor.usuario.email
                if company_tutor and company_tutor.usuario_id
                else ''
            )
            company_tutor_phone = (
                company_tutor.usuario.telefono if company_tutor and company_tutor.usuario_id else ''
            )

            student_payload = {
                'id': estudiante.usuario_id,
                'username': estudiante.usuario.username,
                'email': estudiante.usuario.email,
                'first_name': estudiante.usuario.first_name,
                'last_name': estudiante.usuario.last_name,
                'name': nombre_completo,
                'phone': estudiante.usuario.telefono,
                'cedula': estudiante.cedula,
                'company': estudiante.empresa.nombre if estudiante.empresa else None,
                'company_name': estudiante.empresa.nombre if estudiante.empresa else None,
                'career_name': estudiante.carrera.nombre if estudiante.carrera else None,
                'period_name': None,
                'carrera_id': estudiante.carrera_id,
                'semestre_id': estudiante.semestre_id,
                'semestre_nombre': estudiante.semestre.nombre if estudiante.semestre else None,
                'horas_practicas': avance['horas_requeridas'],
                'rol': 'estudiante',
                'estado': estudiante.usuario.estado,
                'is_active': estudiante.usuario.is_active,
            }

            estudiante_data = {
                'id': estudiante.id,
                'student': student_payload,
                'academic_tutor_id': tutor.id,
                'company_tutor_id': company_tutor.id if company_tutor else None,
                'company_tutor_name': company_tutor_name,
                'company_tutor_phone': company_tutor_phone,
                'total_hours_required': avance['horas_requeridas'],
                'total_hours_completed': round(float(avance['horas_acumuladas']), 2),
                'status': 'Completado' if avance['completo'] else 'En Proceso',
                'last_activity_description': ultima_actividad.descripcion if ultima_actividad else None,
                'last_activity_date': ultimo_registro.fecha.isoformat() if ultimo_registro else None,
                'last_attendance_time': (
                    ultimo_registro.hora_entrada.strftime('%H:%M') if ultimo_registro else None
                ),
            }
            estudiantes_data.append(estudiante_data)

            for registro in RegistroPractica.objects.filter(estudiante=estudiante).order_by('-fecha', '-hora_entrada', '-id'):
                actividad = registro.actividades.order_by('-id').first()
                registros_data.append({
                    'id': registro.id,
                    'student_id': estudiante.usuario_id,
                    'student_name': nombre_completo,
                    'company_name': estudiante.empresa.nombre if estudiante.empresa else '',
                    'fecha': registro.fecha.isoformat(),
                    'hora_entrada': registro.hora_entrada.strftime('%H:%M:%S') if registro.hora_entrada else '',
                    'hora_salida': registro.hora_salida.strftime('%H:%M:%S') if registro.hora_salida else None,
                    'actividad_descripcion': actividad.descripcion if actividad else '',
                    'estado': 'Aprobado' if registro.estado else 'Pendiente',
                })

        return Response({
            'total': len(estudiantes_data),
            'estudiantes': estudiantes_data,
            'registros': registros_data,
        })


class TutorEmpresarialDatosView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        tutor = TutorEmpresarial.objects.select_related('usuario', 'empresa').filter(
            usuario=request.user,
        ).first()
        if tutor is None:
            return Response({'detail': 'El usuario no es tutor empresarial.'}, status=403)

        from bitacoras.models import RegistroPractica

        estudiantes = Estudiante.objects.filter(
            tutor_empresarial=tutor,
        ).select_related(
            'usuario', 'carrera', 'semestre', 'empresa',
            'tutor_academico__usuario', 'tutor_empresarial__usuario',
        ).order_by('usuario__last_name', 'usuario__first_name', 'id')

        estudiantes_data = []
        registros_data = []
        for estudiante in estudiantes:
            nombre = estudiante.usuario.get_full_name() or estudiante.usuario.email
            registros = RegistroPractica.objects.filter(
                estudiante=estudiante,
            ).order_by('-fecha', '-hora_entrada', '-id')
            ultimo = registros.first()
            actividad = ultimo.actividades.order_by('-id').first() if ultimo else None
            estudiantes_data.append({
                'id': estudiante.id,
                'student': {
                    'id': estudiante.usuario_id,
                    'username': estudiante.usuario.username,
                    'email': estudiante.usuario.email,
                    'first_name': estudiante.usuario.first_name,
                    'last_name': estudiante.usuario.last_name,
                    'name': nombre,
                    'phone': estudiante.usuario.telefono,
                    'cedula': estudiante.cedula,
                    'company': estudiante.empresa.nombre if estudiante.empresa else None,
                    'company_name': estudiante.empresa.nombre if estudiante.empresa else None,
                    'career_name': estudiante.carrera.nombre if estudiante.carrera else None,
                    'carrera_id': estudiante.carrera_id,
                    'semestre_id': estudiante.semestre_id,
                    'semestre_nombre': estudiante.semestre.nombre if estudiante.semestre else None,
                    'rol': 'estudiante',
                    'estado': estudiante.usuario.estado,
                    'is_active': estudiante.usuario.is_active,
                },
                'academic_tutor_id': estudiante.tutor_academico_id,
                'company_tutor_id': tutor.id,
                'company_tutor_name': tutor.usuario.get_full_name() or tutor.usuario.email,
                'company_tutor_phone': tutor.usuario.telefono,
                'total_hours_required': estudiante.get_avance_practicas()['horas_requeridas'],
                'total_hours_completed': round(float(estudiante.get_avance_practicas()['horas_acumuladas']), 2),
                'status': 'Completado' if estudiante.get_avance_practicas()['completo'] else 'En Proceso',
                'last_activity_description': actividad.descripcion if actividad else None,
                'last_activity_date': ultimo.fecha.isoformat() if ultimo else None,
                'last_attendance_time': ultimo.hora_entrada.strftime('%H:%M') if ultimo else None,
            })
            for registro in registros:
                actividad = registro.actividades.order_by('-id').first()
                registros_data.append({
                    'id': registro.id,
                    'student_id': estudiante.usuario_id,
                    'student_name': nombre,
                    'company_name': estudiante.empresa.nombre if estudiante.empresa else '',
                    'fecha': registro.fecha.isoformat(),
                    'hora_entrada': registro.hora_entrada.strftime('%H:%M:%S') if registro.hora_entrada else '',
                    'hora_salida': registro.hora_salida.strftime('%H:%M:%S') if registro.hora_salida else None,
                    'actividad_descripcion': actividad.descripcion if actividad else '',
                    'estado': registro.estado,
                })

        return Response({
            'total': len(estudiantes_data),
            'estudiantes': estudiantes_data,
            'registros': registros_data,
        })


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
        academic_tutor.empresa = company
        academic_tutor.save(update_fields=['empresa'])
        return Response({'detail': 'Asignación guardada correctamente.'})