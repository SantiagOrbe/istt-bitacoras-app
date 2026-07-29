import 'package:flutter/material.dart';
import 'package:bitacoras_app/features/home/presentation/widgets/home_app_bar.dart';
import 'package:bitacoras_app/features/home/data/repositories/fake_user_repository.dart';
import '../widgets/pdf_generator_card.dart';
import '../widgets/practice_progress_card.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: HomeAppBar(user: FakeUserRepository.student),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Reportes', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF003366))),
            const SizedBox(height: 4),
            Text('Tus reportes listos para descargar', style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
            const SizedBox(height: 20),

            // Card de Progreso de Horas
            const PracticeProgressCard(
              period: '2023 - 2024 I',
              completedHours: 120,
              totalHours: 240,
            ),
            const SizedBox(height: 16),

            // Card Generador de PDF
            PdfGeneratorCard(
              onGeneratePressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Generando archivo PDF de bitácora...'),
                    backgroundColor: Color(0xFF003366),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // Vista previa simulada del documento
            const Text('Vista Previa del Formato', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black)),
            const SizedBox(height: 8),
            Container(
              height: 180,
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.find_in_page_outlined, size: 40, color: Color(0xFF003366)),
                  const SizedBox(height: 8),
                  const Text('BITÁCORA DEL ESTUDIANTE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF003366))),
                  Text('FORMACIÓN PRÁCTICA EN EL ENTORNO LABORAL REAL', style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}