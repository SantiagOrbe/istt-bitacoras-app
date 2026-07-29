import 'package:flutter/material.dart';

void showGpsErrorDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icono de Ubicación Deshabilitada / Error
            CircleAvatar(
              radius: 36,
              backgroundColor: Colors.red.shade50,
              child: Icon(Icons.location_off_rounded, color: Colors.red.shade700, size: 36),
            ),
            const SizedBox(height: 16),
            const Text(
              '¡UPS! Ubicación no válida',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFC0392B)),
            ),
            const SizedBox(height: 8),
            const Text(
              'Su ubicación actual no está dentro del rango permitido para la Empresa asignada.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54, fontSize: 13),
            ),
            const SizedBox(height: 16),

            // Badge de Distancia
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.social_distance, size: 16, color: Colors.red.shade700),
                  const SizedBox(width: 6),
                  Text(
                    'Distancia: 1.2km',
                    style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Botones Intentar de Nuevo y Cancelar
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF003366),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                ),
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.refresh, color: Colors.white, size: 18),
                label: const Text('Intentar de Nuevo', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                  side: const BorderSide(color: Color(0xFF003366)),
                ),
                onPressed: () {
                  Navigator.pop(context); // Cierra modal
                  Navigator.pop(context); // Regresa a pantalla anterior
                },
                child: const Text('Cancelar', style: TextStyle(color: Color(0xFF003366), fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}