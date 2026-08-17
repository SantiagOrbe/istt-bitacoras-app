/// Barrel del módulo [admin].
///
/// Exporta la API pública del módulo de administración: modelos de dominio,
/// repositorios, controladores, pantallas y widgets públicos.
library;

// --- Shared / globales (material, config, temas, modelos comunes) ---
export 'package:bitacoras_app/shared/exports.dart';

// --- Models ---
export 'package:bitacoras_app/features/admin/domain/models/carrera_model.dart';
export 'package:bitacoras_app/features/admin/domain/models/ciclo_model.dart';
export 'package:bitacoras_app/features/admin/domain/models/configuracion_periodo_carrera_model.dart';
export 'package:bitacoras_app/features/admin/domain/models/item_menu_model.dart';
export 'package:bitacoras_app/features/admin/domain/models/paralelo_model.dart';
export 'package:bitacoras_app/features/admin/domain/models/periodo_model.dart';
export 'package:bitacoras_app/features/admin/domain/models/registro_practica_model.dart';
export 'package:bitacoras_app/features/admin/domain/models/usuario_gestionado_model.dart';

// --- Repositories ---
export 'package:bitacoras_app/features/admin/data/repositories/fake_admin_repository.dart';
export 'package:bitacoras_app/features/admin/domain/repositories/i_admin_repository.dart';

// --- Controllers ---
export 'package:bitacoras_app/features/admin/presentation/controllers/academico/carrera_periodo_controller.dart';
export 'package:bitacoras_app/features/admin/presentation/controllers/academico/gestion_carrera_controller.dart';
export 'package:bitacoras_app/features/admin/presentation/controllers/academico/gestion_ciclo_controller.dart';
export 'package:bitacoras_app/features/admin/presentation/controllers/academico/gestion_paralelo_controller.dart';
export 'package:bitacoras_app/features/admin/presentation/controllers/academico/gestion_periodo_controller.dart';
export 'package:bitacoras_app/features/admin/presentation/controllers/usuarios/gestion_usuario_controller.dart';
export 'package:bitacoras_app/features/admin/presentation/controllers/usuarios/usuario_detail_controller.dart';

// --- Screens ---
export 'package:bitacoras_app/features/admin/presentation/screens/academico/carrera_detail_screen.dart';
export 'package:bitacoras_app/features/admin/presentation/screens/academico/carrera_periodo_screen.dart';
export 'package:bitacoras_app/features/admin/presentation/screens/academico/gestion_carrera_screen.dart';
export 'package:bitacoras_app/features/admin/presentation/screens/academico/gestion_ciclo_screen.dart';
export 'package:bitacoras_app/features/admin/presentation/screens/academico/gestion_paralelo_screen.dart';
export 'package:bitacoras_app/features/admin/presentation/screens/academico/gestion_periodo_screen.dart';
export 'package:bitacoras_app/features/admin/presentation/screens/practicas/admin_bitacoras_screen.dart';
export 'package:bitacoras_app/features/admin/presentation/screens/usuarios/gestion_usuario_screen.dart';
export 'package:bitacoras_app/features/admin/presentation/screens/usuarios/usuario_detail_screen.dart';

// --- Widgets ---
export 'package:bitacoras_app/features/admin/presentation/widgets/admin_empty_state.dart';
export 'package:bitacoras_app/features/admin/presentation/widgets/admin_header.dart';
export 'package:bitacoras_app/features/admin/presentation/widgets/admin_status_chip.dart';
export 'package:bitacoras_app/features/admin/presentation/widgets/save_bottom_bar.dart';
export 'package:bitacoras_app/features/admin/presentation/widgets/academico/carrera_card.dart';
export 'package:bitacoras_app/features/admin/presentation/widgets/academico/carrera_config_card.dart';
export 'package:bitacoras_app/features/admin/presentation/widgets/academico/carrera_empty_state.dart';
export 'package:bitacoras_app/features/admin/presentation/widgets/academico/carrera_form_sheet.dart';
export 'package:bitacoras_app/features/admin/presentation/widgets/academico/carrera_periodo_body.dart';
export 'package:bitacoras_app/features/admin/presentation/widgets/academico/carrera_search_bar.dart';
export 'package:bitacoras_app/features/admin/presentation/widgets/academico/ciclo_card.dart';
export 'package:bitacoras_app/features/admin/presentation/widgets/academico/ciclo_form_sheet.dart';
export 'package:bitacoras_app/features/admin/presentation/widgets/academico/paralelo_card.dart';
export 'package:bitacoras_app/features/admin/presentation/widgets/academico/paralelo_form_sheet.dart';
export 'package:bitacoras_app/features/admin/presentation/widgets/academico/periodo_card.dart';
export 'package:bitacoras_app/features/admin/presentation/widgets/academico/periodo_empty_state.dart';
export 'package:bitacoras_app/features/admin/presentation/widgets/academico/periodo_form_sheet.dart';
export 'package:bitacoras_app/features/admin/presentation/widgets/academico/periodo_selector_card.dart';
export 'package:bitacoras_app/features/admin/presentation/widgets/usuarios/gestion_usuario_body.dart';
export 'package:bitacoras_app/features/admin/presentation/widgets/usuarios/usuario_detail_action_buttons.dart';
export 'package:bitacoras_app/features/admin/presentation/widgets/usuarios/usuario_detail_header.dart';
export 'package:bitacoras_app/features/admin/presentation/widgets/usuarios/usuario_info_card.dart';
export 'package:bitacoras_app/features/admin/presentation/widgets/usuarios/usuario_list_tile.dart';
export 'package:bitacoras_app/features/admin/presentation/widgets/usuarios/usuario_metricas_header.dart';
export 'package:bitacoras_app/features/admin/presentation/widgets/usuarios/usuario_search_bar.dart';
