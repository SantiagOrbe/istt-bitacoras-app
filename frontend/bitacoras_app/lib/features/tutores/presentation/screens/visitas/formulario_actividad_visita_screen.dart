import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../app/apps.dart';
import '../../../../../config/constants/app_colors.dart';
import '../../../domain/models/visita_academica_model.dart';

class FormularioActividadVisitaScreen extends StatefulWidget {
  final VisitaAcademicaModel visit;

  const FormularioActividadVisitaScreen({super.key, required this.visit});

  @override
  State<FormularioActividadVisitaScreen> createState() => _FormularioActividadVisitaScreenState();
}

class _FormularioActividadVisitaScreenState extends State<FormularioActividadVisitaScreen> {
  final _activityCtrl = TextEditingController();
  final _observationsCtrl = TextEditingController();
  final _recommendationsCtrl = TextEditingController();

  @override
  void dispose() {
    _activityCtrl.dispose();
    _observationsCtrl.dispose();
    _recommendationsCtrl.dispose();
    super.dispose();
  }

  void _saveVisitReport() {
    if (_activityCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor detalle las actividades realizadas.')),
      );
      return;
    }

    // Aquí se simula el envío del objeto consolidado con actividades, observaciones y recomendaciones
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('¡Visita y observaciones registradas con éxito!'),
        backgroundColor: Color(0xFF7CB342),
      ),
    );

    context.go(AppRoutes.academicTutorHome);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('IST Tena Prácticas'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Detalles de la Visita',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
            const SizedBox(height: 6),
            Text(
              'Estudiante: ${widget.visit.studentName} | Empresa: ${widget.visit.companyName}',
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),

            // Card 1: Actividades Realizadas
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: AppColors.divider.withOpacity(0.5)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Actividades Supervisadas', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _activityCtrl,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Describa las tareas realizadas por el practicante...',
                        hintStyle: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.divider.withOpacity(0.5)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Card 2: Observaciones y Recomendaciones
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: AppColors.divider.withOpacity(0.5)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Observaciones del Tutor', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _observationsCtrl,
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: 'Ingrese observaciones del desempeño o entorno...',
                        hintStyle: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.divider.withOpacity(0.5)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text('Recomendaciones', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _recommendationsCtrl,
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: 'Sugerencias para el estudiante o la empresa...',
                        hintStyle: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.divider.withOpacity(0.5)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Botón Guardar Visita Completa
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.save_rounded, color: Colors.white),
                label: const Text('Guardar Visita y Observaciones', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                onPressed: _saveVisitReport,
              ),
            ),
          ],
        ),
      ),
    );
  }
}