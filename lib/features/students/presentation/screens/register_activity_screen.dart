import 'package:bitacoras_app/features/students/attendance.dart';
import 'package:flutter/material.dart';
import 'package:bitacoras_app/shared/exports.dart';
import '../../domain/repositories/i_attendance_repository.dart';
import '../controllers/register_activity_controller.dart';
import '../widgets/register_activity_action_buttons.dart';
import '../widgets/register_activity_header.dart';
import '../widgets/register_activity_list.dart';

class RegisterActivityScreen extends StatefulWidget {
  final UserModel currentUser;
  final IAttendanceRepository attendanceRepository;

  const RegisterActivityScreen({
    super.key,
    required this.currentUser,
    required this.attendanceRepository,
  });

  @override
  State<RegisterActivityScreen> createState() => _RegisterActivityScreenState();
}

class _RegisterActivityScreenState extends State<RegisterActivityScreen> {
  late final RegisterActivityController _controller;

  @override
  void initState() {
    super.initState();
    _controller = RegisterActivityController(repository: widget.attendanceRepository);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final success = await _controller.saveActivities();

    if (!mounted) return;

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Por favor, ingrese al menos una actividad.',
            style: AppTextStyles.body.copyWith(color: AppColors.surface),
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '¡Actividades guardadas con éxito!',
          style: AppTextStyles.body.copyWith(color: AppColors.surface),
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: HomeAppBar(user: widget.currentUser),
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(AppSizes.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const RegisterActivityHeader(),
                  AppSizes.gapV24,
                  RegisterActivityList(
                    controllers: _controller.controllers,
                    onRemove: _controller.removeActivityField,
                  ),
                  AppSizes.gapV16,
                  RegisterActivityActionButtons(
                    isLoading: _controller.isLoading,
                    onSave: _handleSave,
                    onAddMore: _controller.addActivityField,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}