import 'package:bitacoras_app/features/inicio/domain/models/usuario_model.dart';


abstract class IUsuarioRepository {
  Future<UsuarioModel?> login(String email, String password);
  Future<UsuarioModel> getCurrentUser();
}