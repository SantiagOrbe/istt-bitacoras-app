/// Barrel del módulo [tutores].
///
/// Exporta la API pública del módulo de tutores: modelos, repositorios,
/// opciones de drawer, pantallas y widgets.
library;

// --- Shared / globales (material, config, temas, modelos comunes) ---
export 'package:bitacoras_app/shared/exports.dart';

// --- Models ---
export 'package:bitacoras_app/features/tutores/domain/models/estudiante_asignado_model.dart';
export 'package:bitacoras_app/features/tutores/domain/models/visita_academica_model.dart';

// --- Data y Repositories ---
export 'package:bitacoras_app/features/tutores/data/opciones_drawer_tutor.dart';
export 'package:bitacoras_app/features/tutores/data/repositories/fake_tutor_repository.dart';
export 'package:bitacoras_app/features/tutores/domain/repositories/i_tutor_repository.dart';

// --- Screens ---
export 'package:bitacoras_app/features/tutores/presentation/screens/estudiantes_asignados/estudiantes_asignados_screen.dart';
export 'package:bitacoras_app/features/tutores/presentation/screens/seguimiento/detalle_seguimiento_estudiante_screen.dart';
export 'package:bitacoras_app/features/tutores/presentation/screens/seguimiento/seguimiento_estudiantes_screen.dart';
export 'package:bitacoras_app/features/tutores/presentation/screens/visitas/formulario_actividad_visita_screen.dart';
export 'package:bitacoras_app/features/tutores/presentation/screens/visitas/registro_salida_visita_screen.dart';
export 'package:bitacoras_app/features/tutores/presentation/screens/visitas/registro_visita_screen.dart';

// --- Widgets ---
export 'package:bitacoras_app/features/tutores/presentation/widgets/estudiantes_asignados/estudiante_tutorizado_card.dart';
export 'package:bitacoras_app/features/tutores/presentation/widgets/seguimiento/seguimiento_estudiante_card.dart';
export 'package:bitacoras_app/features/tutores/presentation/widgets/visitas/cabecera_visita_card.dart';