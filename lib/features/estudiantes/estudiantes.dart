/// Barrel del módulo [estudiantes].
///
/// Exporta la API pública del módulo de estudiantes: modelos de dominio,
/// repositorios, controladores, pantallas y widgets públicos.
library;

// --- Shared / globales (material, config, temas, modelos comunes) ---
export 'package:bitacoras_app/shared/exports.dart';

// --- Models ---
export 'package:bitacoras_app/features/estudiantes/domain/models/registro_asistencia_model.dart';
export 'package:bitacoras_app/features/estudiantes/domain/models/ubicacion_empresa_model.dart';

// --- Repositories ---
export 'package:bitacoras_app/features/estudiantes/data/repositories/fake_asistencia_repository.dart';
export 'package:bitacoras_app/features/estudiantes/data/repositories/opciones_drawer_estudiante.dart';
export 'package:bitacoras_app/features/estudiantes/domain/repositories/i_asistencia_repository.dart';

// --- Controllers ---
export 'package:bitacoras_app/features/estudiantes/presentation/controllers/asistencia_provider.dart';
export 'package:bitacoras_app/features/estudiantes/presentation/controllers/historial_controller.dart';
export 'package:bitacoras_app/features/estudiantes/presentation/controllers/registro_actividad_controller.dart';
export 'package:bitacoras_app/features/estudiantes/presentation/controllers/registro_asistencia_controller.dart';
export 'package:bitacoras_app/features/estudiantes/presentation/controllers/registro_salida_controller.dart';
export 'package:bitacoras_app/features/estudiantes/presentation/controllers/reportes_controller.dart';

// --- Screens ---
export 'package:bitacoras_app/features/estudiantes/presentation/screens/asistencia/registro_asistencia_screen.dart';
export 'package:bitacoras_app/features/estudiantes/presentation/screens/asistencia/registro_salida_screen.dart';
export 'package:bitacoras_app/features/estudiantes/presentation/screens/bitacoras/registro_actividad_screen.dart';
export 'package:bitacoras_app/features/estudiantes/presentation/screens/historial/historial_screen.dart';
export 'package:bitacoras_app/features/estudiantes/presentation/screens/reportes/reportes_screen.dart';

// --- Widgets ---
export 'package:bitacoras_app/features/estudiantes/presentation/widgets/asistencia/asistencia_action_buttons.dart';
export 'package:bitacoras_app/features/estudiantes/presentation/widgets/asistencia/asistencia_info_tile.dart';
export 'package:bitacoras_app/features/estudiantes/presentation/widgets/asistencia/dialogo_error_gps.dart';
export 'package:bitacoras_app/features/estudiantes/presentation/widgets/asistencia/registro_asistencia_body.dart';
export 'package:bitacoras_app/features/estudiantes/presentation/widgets/asistencia/sesion_activa_card.dart';
export 'package:bitacoras_app/features/estudiantes/presentation/widgets/asistencia/ubicacion_estado_card.dart';
export 'package:bitacoras_app/features/estudiantes/presentation/widgets/bitacoras/actividad_input_card.dart';
export 'package:bitacoras_app/features/estudiantes/presentation/widgets/bitacoras/registro_actividad_action_buttons.dart';
export 'package:bitacoras_app/features/estudiantes/presentation/widgets/bitacoras/registro_actividad_header.dart';
export 'package:bitacoras_app/features/estudiantes/presentation/widgets/bitacoras/registro_actividad_list.dart';
export 'package:bitacoras_app/features/estudiantes/presentation/widgets/compartidos/empresa_card.dart';
export 'package:bitacoras_app/features/estudiantes/presentation/widgets/compartidos/mapa_preview.dart';
export 'package:bitacoras_app/features/estudiantes/presentation/widgets/compartidos/progreso_practicas_card.dart';
export 'package:bitacoras_app/features/estudiantes/presentation/widgets/historial/historial_body.dart';
export 'package:bitacoras_app/features/estudiantes/presentation/widgets/historial/historial_card.dart';
export 'package:bitacoras_app/features/estudiantes/presentation/widgets/historial/historial_empty_state.dart';
export 'package:bitacoras_app/features/estudiantes/presentation/widgets/historial/historial_header.dart';
export 'package:bitacoras_app/features/estudiantes/presentation/widgets/reportes/generador_pdf_card.dart';
export 'package:bitacoras_app/features/estudiantes/presentation/widgets/reportes/reportes_body.dart';
export 'package:bitacoras_app/features/estudiantes/presentation/widgets/reportes/reportes_header.dart';
export 'package:bitacoras_app/features/estudiantes/presentation/widgets/reportes/vista_previa_pdf_card.dart';