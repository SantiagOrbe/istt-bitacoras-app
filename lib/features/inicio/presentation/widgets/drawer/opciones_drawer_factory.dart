import 'package:bitacoras_app/app/apps.dart';
import 'package:bitacoras_app/features/coordinador/data/coordinador_drawer_items.dart';
import 'package:bitacoras_app/features/responsable_practicas/data/responsable_practicas_drawer_options.dart';

class OpcionesDrawerFactory {
  static List<SeccionMenuModel> getSectionsForRole(RolUsuarioModel role) {
    switch (role) {
      case RolUsuarioModel.admin:
        return getAdminDrawerSections();
      case RolUsuarioModel.student:
        return getOpcionesDrawerEstudiante();
      case RolUsuarioModel.academicTutor:
        return getOpcionesDrawerTutorAcademico();
      case RolUsuarioModel.companyTutor:
        return getOpcionesDrawerTutorEmpresarial();
      case RolUsuarioModel.coordinator:
        return getCoordinatorDrawerSections();
      case RolUsuarioModel.practiceManager:
        return getResponsablePracticasDrawerSections();
      default:
        return [];
    }
  }
}
