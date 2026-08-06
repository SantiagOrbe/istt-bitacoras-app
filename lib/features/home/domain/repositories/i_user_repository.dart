import 'package:bitacoras_app/features/home/domain/models/user_model.dart';


abstract class IUserRepository {
  Future<UserModel?> login(String email, String password);
  Future<UserModel> getCurrentUser();
}