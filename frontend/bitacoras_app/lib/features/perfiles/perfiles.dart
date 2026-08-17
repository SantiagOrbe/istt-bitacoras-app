/// Barrel del módulo [perfiles].
///
/// Exporta la API pública del módulo de perfiles: modelos, pantallas y widgets.
library;

// --- Shared / globales (material, config, temas, modelos comunes) ---
export 'package:bitacoras_app/shared/exports.dart';

// --- Models ---
export 'package:bitacoras_app/features/perfiles/domain/models/perfil_model.dart';

// --- Screens ---
export 'package:bitacoras_app/features/perfiles/presentation/screens/perfil_screen.dart';

// --- Widgets ---
export 'package:bitacoras_app/features/perfiles/presentation/widgets/perfil_header_card.dart';
export 'package:bitacoras_app/features/perfiles/presentation/widgets/perfil_info_tile.dart';