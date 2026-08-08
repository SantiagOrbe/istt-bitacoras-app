import 'package:flutter/material.dart';
import '../../../../config/constants/app_colors.dart';

class CompanyFormFields extends StatelessWidget {
  final Map<String, TextEditingController> controllers;

  const CompanyFormFields({super.key, required this.controllers});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.outline),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _input(controllers['name']!, 'Razón Social', Icons.business_rounded),
            const SizedBox(height: 12),
            _input(controllers['ruc']!, 'RUC', Icons.badge_outlined, isNum: true),
            const SizedBox(height: 12),
            _input(controllers['agreement']!, 'Número de Convenio', Icons.assignment_outlined),
            const SizedBox(height: 12),
            _input(controllers['rep']!, 'Representante Legal', Icons.person_outline_rounded),
            const SizedBox(height: 12),
            _input(controllers['address']!, 'Dirección', Icons.location_on_outlined),
            const SizedBox(height: 12),
            _input(controllers['phone']!, 'Teléfono', Icons.phone_outlined, isNum: true),
            const SizedBox(height: 12),
            _input(controllers['email']!, 'Correo', Icons.email_outlined),
          ],
        ),
      ),
    );
  }

  Widget _input(TextEditingController ctrl, String label, IconData icon, {bool isNum = false}) {
    return TextFormField(
      controller: ctrl,
      keyboardType: isNum ? TextInputType.number : TextInputType.text,
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
      validator: (v) => v == null || v.trim().isEmpty ? 'Campo requerido' : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
        filled: true,
        fillColor: AppColors.background,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}