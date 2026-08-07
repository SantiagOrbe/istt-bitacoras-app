import 'package:bitacoras_app/app/apps.dart';
import 'package:bitacoras_app/features/admin/data/repositories/fake_admin_repository.dart';
import 'package:bitacoras_app/features/admin/domain/models/drawer_item_model.dart';
import 'package:bitacoras_app/features/students/data/repositories/student_drawer_options.dart';


class DrawerOptionsFactory {
  static List<DrawerSectionModel> getSectionsForRole(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return getAdminDrawerSections();
      case UserRole.student:
        return getStudentDrawerSections();
      
      // Por ahora para otros roles retorna una lista vacía o las secciones por defecto
      case UserRole.student:
      case UserRole.teacher:
      case UserRole.academicTutor:
      case UserRole.companyTutor:
      case UserRole.coordinator:
      case UserRole.practiceManager:
      default:
        return [];
    }
  }
}