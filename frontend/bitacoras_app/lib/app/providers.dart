import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'auth_session.dart';
import '../core/network/api_client.dart';
import '../core/network/token_storage.dart';
import '../features/admin/data/datasources/admin_remote_datasource.dart';
import '../features/admin/data/repositories/admin_repository_impl.dart';
import '../features/admin/domain/repositories/i_admin_repository.dart';
import '../features/auth/data/datasources/auth_remote_datasource.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/i_auth_repository.dart';
import '../features/coordinador/data/datasources/coordinador_remote_datasource.dart';
import '../features/coordinador/data/repositories/coordinador_repository_impl.dart';
import '../features/coordinador/domain/repositories/i_coordinador_repository.dart';
import '../features/estudiantes/data/datasources/asistencia_remote_datasource.dart';
import '../features/estudiantes/data/datasources/bitacora_remote_datasource.dart';
import '../features/estudiantes/data/repositories/asistencia_repository_impl.dart';
import '../features/estudiantes/data/repositories/bitacora_repository_impl.dart';
import '../features/estudiantes/domain/repositories/i_asistencia_repository.dart';
import '../features/estudiantes/presentation/controllers/asistencia_provider.dart';
import '../features/responsable_practicas/data/datasources/responsable_practicas_remote_datasource.dart';
import '../features/responsable_practicas/data/repositories/responsable_practicas_repository_impl.dart';
import '../features/responsable_practicas/domain/repositories/i_responsable_practicas_repository.dart';

List<SingleChildWidget> get appProviders => [
  ChangeNotifierProvider<AuthSession>(create: (_) => AuthSession()),
      Provider<TokenStorage>(create: (_) => TokenStorage()),
      Provider<ApiClient>(
        create: (context) => ApiClient(
          tokenStorage: context.read<TokenStorage>(),
        ),
        dispose: (_, client) => client.close(),
      ),
      Provider<AuthRemoteDataSource>(
        create: (context) => AuthRemoteDataSource(
          apiClient: context.read<ApiClient>(),
        ),
      ),
      Provider<IAuthRepository>(
        create: (context) => AuthRepositoryImpl(
          remoteDataSource: context.read<AuthRemoteDataSource>(),
          tokenStorage: context.read<TokenStorage>(),
        ),
      ),
      Provider<AsistenciaRemoteDataSource>(
        create: (context) => AsistenciaRemoteDataSource(
          apiClient: context.read<ApiClient>(),
        ),
      ),
      Provider<IAsistenciaRepository>(
        create: (context) => AsistenciaRepositoryImpl(
          remoteDataSource: context.read<AsistenciaRemoteDataSource>(),
        ),
      ),
      Provider<BitacoraRemoteDataSource>(
        create: (context) => BitacoraRemoteDataSource(
          apiClient: context.read<ApiClient>(),
        ),
      ),
      Provider<BitacoraRepositoryImpl>(
        create: (context) => BitacoraRepositoryImpl(
          remoteDataSource: context.read<BitacoraRemoteDataSource>(),
        ),
      ),
      Provider<AdminRemoteDataSource>(
        create: (context) => AdminRemoteDataSource(
          apiClient: context.read<ApiClient>(),
        ),
      ),
      Provider<IAdminRepository>(
        create: (context) => AdminRepositoryImpl(
          remoteDataSource: context.read<AdminRemoteDataSource>(),
        ),
      ),
      Provider<CoordinadorRemoteDataSource>(
        create: (context) => CoordinadorRemoteDataSource(
          apiClient: context.read<ApiClient>(),
        ),
      ),
      Provider<ICoordinadorRepository>(
        create: (context) => CoordinadorRepositoryImpl(
          remoteDataSource: context.read<CoordinadorRemoteDataSource>(),
        ),
      ),
      ChangeNotifierProvider(create: (_) => AsistenciaProvider()),
      Provider<ResponsablePracticasRemoteDataSource>(
        create: (context) => ResponsablePracticasRemoteDataSource(
          apiClient: context.read<ApiClient>(),
        ),
      ),
      Provider<IResponsablePracticasRepository>(
        create: (context) => ResponsablePracticasRepositoryImpl(
          remoteDataSource: context.read<ResponsablePracticasRemoteDataSource>(),
        ),
      ),
    ];