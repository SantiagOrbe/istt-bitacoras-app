/// Barrel del módulo [inicio] (home).
///
/// Exporta la API pública del módulo de inicio: modelos, repositorios,
/// controladores, pantallas de rol, dashboard y widgets del drawer.
library;

// --- Shared / globales (material, config, temas, modelos comunes) ---
export 'package:bitacoras_app/shared/exports.dart';

// --- Models ---
export 'package:bitacoras_app/features/inicio/domain/models/accion_rapida_model.dart';
export 'package:bitacoras_app/features/inicio/domain/models/rol_usuario_model.dart';
export 'package:bitacoras_app/features/inicio/domain/models/usuario_model.dart';

// --- Repositories ---
export 'package:bitacoras_app/features/inicio/data/repositories/fake_tablero_repository.dart';
export 'package:bitacoras_app/features/inicio/data/repositories/fake_usuario_repository.dart';
export 'package:bitacoras_app/features/inicio/domain/repositories/i_tablero_repository.dart';
export 'package:bitacoras_app/features/inicio/domain/repositories/i_usuario_repository.dart';

// --- Controllers ---
export 'package:bitacoras_app/features/inicio/presentation/controllers/inicio_navegacion_controller.dart';

// --- Screens ---
export 'package:bitacoras_app/features/inicio/presentation/screens/inicio_screen.dart';
export 'package:bitacoras_app/features/inicio/presentation/screens/roles/inicio_admin_screen.dart';
export 'package:bitacoras_app/features/inicio/presentation/screens/roles/inicio_coordinador_screen.dart';
export 'package:bitacoras_app/features/inicio/presentation/screens/roles/inicio_docente_screen.dart';
export 'package:bitacoras_app/features/inicio/presentation/screens/roles/inicio_estudiante_screen.dart';
export 'package:bitacoras_app/features/inicio/presentation/screens/roles/inicio_responsable_practicas_screen.dart';
export 'package:bitacoras_app/features/inicio/presentation/screens/roles/inicio_tutor_academico_screen.dart';
export 'package:bitacoras_app/features/inicio/presentation/screens/roles/inicio_tutor_empresarial_screen.dart';

// --- Widgets ---
export 'package:bitacoras_app/features/inicio/presentation/widgets/dashboard/acceso_rapido_card.dart';
export 'package:bitacoras_app/features/inicio/presentation/widgets/dashboard/acciones_tablero_widget.dart';
export 'package:bitacoras_app/features/inicio/presentation/widgets/dashboard/cuerpo_tablero_widget.dart';
export 'package:bitacoras_app/features/inicio/presentation/widgets/dashboard/estado_card.dart';
export 'package:bitacoras_app/features/inicio/presentation/widgets/dashboard/saludo_card.dart';
export 'package:bitacoras_app/features/inicio/presentation/widgets/dashboard/titulo_seccion_tablero_widget.dart';
export 'package:bitacoras_app/features/inicio/presentation/widgets/drawer/inicio_drawer.dart';
export 'package:bitacoras_app/features/inicio/presentation/widgets/drawer/opciones_drawer_factory.dart';
export 'package:bitacoras_app/features/inicio/presentation/widgets/encabezado_bienvenida_widget.dart';
export 'package:bitacoras_app/features/inicio/presentation/widgets/inicio_app_bar.dart';
export 'package:bitacoras_app/features/inicio/presentation/widgets/info_usuario_card.dart';