import re
from pathlib import Path

from django.contrib.gis.geos import Point
from django.http import HttpResponse
from django.template.loader import render_to_string
from django.utils import timezone
from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.exceptions import ValidationError
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from weasyprint import HTML

from gestion_academica.models import CarreraPeriodo
from usuarios.models import Coordinador, Estudiante, TutorAcademico, TutorEmpresarial
from .models import Actividad, RegistroPractica, VisitaTutorAcademico
from .serializers import ActividadSerializer, RegistroPracticaSerializer, VisitaTutorAcademicoSerializer
from .services import GeofencingService


class RegistroPracticaViewSet(viewsets.ModelViewSet):
    queryset = RegistroPractica.objects.all()
    serializer_class = RegistroPracticaSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return RegistroPractica.objects.para_usuario(self.request.user)

    def perform_create(self, serializer):
        user = self.request.user
        estudiante = Estudiante.objects.filter(usuario=user).first()
        if estudiante and not serializer.validated_data.get('estudiante'):
            serializer.save(estudiante=estudiante)
        else:
            serializer.save()

    def update(self, request, *args, **kwargs):
        partial = kwargs.pop('partial', False)
        instance = self.get_object()

        actividad_descripcion = request.data.get('actividad_descripcion')
        if actividad_descripcion is None:
            actividad_descripcion = request.data.get('descripcion')

        if actividad_descripcion is not None:
            actividad = instance.actividades.order_by('-id').first()
            if actividad is None:
                Actividad.objects.create(
                    registro_practica=instance,
                    descripcion=str(actividad_descripcion),
                    estado=True,
                )
            else:
                actividad.descripcion = str(actividad_descripcion)
                actividad.save(update_fields=['descripcion'])

        if 'estado' in request.data:
            estado_raw = request.data.get('estado')
            if isinstance(estado_raw, str):
                estado_value = estado_raw.strip().lower() not in {'false', '0', 'no', 'inactivo', 'desactivado'}
            else:
                estado_value = bool(estado_raw)
            instance.estado = estado_value
            instance.save(update_fields=['estado'])

        serializer = self.get_serializer(instance, data=request.data, partial=partial)
        serializer.is_valid(raise_exception=True)
        self.perform_update(serializer)
        return Response(serializer.data)

    @action(detail=False, methods=['get'], url_path='mi-avance')
    def mi_avance(self, request):
        usuario = request.user
        estudiante = Estudiante.objects.filter(usuario=usuario).first()

        if not estudiante:
            return Response(
                {'error': 'El usuario autenticado no tiene un perfil de estudiante asociado.'},
                status=status.HTTP_404_NOT_FOUND,
            )

        avance = estudiante.get_avance_practicas()
        return Response(avance, status=status.HTTP_200_OK)

    @action(detail=False, methods=['post'], url_path='check-in')
    def check_in(self, request):
        user = request.user
        estudiante = Estudiante.objects.filter(usuario=user).first()
        latitud = request.data.get('latitud')
        longitud = request.data.get('longitud')

        try:
            registro = GeofencingService.realizar_check_in(estudiante, latitud, longitud)
            serializer = self.get_serializer(registro)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        except ValidationError as e:
            detail = e.detail if hasattr(e, 'detail') else {'error': str(e)}
            return Response(detail, status=status.HTTP_400_BAD_REQUEST)

    @action(detail=False, methods=['post'], url_path='check-out')
    def check_out(self, request):
        user = request.user
        estudiante = Estudiante.objects.filter(usuario=user).first()
        latitud = request.data.get('latitud')
        longitud = request.data.get('longitud')

        try:
            registro = GeofencingService.realizar_check_out(estudiante, latitud, longitud)
            serializer = self.get_serializer(registro)
            return Response(serializer.data, status=status.HTTP_200_OK)
        except ValidationError as e:
            detail = e.detail if hasattr(e, 'detail') else {'error': str(e)}
            status_code = status.HTTP_404_NOT_FOUND if 'No se encontró' in str(detail) else status.HTTP_400_BAD_REQUEST
            return Response(detail, status=status_code)

    @action(detail=False, methods=['get'], url_path='mi-reporte-pdf')
    def mi_reporte_pdf(self, request):
        estudiante = Estudiante.objects.filter(usuario=request.user).select_related(
            'usuario',
            'carrera',
            'semestre',
            'empresa',
            'tutor_academico__usuario',
            'tutor_empresarial__usuario',
        ).first()

        if not estudiante:
            return Response(
                {'error': 'El usuario autenticado no tiene un perfil de estudiante asociado.'},
                status=status.HTTP_404_NOT_FOUND,
            )

        registros = (
            RegistroPractica.objects.filter(estudiante=estudiante)
            .select_related('estudiante__usuario')
            .order_by('fecha', 'hora_entrada', 'id')
        )

        tabla_registros = []
        for index, registro in enumerate(registros, start=1):
            actividades = registro.actividades.order_by('id').values_list('descripcion', flat=True)
            descripcion = ' • '.join(str(item).strip() for item in actividades if str(item).strip())
            if not descripcion:
                descripcion = 'Sin actividades registradas'
            tabla_registros.append({
                'numero': index,
                'fecha': registro.fecha.strftime('%d/%m/%Y'),
                'hora_entrada': registro.hora_entrada.strftime('%H:%M') if registro.hora_entrada else '',
                'hora_salida': registro.hora_salida.strftime('%H:%M') if registro.hora_salida else '',
                'actividad': descripcion,
            })

        filas = tabla_registros[:108]
        if not filas:
            filas = [{
                'numero': 1,
                'fecha': '',
                'hora_entrada': '',
                'hora_salida': '',
                'actividad': '',
            }]

        page_rows = [filas[:9]]
        page_rows.extend(filas[start:start + 11] for start in range(9, len(filas), 11))

        full_name = estudiante.usuario.get_full_name() or estudiante.usuario.email or 'Estudiante'
        periodo_academico = (
            CarreraPeriodo.objects.filter(
                carrera_id=estudiante.carrera_id,
                semestre_id=estudiante.semestre_id,
                estado=True,
            )
            .filter(paralelo_id=estudiante.paralelo_id)
            .select_related('periodo')
            .first()
        )
        if periodo_academico is None:
            periodo_academico = (
                CarreraPeriodo.objects.filter(
                    carrera_id=estudiante.carrera_id,
                    semestre_id=estudiante.semestre_id,
                    estado=True,
                )
                .select_related('periodo')
                .first()
            )
        if estudiante.semestre:
            periodo_nombre = estudiante.semestre.nombre
            if estudiante.paralelo:
                periodo_nombre = f'{periodo_nombre} “{estudiante.paralelo.nombre}”'
        elif periodo_academico:
            periodo_nombre = periodo_academico.periodo.nombre
        else:
            periodo_nombre = 'Sin periodo'
        tutor_empresarial_name = (
            estudiante.tutor_empresarial.usuario.get_full_name()
            or estudiante.tutor_empresarial.usuario.email
            if estudiante.tutor_empresarial
            else 'Sin tutor empresarial'
        )
        normalized_name = re.sub(r'[^A-Za-z0-9\s_-]+', '', full_name).strip().replace(' ', '_')
        filename = f'bitacora_{normalized_name or "estudiante"}.pdf'
        assets_dir = Path(__file__).resolve().parents[2] / 'frontend' / 'bitacoras_app' / 'assets' / 'images'
        def asset_uri(filename):
            path = assets_dir / filename
            return path.as_uri() if path.exists() else ''

        html_string = render_to_string('bitacoras/reporte_practica.html', {
            'estudiante': estudiante,
            'full_name': full_name,
            'empresa': estudiante.empresa,
            'carrera': estudiante.carrera,
            'semestre': estudiante.semestre,
            'periodo': periodo_nombre,
            'tutor_academico': estudiante.tutor_academico.usuario.get_full_name() if estudiante.tutor_academico else 'Sin tutor académico',
            'tutor_empresarial': tutor_empresarial_name,
            'tutor_empresarial_cedula': estudiante.tutor_empresarial.cedula if estudiante.tutor_empresarial else 'Sin cédula',
            'fecha_inicio': registros.order_by('fecha').first().fecha.strftime('%d/%m/%Y') if registros.exists() else 'Sin fecha de inicio',
            'fecha_fin': registros.order_by('-fecha').first().fecha.strftime('%d/%m/%Y') if registros.exists() else 'Sin fecha de fin',
            'pages': page_rows[:10],
            'encabezado_institucional_path': asset_uri('Encabezado_Republica_Ecuador.png'),
            'ist_encabezado_path': asset_uri('ist_encabezado.png'),
            'ecuador_path': asset_uri('El_Nuevo_Ecuador.png'),
        })

        pdf_bytes = HTML(string=html_string, base_url=str(assets_dir)).write_pdf()
        response = HttpResponse(pdf_bytes, content_type='application/pdf')
        response['Content-Disposition'] = f'attachment; filename="{filename}"'
        return response


class VisitaTutorAcademicoViewSet(viewsets.ModelViewSet):
    serializer_class = VisitaTutorAcademicoSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return VisitaTutorAcademico.objects.filter(tutor__usuario=self.request.user).select_related('empresa')

    def _serialize_state(self, visita):
        data = self.get_serializer(visita).data
        has_entry = visita is not None
        has_exit = has_entry and visita.hora_salida is not None
        has_activities = has_entry and bool(visita.actividades.strip())
        data.update({
            'tiene_entrada': has_entry,
            'tiene_salida': has_exit,
            'tiene_actividades': has_activities,
            'puede_registrar_entrada': not has_entry,
            'puede_registrar_salida': has_activities and not has_exit,
            'puede_registrar_actividades': has_entry and not has_exit and not has_activities,
        })
        return data

    def perform_create(self, serializer):
        tutor = TutorAcademico.objects.filter(usuario=self.request.user).select_related('empresa').first()
        if tutor is None:
            raise ValidationError({'detail': 'El usuario no es tutor académico.'})
        empresa = tutor.get_empresa_asignada()
        if empresa is None:
            raise ValidationError({'detail': 'El tutor académico no tiene una empresa asignada.'})
        serializer.save(tutor=tutor, empresa=empresa)

    @action(detail=False, methods=['get'], url_path='estado-hoy')
    def estado_hoy(self, request):
        visita = self.get_queryset().filter(fecha=timezone.localdate()).first()
        return Response(
            self._serialize_state(visita) if visita else {
                'tiene_entrada': False,
                'tiene_salida': False,
                'puede_registrar_entrada': True,
                'puede_registrar_salida': False,
                'puede_registrar_actividades': False,
            }
        )

    @action(detail=False, methods=['get'], url_path='mi-reporte-pdf')
    def mi_reporte_pdf(self, request):
        tutor = TutorAcademico.objects.filter(usuario=request.user).select_related(
            'usuario', 'carrera'
        ).first()
        if tutor is None:
            return Response({'detail': 'El usuario no es tutor académico.'}, status=status.HTTP_403_FORBIDDEN)

        visitas = self.get_queryset().order_by('fecha', 'hora_entrada', 'id')
        coordinador = Coordinador.objects.filter(
            carrera_id=tutor.carrera_id,
            usuario__estado=True,
            usuario__is_active=True,
        ).select_related('usuario').order_by('id').first()
        assets_dir = Path(__file__).resolve().parents[2] / 'frontend' / 'bitacoras_app' / 'assets' / 'images'

        def asset_uri(filename):
            path = assets_dir / filename
            return path.as_uri() if path.exists() else ''

        html_string = render_to_string('bitacoras/reporte_visitas_tutor.html', {
            'profesor': tutor.usuario.get_full_name() or tutor.usuario.email,
            'carrera': tutor.carrera.nombre if tutor.carrera else 'Sin carrera registrada',
            'elaborado_por': tutor.usuario.get_full_name() or tutor.usuario.email,
            'validado_por': coordinador.usuario.get_full_name() if coordinador else 'Sin coordinador asignado',
            'visitas': visitas,
            'fecha_elaboracion': timezone.localdate(),
            'hora_inicio': visitas.first().hora_entrada if visitas.exists() else None,
            'hora_finalizacion': visitas.last().hora_salida if visitas.exists() else None,
            'encabezado_path': asset_uri('Encabezado_Republica_Ecuador.png'),
            'ist_path': asset_uri('ist_encabezado.png'),
            'ecuador_path': asset_uri('El_Nuevo_Ecuador.png'),
        })
        pdf_bytes = HTML(string=html_string, base_url=str(assets_dir)).write_pdf()
        response = HttpResponse(pdf_bytes, content_type='application/pdf')
        response['Content-Disposition'] = 'attachment; filename="hoja_ruta_tutor.pdf"'
        return response

    @action(detail=False, methods=['post'], url_path='entrada')
    def entrada(self, request):
        tutor = TutorAcademico.objects.filter(usuario=request.user).select_related('empresa').first()
        empresa = tutor.get_empresa_asignada() if tutor else None
        if tutor is None or empresa is None:
            raise ValidationError({'detail': 'El tutor académico no tiene una empresa asignada.'})
        if self.get_queryset().filter(fecha=timezone.localdate(), hora_salida__isnull=True).exists():
            raise ValidationError({'detail': 'Ya existe una visita activa para hoy.'})

        latitud = request.data.get('latitud')
        longitud = request.data.get('longitud')
        if latitud is None or longitud is None:
            raise ValidationError({'detail': 'Se requieren latitud y longitud.'})

        lat = float(latitud)
        lon = float(longitud)
        distancia = GeofencingService._distancia_a_empresa(empresa, lat, lon)
        if distancia is None or distancia > (empresa.radio_permitido or 50.0):
            raise ValidationError({'detail': 'El tutor está fuera del rango permitido de la empresa.'})

        visita = VisitaTutorAcademico.objects.create(
            tutor=tutor,
            empresa=empresa,
            fecha=timezone.localdate(),
            hora_entrada=timezone.localtime().time(),
            ubicacion_entrada=Point(lon, lat, srid=4326),
        )
        return Response(self.get_serializer(visita).data, status=status.HTTP_201_CREATED)

    @action(detail=False, methods=['post'], url_path='salida')
    def salida(self, request):
        visita = self.get_queryset().filter(fecha=timezone.localdate(), hora_salida__isnull=True).first()
        if visita is None:
            raise ValidationError({'detail': 'No existe una visita activa para cerrar.'})
        if not visita.actividades.strip():
            raise ValidationError({'detail': 'Debes registrar las actividades antes de registrar la salida.'})

        latitud = request.data.get('latitud')
        longitud = request.data.get('longitud')
        if latitud is None or longitud is None:
            raise ValidationError({'detail': 'Se requieren latitud y longitud para registrar la salida.'})

        try:
            lat = float(latitud)
            lon = float(longitud)
        except (TypeError, ValueError):
            raise ValidationError({'detail': 'Latitud y longitud deben ser valores numéricos válidos.'})

        distancia = GeofencingService._distancia_a_empresa(visita.empresa, lat, lon)
        if distancia is None or distancia > (visita.empresa.radio_permitido or 50.0):
            raise ValidationError({'detail': 'El tutor está fuera del rango permitido de la empresa.'})

        visita.hora_salida = timezone.localtime().time()
        visita.ubicacion_salida = Point(lon, lat, srid=4326)
        visita.estado = False
        visita.save(update_fields=['hora_salida', 'ubicacion_salida', 'estado'])
        return Response(self.get_serializer(visita).data)


class ActividadViewSet(viewsets.ModelViewSet):
    queryset = Actividad.objects.all()
    serializer_class = ActividadSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        user = self.request.user
        if user.is_staff or user.is_superuser:
            return Actividad.objects.all()

        estudiante = Estudiante.objects.filter(usuario=user).first()
        if estudiante:
            return Actividad.objects.filter(registro_practica__estudiante=estudiante)

        tutor_academico = TutorAcademico.objects.filter(usuario=user).first()
        if tutor_academico:
            return Actividad.objects.filter(registro_practica__estudiante__tutor_academico=tutor_academico)

        tutor_empresarial = TutorEmpresarial.objects.filter(usuario=user).first()
        if tutor_empresarial:
            return Actividad.objects.filter(registro_practica__estudiante__tutor_empresarial=tutor_empresarial)

        rol = getattr(user, 'rol', None)
        if rol == 'coordinador':
            return Actividad.objects.all()

        return Actividad.objects.none()

    def perform_create(self, serializer):
        user = self.request.user
        estudiante = Estudiante.objects.filter(usuario=user).first()
        if estudiante:
            registro_practica = serializer.validated_data.get('registro_practica')
            if registro_practica and registro_practica.estudiante != estudiante:
                from rest_framework.exceptions import PermissionDenied
                raise PermissionDenied("No puedes crear actividades para registros de práctica de otros estudiantes.")
        serializer.save()
