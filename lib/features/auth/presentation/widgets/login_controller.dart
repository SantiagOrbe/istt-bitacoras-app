import 'package:flutter/material.dart';
import '../../../home/data/repositories/fake_user_repository.dart';
import '../../../home/models/user_role.dart';

// Imports de tus pantallas de destino (Homes)
import '../../../home/presentation/pages/student_home.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../home/presentation/pages/teacher_home.dart';
import '../../../home/presentation/pages/academic_tutor_home.dart';
import '../../../home/presentation/pages/company_tutor_home.dart';
import '../../../home/presentation/pages/coordinator_home.dart';
import '../../../home/presentation/pages/practice_manager_home.dart';
import '../../../home/presentation/pages/admin_home.dart';

class LoginController {
  final BuildContext context;
  final TextEditingController userController;
  final TextEditingController passwordController;
  final Function(bool) onLoadingChanged;

  LoginController({
    required this.context,
    required this.userController,
    required this.passwordController,
    required this.onLoadingChanged,
  });

  Future<void> login() async {
    final email = userController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar('Por favor, completa todos los campos.', Colors.orange);
      return;
    }

    onLoadingChanged(true);

    // Consumimos el mock de datos
    final user = await FakeUserRepository.login(email, password);

    onLoadingChanged(false);

    if (user != null) {
      _showSnackBar('¡Bienvenido, ${user.fullName}!', Colors.green);
      _redirectByRole(user.role);
    } else {
      _showSnackBar('Correo no registrado o credenciales incorrectas.', Colors.red);
    }
  }

  void _showSnackBar(String message, Color backgroundColor) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }

  void _redirectByRole(UserRole role) {
    if (!context.mounted) return;

    Widget targetHome;
    switch (role) {
      case UserRole.student:
        targetHome = const StudentHome();
        break;
      case UserRole.teacher:
        targetHome = const TeacherHome();
        break;
      case UserRole.academicTutor:
        targetHome = const AcademicTutorHome();
        break;
      case UserRole.companyTutor:
        targetHome = const CompanyTutorHome();
        break;
      case UserRole.coordinator:
        targetHome = const CoordinatorHome();
        break;
      case UserRole.practiceManager:
        targetHome = const PracticeManagerHome();
        break;
      case UserRole.admin:
        targetHome = const AdminHome();
        break;
    }

    // Use GoRouter to navigate to student home so routing is consistent
    if (role == UserRole.student) {
      context.go(AppRoutes.studentHome);
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => targetHome),
    );
  }
}