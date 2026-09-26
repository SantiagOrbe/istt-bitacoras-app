import 'package:bitacoras_app/features/admin/admin.dart';

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

  void _normalizeSelectionValues() {
    final activeCompanyIds = companies.map((company) => company.id).toSet();
    if (selectedCompanyId != null &&
        !activeCompanyIds.contains(selectedCompanyId)) {
      selectedCompanyId = null;
    }

    final activeCareerIds = careers.map((career) => career.id).toSet();
    if (selectedCareerId != null &&
        !activeCareerIds.contains(selectedCareerId)) {
      selectedCareerId = null;
    }
  }

  Future<void> _loadOptions() async {
    try {
      final allCompanies = await repository.obtenerEmpresas();
      final seenCompanyIds = <String>{};
      companies = allCompanies
          .where(
            (company) => company.isActive && seenCompanyIds.add(company.id),
          )
          .toList();

      final allCareers = await repository.obtenerCarreras();
      final seenCareerIds = <String>{};
      careers = allCareers
          .where((career) => career.isActive && seenCareerIds.add(career.id))
          .toList();

      _normalizeSelectionValues();
      notifyListeners();
    } catch (_) {
      // Los campos de texto siguen disponibles aunque falle la carga.
    }
  }

  void setRole(RolUsuarioModel role) {
    selectedRole = role;
    if (role != RolUsuarioModel.student &&
        role != RolUsuarioModel.coordinator &&
        role != RolUsuarioModel.academicTutor &&
        role != RolUsuarioModel.practiceManager) {
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
      final success = await repository.cambiarEstadoUsuario(
        user.id,
        nextStatus,
      );

      if (success) {
        user = user.copyWith(isActive: nextStatus);
        successMessage = user.isActive
            ? 'Usuario activado correctamente'
            : 'Usuario desactivado correctamente';
      } else {
        errorMessage = 'No se pudo cambiar el estado del usuario.';
      }
    } catch (_) {
      errorMessage = 'No se pudo cambiar el estado del usuario.';
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
    final emailError = ValidadoresAdmin.email(emailController.text);
    if (emailError != null) {
      errorMessage = emailError;
      notifyListeners();
      return false;
    }
    final phoneError = ValidadoresAdmin.ecuadorianPhone(
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
        : ValidadoresAdmin.ecuadorianId(cedula);
    if (cedulaError != null) {
      errorMessage = cedulaError;
      notifyListeners();
      return false;
    }

    final duplicateMessage = await _validateUniqueFields(
      phone: phoneController.text.trim(),
      cedula: cedula,
    );
    if (duplicateMessage != null) {
      errorMessage = duplicateMessage;
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

      final success = await repository.actualizarUsuario(updatedUser);

      if (success) {
        user = updatedUser;
        isEditing = false;
        successMessage = 'Información actualizada con éxito';
      } else {
        errorMessage = 'No se pudieron guardar los cambios.';
      }
    } catch (_) {
      errorMessage = 'No se pudieron guardar los cambios. Inténtalo de nuevo.';
    } finally {
      isLoading = false;
      notifyListeners();
    }

    return !isEditing;
  }

  Future<String?> _validateUniqueFields({
    required String phone,
    required String cedula,
  }) async {
    try {
      final users = await repository.obtenerUsuarios();
      final normalizedPhone = phone.trim();
      final normalizedCedula = cedula.trim();

      if (normalizedPhone.isNotEmpty &&
          users.any(
            (usuario) =>
                usuario.id != user.id &&
                (usuario.phone ?? '').trim() == normalizedPhone,
          )) {
        return 'El número de teléfono ya está registrado por otro usuario.';
      }

      if (normalizedCedula.isNotEmpty &&
          users.any(
            (usuario) =>
                usuario.id != user.id &&
                (usuario.cedula ?? '').trim() == normalizedCedula,
          )) {
        return 'La cédula ya está registrada por otro usuario.';
      }
    } catch (_) {
      return 'No se pudo verificar si los datos ya existen. Revisa el formulario e inténtalo nuevamente.';
    }

    return null;
  }

  Future<bool> deleteUser() async {
    isLoading = true;
    clearMessages();

    try {
      final success = await repository.eliminarUsuario(user.id);
      if (success) {
        user = user.copyWith(isActive: false);
        successMessage = 'Usuario desactivado correctamente';
      }
      isLoading = false;
      notifyListeners();
      return success;
    } catch (_) {
      isLoading = false;
      errorMessage = 'No se pudo eliminar el usuario. Inténtalo de nuevo.';
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
