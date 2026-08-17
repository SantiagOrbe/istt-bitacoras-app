export 'package:go_router/go_router.dart';

// Barrel global de la app: re-exporta configuración, temas, módulos y auth.
export 'package:bitacoras_app/shared/exports.dart';

// Exportaciones de módulos (barrel files por feature)
// Nota: 'EmpresaCard' de responsable_practicas se exporta por su barrel;
// se oculta aquí para no chocar con el EmpresaCard del módulo estudiantes.
export 'package:bitacoras_app/features/admin/admin.dart';
export 'package:bitacoras_app/features/estudiantes/estudiantes.dart';
export 'package:bitacoras_app/features/inicio/inicio.dart';
export 'package:bitacoras_app/features/perfiles/perfiles.dart';
export 'package:bitacoras_app/features/responsable_practicas/responsable_practicas.dart' hide EmpresaCard;
export 'package:bitacoras_app/features/tutores/tutores.dart';

// Auth (sin barrel propio)
export 'package:bitacoras_app/features/auth/data/repositories/auth_repository_impl.dart';
export 'package:bitacoras_app/features/auth/presentation/screens/login_screen.dart';