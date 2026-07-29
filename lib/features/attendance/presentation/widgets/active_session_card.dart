import 'package:bitacoras_app/features/attendance/domain/models/practice_record_model.dart';
import 'package:flutter/material.dart';

class ActiveSessionCard extends StatelessWidget {
  final PracticeRecordModel record;
  final VoidCallback onExitPressed;

  const ActiveSessionCard({
    super.key,
    required this.record,
    required this.onExitPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFDE7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFBC02D), width: 1.5),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_today_rounded, color: Color(0xFFF57F17), size: 18),
                  const SizedBox(width: 8),
                  Text(
                    record.date,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF176),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.sync, size: 14, color: Color(0xFFF57F17)),
                    const SizedBox(width: 4),
                    Text(
                      record.status,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF57F17),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Entrada', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  Text(
                    record.entryTime,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Salida', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  Text(
                    record.exitTime ?? 'Esperando marcación...',
                    style: TextStyle(
                      fontStyle: record.exitTime == null ? FontStyle.italic : FontStyle.normal,
                      color: record.exitTime == null ? Colors.grey : Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF003366),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: onExitPressed,
              icon: const Icon(Icons.location_on_outlined, color: Colors.white, size: 18),
              label: const Text(
                'Marcar Salida',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          )
        ],
      ),
    );
  }
}