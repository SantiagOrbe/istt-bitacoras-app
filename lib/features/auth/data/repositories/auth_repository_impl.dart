import '../../domain/repositories/i_auth_repository.dart';
import 'package:bitacoras_app/shared/exports.dart';
import 'package:bitacoras_app/features/home/data/repositories/fake_user_repository.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final FakeUserRepository _userRepository = FakeUserRepository();
  UserModel? _currentUser;

  @override
  Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    // Simulación de delay de red
    await Future.delayed(const Duration(milliseconds: 1200));

    if (email.trim().isEmpty || password.trim().isEmpty) {
      throw Exception('Por favor ingrese correo y contraseña.');
    }

    _currentUser = await _userRepository.login(email, password);
    return _currentUser;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = null;
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    return _currentUser ?? await _userRepository.getCurrentUser();
  }
}