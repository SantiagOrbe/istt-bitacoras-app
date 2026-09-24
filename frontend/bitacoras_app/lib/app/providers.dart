import 'package:bitacoras_app/app/apps.dart';

List<SingleChildWidget> get appProviders => [
  ChangeNotifierProvider<AuthSession>(create: (_) => AuthSession()),
  Provider<TokenStorage>(create: (_) => TokenStorage()),
  Provider<ApiClient>(
    create: (context) => ApiClient(tokenStorage: context.read<TokenStorage>()),
    dispose: (_, client) => client.close(),
  ),
  Provider<AuthRemoteDataSource>(
    create: (context) =>
        AuthRemoteDataSource(apiClient: context.read<ApiClient>()),
  ),
  Provider<IAuthRepository>(
    create: (context) => AuthRepositoryImpl(
      remoteDataSource: context.read<AuthRemoteDataSource>(),
      tokenStorage: context.read<TokenStorage>(),
    ),
  ),
  Provider<AsistenciaRemoteDataSource>(
    create: (context) =>
        AsistenciaRemoteDataSource(apiClient: context.read<ApiClient>()),
  ),
  Provider<IAsistenciaRepository>(
    create: (context) => AsistenciaRepositoryImpl(
      remoteDataSource: context.read<AsistenciaRemoteDataSource>(),
    ),
  ),
  Provider<BitacoraRemoteDataSource>(
    create: (context) =>
        BitacoraRemoteDataSource(apiClient: context.read<ApiClient>()),
  ),
  Provider<BitacoraRepositoryImpl>(
    create: (context) => BitacoraRepositoryImpl(
      remoteDataSource: context.read<BitacoraRemoteDataSource>(),
    ),
  ),
  Provider<AdminRemoteDataSource>(
    create: (context) =>
        AdminRemoteDataSource(apiClient: context.read<ApiClient>()),
  ),
  Provider<IAdminRepository>(
    create: (context) => AdminRepositoryImpl(
      remoteDataSource: context.read<AdminRemoteDataSource>(),
    ),
  ),
  Provider<CoordinadorRemoteDataSource>(
    create: (context) =>
        CoordinadorRemoteDataSource(apiClient: context.read<ApiClient>()),
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
  Provider<TutorRemoteDataSource>(
    create: (context) => TutorRemoteDataSource(
      apiClient: context.read<ApiClient>(),
    ),
  ),
  Provider<ITutorRepository>(
    create: (context) => TutorRepositoryImpl(
      remoteDataSource: context.read<TutorRemoteDataSource>(),
    ),
  ),
];
