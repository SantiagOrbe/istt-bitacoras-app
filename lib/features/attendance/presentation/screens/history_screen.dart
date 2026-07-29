import 'package:bitacoras_app/features/attendance/domain/models/practice_record_model.dart';
import 'package:flutter/material.dart';
import 'package:bitacoras_app/features/home/presentation/widgets/home_app_bar.dart';
import 'package:bitacoras_app/features/home/data/repositories/fake_user_repository.dart';
import '../widgets/active_session_card.dart';
import '../widgets/history_card.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  // Datos Mock simulando respuesta de API
  List<PracticeRecordModel> _getMockHistory() {
    return [
      PracticeRecordModel(
        id: '1',
        date: '22 / 06 / 2026',
        entryTime: '08:00 AM',
        exitTime: '17:00 PM',
        status: 'Completado',
      ),
      PracticeRecordModel(
        id: '2',
        date: '13 / 06 / 2026',
        entryTime: '07:55 AM',
        exitTime: '17:05 PM',
        status: 'Completado',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final activeRecord = PracticeRecordModel(
      id: '3',
      date: 'Hoy',
      entryTime: '08:02 AM',
      status: 'En curso',
    );

    final historyList = _getMockHistory();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: HomeAppBar(user: FakeUserRepository.student),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: const Color(0xFFFFF3E0), borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.history, color: Color(0xFFE65100)),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Historial', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF003366))),
                    Text('Tus registros de asistencia recientes', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Registro Activo Si Existe
            ActiveSessionCard(
              record: activeRecord,
              onExitPressed: () {
                // Ir a registrar salida
              },
            ),
            const SizedBox(height: 16),

            // Historial Completado
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: historyList.length,
              itemBuilder: (context, index) {
                return HistoryCard(
                  record: historyList[index],
                  onDetailPressed: () {},
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}