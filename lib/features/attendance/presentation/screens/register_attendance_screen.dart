import 'package:bitacoras_app/features/attendance/presentation/screens/register_activity_screen.dart';
import 'package:flutter/material.dart';
import 'package:bitacoras_app/features/home/presentation/widgets/home_app_bar.dart';
import 'package:bitacoras_app/features/home/data/repositories/fake_user_repository.dart';
import '../widgets/attendance_info_tile.dart';
import '../widgets/company_card.dart';
import '../widgets/location_status_card.dart';
import '../widgets/map_preview.dart';

class RegisterAttendanceScreen extends StatelessWidget {
  final bool isEntry; // true: Entrada, false: Salida

  const RegisterAttendanceScreen({
    super.key,
    this.isEntry = true,
  });

  void _onConfirmAttendance(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isEntry ? '¡Entrada registrada con éxito!' : '¡Salida registrada con éxito!',
        ),
        backgroundColor: const Color(0xFF2E7D32),
        duration: const Duration(seconds: 2),
      ),
    );

    if (isEntry) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RegisterActivityScreen()),
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = isEntry ? 'Registrar Entrada' : 'Registrar Salida';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: HomeAppBar(user: FakeUserRepository.student),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF003366),
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: AttendanceInfoTile(
                    icon: Icons.access_time_rounded,
                    label: isEntry ? '08:00 AM' : '17:00 PM',
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: AttendanceInfoTile(
                    icon: Icons.calendar_today_rounded,
                    label: '24/10/2024',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            const MapPreview(),
            const SizedBox(height: 16),

            const LocationStatusCard(),
            const SizedBox(height: 16),

            const CompanyCard(companyName: 'GAD Municipal de Tena'),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF003366),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onPressed: () => _onConfirmAttendance(context),
                icon: Icon(
                  isEntry ? Icons.login_rounded : Icons.logout_rounded,
                  color: Colors.white,
                ),
                label: Text(
                  isEntry ? 'Confirmar Entrada' : 'Confirmar Salida',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  side: const BorderSide(color: Color(0xFF003366)),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Regresar',
                  style: TextStyle(
                    color: Color(0xFF003366),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}