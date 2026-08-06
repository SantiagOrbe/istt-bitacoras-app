import 'package:bitacoras_app/features/home/domain/repositories/i_user_repository.dart';
import '../../domain/models/user_model.dart';
import '../../domain/models/user_role.dart';

class FakeUserRepository implements IUserRepository {
  static const student = UserModel(
    id: 1,
    fullName: 'Santiago Orbe',
    email: 'santiago.orbe@est.itstena.edu.ec',
    company: 'Instituto Superior Tecnológico Tena',
    role: UserRole.student,
  );

  static const teacher = UserModel(
    id: 2,
    fullName: 'Juan Pérez',
    email: 'juan.perez@itstena.edu.ec',
    company: 'Instituto Superior Tecnológico Tena',
    role: UserRole.teacher,
  );

  static const academicTutor = UserModel(
    id: 3,
    fullName: 'María López',
    email: 'maria.lopez@itstena.edu.ec',
    company: 'Instituto Superior Tecnológico Tena',
    role: UserRole.academicTutor,
  );

  static const companyTutor = UserModel(
    id: 4,
    fullName: 'Carlos Ruiz',
    email: 'carlos.ruiz@empresa.com',
    company: 'Empresa XYZ',
    role: UserRole.companyTutor,
  );

  static const coordinator = UserModel(
    id: 5,
    fullName: 'Ana Morales',
    email: 'ana.morales@itstena.edu.ec',
    company: 'Instituto Superior Tecnológico Tena',
    role: UserRole.coordinator,
  );

  static const practiceManager = UserModel(
    id: 6,
    fullName: 'Luis Herrera',
    email: 'luis.herrera@itstena.edu.ec',
    company: 'Instituto Superior Tecnológico Tena',
    role: UserRole.practiceManager,
  );

  static const admin = UserModel(
    id: 7,
    fullName: 'Administrador',
    email: 'admin@itstena.edu.ec',
    company: 'Instituto Superior Tecnológico Tena',
    role: UserRole.admin,
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
  Future<UserModel> getCurrentUser() async {
    // Retorna un usuario mock por defecto para pruebas
    await Future.delayed(const Duration(milliseconds: 300));
    return student;
  }

  @override
  Future<UserModel?> login(String email, String password) async {
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