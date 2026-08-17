import '../models/accion_rapida_model.dart';
import '../models/rol_usuario_model.dart';

abstract class ITableroRepository {
  Future<List<AccionRapidaModel>> getActionsForRole(RolUsuarioModel role);
  
  // Métodos específicos por rol expuestos
  List<AccionRapidaModel> studentActions();
  List<AccionRapidaModel> teacherActions();
  List<AccionRapidaModel> academicTutorActions();
  List<AccionRapidaModel> companyTutorActions();
  List<AccionRapidaModel> coordinatorActions();
  List<AccionRapidaModel> practiceManagerActions();
  List<AccionRapidaModel> adminActions();
}