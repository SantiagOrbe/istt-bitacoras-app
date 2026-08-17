/// Barrel del módulo [responsable_practicas].
///
/// Exporta la API pública del módulo de gestión de prácticas: modelos,
/// repositorios, opciones de drawer, controladores, pantallas y widgets.
library;

// --- Shared / globales (material, config, temas, modelos comunes) ---
export 'package:bitacoras_app/shared/exports.dart';

// --- Models ---
export 'package:bitacoras_app/features/responsable_practicas/domain/models/asignacion_estudiante_model.dart';
export 'package:bitacoras_app/features/responsable_practicas/domain/models/empresa_model.dart';

// --- Data y Repositories ---
export 'package:bitacoras_app/features/responsable_practicas/data/repositories/fake_responsable_practicas_repository.dart';
export 'package:bitacoras_app/features/responsable_practicas/data/responsable_practicas_drawer_options.dart';
export 'package:bitacoras_app/features/responsable_practicas/domain/repositories/i_responsable_practicas_repository.dart';

// --- Controllers ---
export 'package:bitacoras_app/features/responsable_practicas/presentation/controllers/asignacion_estudiante_controller.dart';
export 'package:bitacoras_app/features/responsable_practicas/presentation/controllers/gestion_empresa_controller.dart';

// --- Screens ---
export 'package:bitacoras_app/features/responsable_practicas/presentation/screens/asignaciones/asignacion_estudiantes_screen.dart';
export 'package:bitacoras_app/features/responsable_practicas/presentation/screens/asignaciones/formulario_asignacion_estudiante_screen.dart';
export 'package:bitacoras_app/features/responsable_practicas/presentation/screens/empresas/formulario_empresa_screen.dart';
export 'package:bitacoras_app/features/responsable_practicas/presentation/screens/empresas/gestion_empresas_screen.dart';

// --- Widgets ---
export 'package:bitacoras_app/features/responsable_practicas/presentation/widgets/asignaciones/asignacion_estudiantes_body.dart';
export 'package:bitacoras_app/features/responsable_practicas/presentation/widgets/asignaciones/asignacion_estudiante_card.dart';
export 'package:bitacoras_app/features/responsable_practicas/presentation/widgets/asignaciones/asignacion_estudiante_dropdowns.dart';
export 'package:bitacoras_app/features/responsable_practicas/presentation/widgets/asignaciones/formulario_asignacion_estudiante_body.dart';
export 'package:bitacoras_app/features/responsable_practicas/presentation/widgets/empresas/empresa_card.dart';
export 'package:bitacoras_app/features/responsable_practicas/presentation/widgets/empresas/formulario_empresa_body.dart';
export 'package:bitacoras_app/features/responsable_practicas/presentation/widgets/empresas/formulario_empresa_campos.dart';
export 'package:bitacoras_app/features/responsable_practicas/presentation/widgets/empresas/formulario_empresa_header.dart';