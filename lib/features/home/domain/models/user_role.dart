enum UserRole {
  student,
  teacher,
  academicTutor,
  companyTutor,
  coordinator,
  practiceManager,
  admin,
}

extension UserRoleExtension on UserRole {
  String get label {
    switch (this) {
      case UserRole.student:
        return "Estudiante";

      case UserRole.teacher:
        return "Docente";

      case UserRole.academicTutor:
        return "Tutor Académico";

      case UserRole.companyTutor:
        return "Tutor Empresarial";

      case UserRole.coordinator:
        return "Coordinador";

      case UserRole.practiceManager:
        return "Responsable de Prácticas";

      case UserRole.admin:
        return "Administrador";
    }
  }
}