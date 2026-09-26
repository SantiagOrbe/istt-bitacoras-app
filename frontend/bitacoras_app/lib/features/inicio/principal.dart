/// Barrel del módulo [principal].
///
/// Exporta la API pública del módulo de inicio: modelos, pantallas y widgets
/// del home principal de la aplicación.
library;

// --- Shared / globales (material, config, temas, modelos comunes) ---
export 'package:bitacoras_app/shared/exports.dart';

// --- Models ---
export 'package:bitacoras_app/features/inicio/domain/models/accion_rapida_model.dart';
export 'package:bitacoras_app/features/inicio/domain/models/rol_usuario_model.dart';
export 'package:bitacoras_app/features/inicio/domain/models/usuario_model.dart';

// --- Screens ---
export 'package:bitacoras_app/features/inicio/presentation/screens/inicio_screen.dart';

// --- Widgets ---
export 'package:bitacoras_app/features/inicio/presentation/widgets/dashboard/acceso_rapido_card.dart';
export 'package:bitacoras_app/features/inicio/presentation/widgets/dashboard/acciones_tablero_widget.dart';
export 'package:bitacoras_app/features/inicio/presentation/widgets/dashboard/estado_card.dart';
export 'package:bitacoras_app/features/inicio/presentation/widgets/dashboard/saludo_card.dart';
export 'package:bitacoras_app/features/inicio/presentation/widgets/dashboard/titulo_seccion_tablero_widget.dart';
export 'package:bitacoras_app/features/inicio/presentation/widgets/drawer/inicio_drawer.dart';
export 'package:bitacoras_app/features/inicio/presentation/widgets/drawer/opciones_drawer_factory.dart';
export 'package:bitacoras_app/features/inicio/presentation/widgets/inicio_app_bar.dart';
