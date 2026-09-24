/// Barrel público del módulo de coordinación académica.
library;

// --- Datos ---
export 'package:bitacoras_app/features/coordinador/data/coordinador_drawer_items.dart';
export 'package:bitacoras_app/features/coordinador/data/datasources/coordinador_remote_datasource.dart';
export 'package:bitacoras_app/features/coordinador/data/repositories/coordinador_repository_impl.dart';
export 'package:bitacoras_app/core/network/api_client.dart';
export '../../../../app/apps.dart';


// --- Dominio ---
export 'package:bitacoras_app/features/coordinador/domain/models/coordinador_model.dart';
export 'package:bitacoras_app/features/coordinador/domain/models/coordinador_datos_model.dart';
export 'package:bitacoras_app/features/coordinador/domain/repositories/i_coordinador_repository.dart';

// --- Presentación ---
export 'package:bitacoras_app/features/coordinador/presentation/controllers/coordinador_consulta_controller.dart';
export 'package:bitacoras_app/features/coordinador/presentation/screens/coordinador_dashboard_screen.dart';
export 'package:bitacoras_app/features/coordinador/presentation/screens/coordinador_carreras_screen.dart';
export 'package:bitacoras_app/features/coordinador/presentation/screens/coordinador_estudiantes_screen.dart';
export 'package:bitacoras_app/features/coordinador/presentation/screens/coordinador_tutores_screen.dart';
export 'package:bitacoras_app/features/coordinador/presentation/widgets/coordinador_info_card.dart';
