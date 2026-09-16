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
  final TextEditingController cargoController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late RolUsuarioModel selectedRole;
  String? selectedCompanyId;
  String? selectedCareerId;
  List<EmpresaModel> companies = [];
  List<CarreraModel> careers = [];

  UsuarioDetailController({
    required this.repository,
    required UsuarioModel initialUser,
  }) {
    user = initialUser;
    selectedRole = user.role;
    selectedCompanyId = user.companyId;
    selectedCareerId = user.carreraId;
    _initControllers();
    _loadOptions();
  }

  void _initControllers() {
    selectedRole = user.role;
    selectedCompanyId = user.companyId;
    selectedCareerId = user.carreraId;
    nameController.text = user.name;
    emailController.text = user.email;
    phoneController.text = user.phone ?? '';
    cedulaController.text = user.cedula ?? '';
    cargoController.text = user.cargo ?? '';
    passwordController.clear();
  }

  Future<void> _loadOptions() async {
    try {
      companies = await repository.getCompanies();
      careers = await repository.getCareers();
      notifyListeners();
    } catch (_) {
      // Los campos de texto siguen disponibles aunque falle la carga.
    }
  }

  void setRole(RolUsuarioModel role) {
    selectedRole = role;
    if (role != RolUsuarioModel.student &&
      role != RolUsuarioModel.coordinator &&
      role != RolUsuarioModel.academicTutor) {
      selectedCareerId = null;
    }
    if (role != RolUsuarioModel.student &&
        role != RolUsuarioModel.companyTutor) {
      selectedCompanyId = null;
    }
    if (role != RolUsuarioModel.companyTutor) {
      cargoController.clear();
    }
    notifyListeners();
  }

  void setCompany(String? companyId) {
    selectedCompanyId = companyId;
    notifyListeners();
  }

  void setCareer(String? careerId) {
    selectedCareerId = careerId;
    notifyListeners();
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
      final nextStatus = !user.isActive;
      final success = await repository.setUserActive(user.id, nextStatus);

      if (success) {
        user = user.copyWith(isActive: nextStatus);
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
    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty) {
      errorMessage = 'El nombre y el correo son obligatorios.';
      notifyListeners();
      return false;
    }
    final emailError = AdminValidators.email(emailController.text);
    if (emailError != null) {
      errorMessage = emailError;
      notifyListeners();
      return false;
    }
    final phoneError = AdminValidators.ecuadorianPhone(
      phoneController.text,
      required: false,
    );
    if (phoneError != null) {
      errorMessage = phoneError;
      notifyListeners();
      return false;
    }
    if (passwordController.text.isNotEmpty &&
        passwordController.text.length < 8) {
      errorMessage = 'La nueva contraseña debe tener al menos 8 caracteres.';
      notifyListeners();
      return false;
    }
    final cedula = cedulaController.text.trim();
    final cedulaError = cedula.isEmpty
        ? null
        : AdminValidators.ecuadorianId(cedula);
    if (cedulaError != null) {
      errorMessage = cedulaError;
      notifyListeners();
      return false;
    }

    isLoading = true;
    clearMessages();

    try {
      final updatedUser = user.copyWith(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim().isEmpty
            ? null
            : phoneController.text.trim(),
        cedula: cedulaController.text.trim().isEmpty
            ? null
            : cedulaController.text.trim(),
        role: selectedRole,
        cargo: cargoController.text.trim().isEmpty
            ? null
            : cargoController.text.trim(),
        companyId: selectedCompanyId,
        carreraId: selectedCareerId,
        password: passwordController.text.trim().isEmpty
            ? null
            : passwordController.text.trim(),
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
      if (success) {
        user = user.copyWith(isActive: false);
        successMessage = 'Usuario desactivado correctamente';
      }
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
    cargoController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
