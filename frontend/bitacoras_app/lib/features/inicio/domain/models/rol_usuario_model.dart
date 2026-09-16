enum RolUsuarioModel {
  student,
  teacher,
  academicTutor,
  companyTutor,
  coordinator,
  practiceManager,
  admin,
}

extension RolUsuarioExtension on RolUsuarioModel {
  String get apiValue {
    switch (this) {
      case RolUsuarioModel.student:
        return 'estudiante';
      case RolUsuarioModel.teacher:
        return 'docente';
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

  String get label {
    switch (this) {
      case RolUsuarioModel.student:
        return "Estudiante";

      case RolUsuarioModel.teacher:
        return "Docente";

      case RolUsuarioModel.academicTutor:
        return "Tutor Académico";

      case RolUsuarioModel.companyTutor:
        return "Tutor Empresarial";

      case RolUsuarioModel.coordinator:
        return "Coordinador";

      case RolUsuarioModel.practiceManager:
        return "Responsable de Prácticas";

      case RolUsuarioModel.admin:
        return "Administrador";
    }
  }
}
