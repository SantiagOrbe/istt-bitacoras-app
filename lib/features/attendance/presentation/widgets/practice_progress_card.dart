import 'package:flutter/material.dart';

class PracticeProgressCard extends StatelessWidget {
  final String period;
  final int completedHours;
  final int totalHours;

  const PracticeProgressCard({
    super.key,
    required this.period,
    required this.completedHours,
    required this.totalHours,
  });

  @override
  Widget build(BuildContext context) {
    double progress = completedHours / totalHours;
    int percentage = (progress * 100).toInt();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Período Académico', style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_today_outlined, size: 18, color: Color(0xFF003366)),
                  const SizedBox(width: 8),
                  Text(period, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF003366))),
                ],
              ),
              const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('HORAS REGISTRADAS', style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: '$completedHours ', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF003366))),
                    TextSpan(text: '/ $totalHours hrs', style: const TextStyle(fontSize: 13, color: Colors.grey)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFFA000)),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.check_circle, size: 16, color: Color(0xFF2E7D32)),
              const SizedBox(width: 6),
              Text(
                'Has completado el $percentage% de tus prácticas.',
                style: const TextStyle(fontSize: 12, color: Colors.black87, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}