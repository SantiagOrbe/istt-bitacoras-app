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