import '../models/quick_action.dart';
import '../models/user_role.dart';

abstract class IDashboardRepository {
  Future<List<QuickAction>> getActionsForRole(UserRole role);
  
  // Métodos específicos por rol expuestos
  List<QuickAction> studentActions();
  List<QuickAction> teacherActions();
  List<QuickAction> academicTutorActions();
  List<QuickAction> companyTutorActions();
  List<QuickAction> coordinatorActions();
  List<QuickAction> practiceManagerActions();
  List<QuickAction> adminActions();
}