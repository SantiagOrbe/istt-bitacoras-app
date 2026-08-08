import 'package:bitacoras_app/app/apps.dart';
import 'package:bitacoras_app/features/coordinador/data/coordinador_drawer_items.dart';
import 'package:bitacoras_app/features/responsable_practicas/data/responsable_practicas_drawer_options.dart';


class DrawerOptionsFactory {
  static List<DrawerSectionModel> getSectionsForRole(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return getAdminDrawerSections();
      case UserRole.student:
        return getStudentDrawerSections();
      case UserRole.academicTutor:
        return getAcademicTutorDrawerSections();
      case UserRole.companyTutor:
        return getCompanyTutorDrawerSections();
      case UserRole.coordinator:
        return getCoordinatorDrawerSections();
      case UserRole.practiceManager:
        return getResponsablePracticasDrawerSections();
      default:
        return [];
    }
  }
}