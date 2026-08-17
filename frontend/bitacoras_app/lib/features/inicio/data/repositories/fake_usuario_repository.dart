import 'package:bitacoras_app/features/inicio/domain/repositories/i_usuario_repository.dart';
import '../../domain/models/usuario_model.dart';
import '../../domain/models/rol_usuario_model.dart';

class FakeUsuarioRepository implements IUsuarioRepository {
  static const student = UsuarioModel(
    id: '1',
    name: 'Santiago Orbe',
    email: 'santiago.orbe@est.itstena.edu.ec',
    company: 'Instituto Superior Tecnológico Tena',
    role: RolUsuarioModel.student,
  );

  static const teacher = UsuarioModel(
    id: '2',
    name: 'Juan Pérez',
    email: 'juan.perez@itstena.edu.ec',
    company: 'Instituto Superior Tecnológico Tena',
    role: RolUsuarioModel.teacher,
  );

  static const academicTutor = UsuarioModel(
    id: '3',
    name: 'María López',
    email: 'maria.lopez@itstena.edu.ec',
    company: 'Instituto Superior Tecnológico Tena',
    role: RolUsuarioModel.academicTutor,
  );

  static const companyTutor = UsuarioModel(
    id: '4',
    name: 'Carlos Ruiz',
    email: 'carlos.ruiz@empresa.com',
    company: 'Empresa XYZ',
    role: RolUsuarioModel.companyTutor,
  );

  static const coordinator = UsuarioModel(
    id: '5',
    name: 'Ana Morales',
    email: 'ana.morales@itstena.edu.ec',
    company: 'Instituto Superior Tecnológico Tena',
    role: RolUsuarioModel.coordinator,
  );

  static const practiceManager = UsuarioModel(
    id: '6',
    name: 'Luis Herrera',
    email: 'luis.herrera@itstena.edu.ec',
    company: 'Instituto Superior Tecnológico Tena',
    role: RolUsuarioModel.practiceManager,
  );

  static const admin = UsuarioModel(
    id: '7',
    name: 'Administrador',
    email: 'admin@itstena.edu.ec',
    company: 'Instituto Superior Tecnológico Tena',
    role: RolUsuarioModel.admin,
  );

  static const Map<String, String> _credentials = {
    'santiago.orbe@est.itstena.edu.ec': 'santi123',
    'juan.perez@itstena.edu.ec': 'juan123',
    'maria.lopez@itstena.edu.ec': 'maria123',
    'carlos.ruiz@empresa.com': 'carlos123',
    'ana.morales@itstena.edu.ec': 'ana123',
    'luis.herrera@itstena.edu.ec': 'luis123',
    'admin@itstena.edu.ec': 'admin123',
  };

  @override
  Future<UsuarioModel> getCurrentUser() async {
    // Retorna un usuario mock por defecto para pruebas
    await Future.delayed(const Duration(milliseconds: 300));
    return student;
  }

  @override
  Future<UsuarioModel?> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 1200));

    final cleanEmail = email.trim().toLowerCase();

    if (_credentials.containsKey(cleanEmail) && _credentials[cleanEmail] == password) {
      if (cleanEmail == student.email) return student;
      if (cleanEmail == teacher.email) return teacher;
      if (cleanEmail == academicTutor.email) return academicTutor;
      if (cleanEmail == companyTutor.email) return companyTutor;
      if (cleanEmail == coordinator.email) return coordinator;
      if (cleanEmail == practiceManager.email) return practiceManager;
      if (cleanEmail == admin.email) return admin;
    }

    return null;
  }
}