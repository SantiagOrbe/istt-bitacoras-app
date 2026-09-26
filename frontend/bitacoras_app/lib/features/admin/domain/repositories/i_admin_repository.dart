import 'package:bitacoras_app/features/admin/admin.dart';

abstract class IAdminRepository {
  // --- Gestión de Usuarios ---
  Future<List<UsuarioModel>> obtenerUsuarios({
    bool? isActive,
    String? role,
    String? search,
  });
  Future<bool> crearUsuario(UsuarioModel usuario);
  Future<bool> actualizarUsuario(UsuarioModel usuario);
  Future<bool> cambiarEstadoUsuario(String userId, bool isActive);
  Future<bool> eliminarUsuario(String userId);

  Future<List<EmpresaModel>> obtenerEmpresas();
  Future<bool> crearEmpresa(EmpresaModel empresa);
  Future<bool> actualizarEmpresa(EmpresaModel empresa);
  Future<bool> desactivarEmpresa(
    String companyId, {
    bool unlinkStudents = false,
  });
  Future<List<Map<String, String>>> obtenerEstudiantesVinculadosEmpresa(
    String companyId,
  );

  // --- Gestión de Cursos / Ciclos ---
  Future<List<CicloModel>> obtenerCiclos({String? careerId});
  Future<bool> crearCiclo(CicloModel ciclo);
  Future<bool> actualizarCiclo(CicloModel ciclo);

  // --- Gestión de Paralelos ---
  Future<List<ParaleloModel>> obtenerParalelos({
    String? careerId,
    String? semesterId,
  });
  Future<bool> crearParalelo(ParaleloModel paralelo);
  Future<bool> actualizarParalelo(ParaleloModel paralelo);
  Future<List<Map<String, dynamic>>> obtenerEstudiantesParalelo(
    String parallelId,
  );
  Future<bool> asignarEstudiantesParalelo(
    String parallelId,
    List<int> studentIds,
  );
  Future<bool> eliminarEstudiantesParalelo(String parallelId);

  // --- Gestión de Carreras ---
  Future<List<CarreraModel>> obtenerCarreras();
  Future<bool> crearCarrera(CarreraModel carrera);
  Future<bool> actualizarCarrera(
    CarreraModel carrera, {
    bool confirmDesactivate = false,
  });

  // --- Gestión de Periodos Lectivos ---
  Future<List<PeriodoModel>> obtenerPeriodos();
  Future<bool> crearPeriodo(PeriodoModel periodo);
  Future<bool> actualizarPeriodo(
    PeriodoModel periodo, {
    bool confirmDesactivate = false,
  });

  // --- Configuración Carrera / Periodo ---
  Future<List<ConfiguracionPeriodoCarreraModel>>
  obtenerConfiguracionesPeriodoCarrera();
  Future<bool> guardarConfiguracionPeriodoCarrera(
    ConfiguracionPeriodoCarreraModel config,
  );
  Future<bool> guardarConfiguracionesCarrerasPeriodo(
    String periodId,
    List<ConfiguracionPeriodoCarreraModel> configs,
  );

  Future<List<RegistroPracticaModel>> obtenerRegistrosPractica();
}
