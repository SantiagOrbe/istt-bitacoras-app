
library;


// --- Shared / globales (material, config, temas, modelos comunes) ---
export 'package:bitacoras_app/shared/exports.dart';
export '../../../../app/apps.dart' hide EmpresaModel;

// --- Models ---
export 'package:bitacoras_app/features/responsable_practicas/domain/models/empresa_model.dart';
export 'package:bitacoras_app/features/responsable_practicas/domain/models/asignacion_estudiante_model.dart';

// --- Data y Repositories ---
export 'package:bitacoras_app/features/responsable_practicas/data/datasources/responsable_practicas_remote_datasource.dart';
export 'package:bitacoras_app/features/responsable_practicas/data/responsable_practicas_drawer_options.dart';
export 'package:bitacoras_app/features/responsable_practicas/domain/repositories/i_responsable_practicas_repository.dart';
export 'package:bitacoras_app/core/network/api_client.dart';

// --- Controllers ---
export 'package:bitacoras_app/features/responsable_practicas/presentation/controllers/asignacion_estudiante_controller.dart';
export 'package:bitacoras_app/features/responsable_practicas/presentation/controllers/gestion_empresa_controller.dart';
export 'package:bitacoras_app/features/inicio/domain/models/accion_rapida_model.dart';
export 'package:flutter/material.dart';
export 'package:bitacoras_app/app/routes/app_routes.dart';


// --- Screens ---
export 'package:bitacoras_app/features/responsable_practicas/presentation/screens/inicio_responsable_practicas_screen.dart';
export 'package:bitacoras_app/features/responsable_practicas/presentation/screens/asignaciones/asignacion_estudiantes_screen.dart';
export 'package:bitacoras_app/features/responsable_practicas/presentation/screens/asignaciones/formulario_asignacion_estudiante_screen.dart';
export 'package:bitacoras_app/features/responsable_practicas/presentation/screens/empresas/formulario_empresa_screen.dart';
export 'package:bitacoras_app/features/responsable_practicas/presentation/screens/empresas/gestion_empresas_screen.dart';
export 'package:bitacoras_app/features/responsable_practicas/presentation/screens/empresas/detalle_empresa_responsable_screen.dart';

// --- Widgets ---
export 'package:bitacoras_app/features/responsable_practicas/presentation/widgets/asignaciones/asignacion_estudiantes_body.dart';
export 'package:bitacoras_app/features/responsable_practicas/presentation/widgets/asignaciones/asignacion_estudiante_card.dart';
export 'package:bitacoras_app/features/responsable_practicas/presentation/widgets/asignaciones/asignacion_estudiante_dropdowns.dart';
export 'package:bitacoras_app/features/responsable_practicas/presentation/widgets/asignaciones/formulario_asignacion_estudiante_body.dart';
export 'package:bitacoras_app/features/responsable_practicas/presentation/widgets/empresas/formulario_empresa_body.dart';
export 'package:bitacoras_app/features/responsable_practicas/presentation/widgets/empresas/formulario_empresa_campos.dart';
export 'package:bitacoras_app/features/responsable_practicas/presentation/widgets/empresas/formulario_empresa_header.dart';