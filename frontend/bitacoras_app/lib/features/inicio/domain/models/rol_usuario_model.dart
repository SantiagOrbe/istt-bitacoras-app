/// Roles de usuario disponibles en la aplicación.
enum RolUsuarioModel {
  student,
  academicTutor,
  companyTutor,
  coordinator,
  practiceManager,
  admin,
}

extension RolUsuarioExtension on RolUsuarioModel {
  /// Valor que se envía al backend en formato API.
  String get apiValue {
    switch (this) {
      case RolUsuarioModel.student:
        return 'estudiante';
      case RolUsuarioModel.academicTutor:
        return 'tutor_academico';
      case RolUsuarioModel.companyTutor:
        return 'tutor_empresarial';
      case RolUsuarioModel.coordinator:
        return 'coordinador';
      case RolUsuarioModel.practiceManager:
        return 'responsable_practicas';
      case RolUsuarioModel.admin:
        return 'admin';
    }
  }

  /// Nombre legible para la interfaz.
  String get label {
    switch (this) {
      case RolUsuarioModel.student:
        return 'Estudiante';
      case RolUsuarioModel.academicTutor:
        return 'Tutor Académico';
      case RolUsuarioModel.companyTutor:
        return 'Tutor Empresarial';
      case RolUsuarioModel.coordinator:
        return 'Coordinador';
      case RolUsuarioModel.practiceManager:
        return 'Responsable de Prácticas';
      case RolUsuarioModel.admin:
        return 'Administrador';
    }
  }

  /// Alias en español para mantener una nomenclatura más clara.
  String get nombre => label;

  /// Alias en español para el valor API.
  String get valorApi => apiValue;
}

extension RolUsuarioCompatibilidad on RolUsuarioModel {
  static RolUsuarioModel desdeNombre(String valor) {
    switch (valor.toLowerCase()) {
      case 'student':
      case 'estudiante':
        return RolUsuarioModel.student;
      case 'teacher':
      case 'academicTutor':
      case 'academictutor':
      case 'tutor_academico':
        return RolUsuarioModel.academicTutor;
      case 'companyTutor':
      case 'companytutor':
      case 'tutor_empresarial':
        return RolUsuarioModel.companyTutor;
      case 'coordinator':
      case 'coordinador':
        return RolUsuarioModel.coordinator;
      case 'practiceManager':
      case 'practicemanager':
      case 'responsable_practicas':
        return RolUsuarioModel.practiceManager;
      case 'admin':
      case 'administrador':
        return RolUsuarioModel.admin;
      default:
        return RolUsuarioModel.student;
    }
  }
}

typedef RolUsuario = RolUsuarioModel;
