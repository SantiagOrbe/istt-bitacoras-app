import 'package:bitacoras_app/features/admin/admin.dart';
import 'package:bitacoras_app/features/inicio/domain/models/usuario_model.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeAdminRepository implements IAdminRepository {
  final List<UsuarioModel> users;
  bool updatedCalled = false;

  _FakeAdminRepository({required this.users});

  @override
  Future<List<UsuarioModel>> obtenerUsuarios({
    bool? isActive,
    String? role,
    String? search,
  }) async => users;

  @override
  Future<bool> crearUsuario(UsuarioModel usuario) async => true;

  @override
  Future<bool> actualizarUsuario(UsuarioModel usuario) async {
    updatedCalled = true;
    return true;
  }

  @override
  Future<bool> cambiarEstadoUsuario(String userId, bool isActive) async => true;

  @override
  Future<bool> eliminarUsuario(String userId) async => true;

  @override
  Future<List<EmpresaModel>> obtenerEmpresas() async => const [];

  @override
  Future<bool> crearEmpresa(EmpresaModel empresa) async => true;

  @override
  Future<bool> actualizarEmpresa(EmpresaModel empresa) async => true;

  @override
  Future<bool> desactivarEmpresa(String companyId, {bool unlinkStudents = false}) async => true;

  @override
  Future<List<Map<String, String>>> obtenerEstudiantesVinculadosEmpresa(String companyId) async => const [];

  @override
  Future<List<CicloModel>> obtenerCiclos({String? careerId}) async => const [];

  @override
  Future<bool> crearCiclo(CicloModel ciclo) async => true;

  @override
  Future<bool> actualizarCiclo(CicloModel ciclo) async => true;

  @override
  Future<List<ParaleloModel>> obtenerParalelos({String? careerId, String? semesterId}) async => const [];

  @override
  Future<bool> crearParalelo(ParaleloModel paralelo) async => true;

  @override
  Future<bool> actualizarParalelo(ParaleloModel paralelo) async => true;

  @override
  Future<List<Map<String, dynamic>>> obtenerEstudiantesParalelo(String parallelId) async => const [];

  @override
  Future<bool> asignarEstudiantesParalelo(String parallelId, List<int> studentIds) async => true;

  @override
  Future<bool> eliminarEstudiantesParalelo(String parallelId) async => true;

  @override
  Future<List<CarreraModel>> obtenerCarreras() async => const [];

  @override
  Future<bool> crearCarrera(CarreraModel carrera) async => true;

  @override
  Future<bool> actualizarCarrera(CarreraModel carrera, {bool confirmDesactivate = false}) async => true;

  @override
  Future<List<PeriodoModel>> obtenerPeriodos() async => const [];

  @override
  Future<bool> crearPeriodo(PeriodoModel periodo) async => true;

  @override
  Future<bool> actualizarPeriodo(PeriodoModel periodo, {bool confirmDesactivate = false}) async => true;

  @override
  Future<List<ConfiguracionPeriodoCarreraModel>> obtenerConfiguracionesPeriodoCarrera() async => const [];

  @override
  Future<bool> guardarConfiguracionPeriodoCarrera(ConfiguracionPeriodoCarreraModel config) async => true;

  @override
  Future<bool> guardarConfiguracionesCarrerasPeriodo(
    String periodId,
    List<ConfiguracionPeriodoCarreraModel> configs,
  ) async => true;

  @override
  Future<List<RegistroPracticaModel>> obtenerRegistrosPractica() async => const [];
}

void main() {
  group('UsuarioDetailController', () {
    test('bloquea guardar cuando el teléfono ya está registrado por otro usuario', () async {
      final repo = _FakeAdminRepository(
        users: [
          const UsuarioModel(
            id: 'user-1',
            name: 'Otro Usuario',
            email: 'otro@est.itstena.edu.ec',
            role: RolUsuarioModel.student,
            phone: '0999999999',
            cedula: '1712345678',
          ),
        ],
      );

      final controller = UsuarioDetailController(
        repository: repo,
        initialUser: const UsuarioModel(
          id: 'user-2',
          name: 'Usuario Actual',
          email: 'actual@est.itstena.edu.ec',
          role: RolUsuarioModel.student,
          phone: '0988888888',
          cedula: '1712345675',
        ),
      );

      controller.phoneController.text = '0999999999';
      controller.cedulaController.text = '1712345675';

      final result = await controller.saveChanges();

      expect(result, isFalse);
      expect(controller.errorMessage,
          'El número de teléfono ya está registrado por otro usuario.');
      expect(repo.updatedCalled, isFalse);
    });

    test('rechaza una cédula con formato inválido antes de guardar', () async {
      final repo = _FakeAdminRepository(users: const []);
      final controller = UsuarioDetailController(
        repository: repo,
        initialUser: const UsuarioModel(
          id: 'user-2',
          name: 'Usuario Actual',
          email: 'actual@est.itstena.edu.ec',
          role: RolUsuarioModel.student,
          cedula: '1712345675',
        ),
      );

      controller.nameController.text = 'Usuario Actual';
      controller.emailController.text = 'actual@est.itstena.edu.ec';
      controller.cedulaController.text = '123';

      final result = await controller.saveChanges();

      expect(result, isFalse);
      expect(controller.errorMessage,
          'La cédula debe tener 10 dígitos.');
      expect(repo.updatedCalled, isFalse);
    });
  });
}
