import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../config/constants/app_colors.dart';
import '../../../domain/models/asignacion_estudiante_model.dart';
import '../../controllers/asignacion_estudiante_controller.dart';
import 'asignacion_estudiante_dropdowns.dart';

class FormularioAsignacionEstudianteBody extends StatefulWidget {
  final AsignacionEstudianteModel assignment;
  final AsignacionEstudianteController controller;

  const FormularioAsignacionEstudianteBody({
    super.key,
    required this.assignment,
    required this.controller,
  });

  @override
  State<FormularioAsignacionEstudianteBody> createState() => _FormularioAsignacionEstudianteBodyState();
}

class _FormularioAsignacionEstudianteBodyState extends State<FormularioAsignacionEstudianteBody> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedAcademicTutorId;
  String? _selectedCompanyId;
  String? _selectedCompanyTutorId;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _selectedAcademicTutorId = widget.assignment.academicTutorId;
    _selectedCompanyId = widget.assignment.companyId;
    _selectedCompanyTutorId = widget.assignment.companyTutorId;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final success = await widget.controller.assignStudent(
      assignmentId: widget.assignment.id,
      academicTutorId: _selectedAcademicTutorId!,
      companyTutorId: _selectedCompanyTutorId!,
      companyId: _selectedCompanyId!,
    );

    if (mounted) {
      setState(() => _isSaving = false);
      if (success) context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.assignment.isAssigned;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            elevation: 0,
            color: AppColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: AppColors.outline),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isEditing ? 'Reasignar Tutores' : 'Asignar Tutores',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 4),
                  Text('Estudiante: ${widget.assignment.studentName}', style: const TextStyle(color: AppColors.textSecondary)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          AsignacionEstudianteDropdowns(
            academicTutorId: _selectedAcademicTutorId,
            companyId: _selectedCompanyId,
            companyTutorId: _selectedCompanyTutorId,
            onAcademicTutorChanged: (v) => setState(() => _selectedAcademicTutorId = v),
            onCompanyChanged: (v) => setState(() => _selectedCompanyId = v),
            onCompanyTutorChanged: (v) => setState(() => _selectedCompanyTutorId = v),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _isSaving ? null : _submit,
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 14)),
            child: _isSaving
                ? const CircularProgressIndicator(color: AppColors.surface)
                : Text(isEditing ? 'Guardar Reasignación' : 'Confirmar Asignación', style: const TextStyle(color: AppColors.surface)),
          ),
        ],
      ),
    );
  }
}