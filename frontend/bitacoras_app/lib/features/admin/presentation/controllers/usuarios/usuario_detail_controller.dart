import 'package:bitacoras_app/app/apps.dart';


class UsuarioDetailController extends ChangeNotifier {
  final IAdminRepository repository;
  
  late UsuarioModel user;
  bool isEditing = false;
  bool isLoading = false;
  String? errorMessage;
  String? successMessage;

  // Controladores para el modo edición
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController cedulaController = TextEditingController();
  final TextEditingController companyController = TextEditingController();

  UsuarioDetailController({
    required this.repository,
    required UsuarioModel initialUser,
  }) {
    user = initialUser;
    _initControllers();
  }

  void _initControllers() {
    nameController.text = user.name;
    emailController.text = user.email;
    phoneController.text = user.phone ?? '';
    cedulaController.text = user.cedula ?? '';
    companyController.text = user.company ?? '';
  }

  void toggleEditMode() {
    isEditing = !isEditing;
    if (!isEditing) {
      _initControllers(); // Restablece los campos si cancela la edición
    }
    notifyListeners();
  }

  void clearMessages() {
    errorMessage = null;
    successMessage = null;
    notifyListeners();
  }

  Future<bool> toggleUserStatus() async {
    isLoading = true;
    clearMessages();

    try {
      final updatedUser = user.copyWith(isActive: !user.isActive);
      final success = await repository.updateUser(updatedUser);

      if (success) {
        user = updatedUser;
        successMessage = user.isActive 
            ? 'Usuario activado correctamente' 
            : 'Usuario desactivado correctamente';
      } else {
        errorMessage = 'No se pudo cambiar el estado del usuario.';
      }
    } catch (e) {
      errorMessage = 'Error al cambiar estado: ${e.toString()}';
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return user.isActive;
  }

  Future<bool> saveChanges() async {
    if (nameController.text.trim().isEmpty || emailController.text.trim().isEmpty) {
      errorMessage = 'El nombre y el correo son obligatorios.';
      notifyListeners();
      return false;
    }

    isLoading = true;
    clearMessages();

    try {
      final updatedUser = user.copyWith(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim().isEmpty ? null : phoneController.text.trim(),
        cedula: cedulaController.text.trim().isEmpty ? null : cedulaController.text.trim(),
        company: companyController.text.trim().isEmpty ? null : companyController.text.trim(),
      );

      final success = await repository.updateUser(updatedUser);

      if (success) {
        user = updatedUser;
        isEditing = false;
        successMessage = 'Información actualizada con éxito';
      } else {
        errorMessage = 'No se pudieron guardar los cambios.';
      }
    } catch (e) {
      errorMessage = 'Error al guardar: ${e.toString()}';
    } finally {
      isLoading = false;
      notifyListeners();
    }

    return !isEditing;
  }

  Future<bool> deleteUser() async {
    isLoading = true;
    clearMessages();

    try {
      final success = await repository.deleteUser(user.id);
      isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      isLoading = false;
      errorMessage = 'Error al eliminar usuario: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    cedulaController.dispose();
    companyController.dispose();
    super.dispose();
  }
}