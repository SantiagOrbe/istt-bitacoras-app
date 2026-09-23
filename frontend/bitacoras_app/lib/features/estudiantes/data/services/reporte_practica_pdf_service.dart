import 'dart:io';
import 'dart:typed_data';

import 'package:bitacoras_app/features/estudiantes/domain/models/registro_asistencia_model.dart';
import 'package:bitacoras_app/features/inicio/domain/models/usuario_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

class ReportePracticaPdfService {
  static Future<Uint8List> generate({
    required UsuarioModel user,
    required List<RegistroAsistenciaModel> history,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(28),
        build: (pw.Context context) {
          final rows = history.isEmpty
              ? [
                  [
                    'Sin registros',
                    '',
                    '',
                    '',
                    'No se registraron entradas ni salidas para este periodo.',
                    '',
                  ]
                ]
              : history.asMap().entries.map((entry) {
                  final index = entry.key;
                  final record = entry.value;
                  final actividad = record.activities.isEmpty
                      ? 'Sin actividades registradas'
                      : record.activities
                          .map((item) => item['descripcion'] ?? item['detalle'] ?? item['activity'])
                          .whereType<String>()
                          .join(' • ');

                  return [
                    '${index + 1}',
                    record.date,
                    record.entryTimeLabel,
                    record.exitTimeLabel,
                    actividad,
                    '',
                  ];
                }).toList();

          return [
            _buildHeader(),
            pw.SizedBox(height: 18),
            pw.Text(
              'BITÁCORA DEL ESTUDIANTE',
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                fontSize: 21,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.black,
              ),
            ),
            pw.Text(
              'FORMACIÓN PRÁCTICA EN EL ENTORNO LABORAL REAL',
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.black,
              ),
            ),
            pw.SizedBox(height: 18),
            _buildSectionTitle('DATOS DEL ESTUDIANTE'),
            _buildKeyValueTable(
              rows: [
                ['Apellidos y Nombres:', user.name],
                ['Carrera:', user.careerName ?? 'Sin carrera'],
                ['Periodo:', user.semestreNombre ?? user.periodName ?? 'Sin periodo'],
              ],
            ),
            pw.SizedBox(height: 12),
            _buildSectionTitle('DATOS DE LA EMPRESA'),
            _buildKeyValueTable(
              rows: [
                ['Institución/Empresa:', user.company ?? 'Sin empresa asignada'],
                ['Dirección:', 'Sin dirección registrada'],
                ['Cantón:', 'Sin cantón registrado'],
                ['Teléfono:', user.phone ?? 'Sin teléfono registrado'],
              ],
            ),
            pw.SizedBox(height: 12),
            _buildSectionTitle('DATOS ADICIONALES'),
            _buildKeyValueTable(
              rows: [
                ['Nombre del tutor académico:', user.tutorAcademico ?? 'Sin tutor académico'],
                ['Nombre del tutor empresarial:', user.tutorEmpresarial ?? 'Sin tutor empresarial'],
                ['Fecha Inicio (d/m/a):', 'Sin fecha de inicio'],
                ['Fecha Fin (d/m/a):', 'Sin fecha de fin'],
              ],
            ),
            pw.SizedBox(height: 18),
            _buildTable(
              header: ['#', 'Fecha', 'Hora Ingreso', 'Hora Salida', 'Actividad Realizada', 'Firma del Estudiante'],
              rows: rows,
            ),
            pw.SizedBox(height: 30),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Text(
                      'Nombres y Apellidos',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    pw.SizedBox(height: 24),
                    pw.Container(
                      height: 1,
                      width: 160,
                      color: PdfColors.black,
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text('Tutor Empresarial', style: pw.TextStyle(fontSize: 12)),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Text(
                      'C.C: ${user.cedula ?? 'Sin cédula'}',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    pw.SizedBox(height: 24),
                    pw.Container(
                      height: 1,
                      width: 160,
                      color: PdfColors.black,
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text('Responsable de prácticas', style: pw.TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 24),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Punto de Atención al Usuario: km 1 1/2 vía Tena – Archidona',
                      style: pw.TextStyle(fontSize: 9),
                    ),
                    pw.Text('Telefono: 062311709', style: pw.TextStyle(fontSize: 9)),
                    pw.Text('secretaria.general@isttena.edu.ec', style: pw.TextStyle(fontSize: 9)),
                    pw.Text('https://www.isttena.edu.ec', style: pw.TextStyle(fontSize: 9)),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Text(
                      'EL NUEVO',
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColor.fromInt(0xFF1B3C9D),
                      ),
                    ),
                    pw.Text(
                      'ECUADOR',
                      style: pw.TextStyle(
                        fontSize: 26,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColor.fromInt(0xFFEC1C24),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

  static Future<String> saveToFile({
    required UsuarioModel user,
    required List<RegistroAsistenciaModel> history,
  }) async {
    final bytes = await generate(user: user, history: history);

    Directory baseDirectory;

    if (Platform.isAndroid) {
      final androidDownloads = Directory('/storage/emulated/0/Download');
      if (await androidDownloads.exists()) {
        baseDirectory = androidDownloads;
      } else {
        try {
          final downloadsDirectory = await getDownloadsDirectory();
          baseDirectory = downloadsDirectory ?? await getApplicationDocumentsDirectory();
        } catch (_) {
          baseDirectory = await getApplicationDocumentsDirectory();
        }
      }
    } else {
      try {
        final downloadsDirectory = await getDownloadsDirectory();
        baseDirectory = downloadsDirectory ?? await getApplicationDocumentsDirectory();
      } catch (_) {
        try {
          baseDirectory = await getApplicationDocumentsDirectory();
        } catch (_) {
          baseDirectory = Directory.systemTemp;
        }
      }
    }

    if (!await baseDirectory.exists()) {
      await baseDirectory.create(recursive: true);
    }

    final sanitizedName = user.name
        .replaceAll(RegExp(r'[^A-Za-z0-9\u00C0-\u024F\u1E00-\u1EFF]+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File('${baseDirectory.path}/bitacora_${sanitizedName}_$timestamp.pdf');
    await file.writeAsBytes(bytes);
    return file.path;
  }

  static pw.Widget _buildHeader() {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 6),
      decoration: pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(width: 1.2, color: PdfColors.black)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('REPÚBLICA', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.Text('DEL ECUADOR', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text(
                'INSTITUTO SUPERIOR',
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(
                'TECNOLÓGICO TENA',
                style: pw.TextStyle(fontSize: 17, fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(
                'Tecnología, Innovación y Desarrollo',
                style: pw.TextStyle(fontSize: 8),
              ),
            ],
          ),
          pw.Text(
            'Ministerio de Educación,\nDeporte y Cultura',
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildSectionTitle(String title) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 6),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey300,
      ),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: 12,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.black,
        ),
      ),
    );
  }

  static pw.Widget _buildKeyValueTable({required List<List<String>> rows}) {
    final children = rows.map((row) {
      final label = row[0];
      final value = row[1];
      return pw.TableRow(
        children: [
          pw.Container(
            padding: const pw.EdgeInsets.all(6),
            child: pw.Text(label, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
          ),
          pw.Container(
            padding: const pw.EdgeInsets.all(6),
            child: pw.Text(value, style: pw.TextStyle(fontSize: 10)),
          ),
        ],
      );
    }).toList();

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey700),
      columnWidths: const {
        0: pw.FixedColumnWidth(210),
        1: pw.FixedColumnWidth(270),
      },
      children: children,
    );
  }

  static pw.Widget _buildTable({
    required List<String> header,
    required List<List<String>> rows,
  }) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey700),
      columnWidths: const {
        0: pw.FixedColumnWidth(32),
        1: pw.FixedColumnWidth(60),
        2: pw.FixedColumnWidth(68),
        3: pw.FixedColumnWidth(68),
        4: pw.FixedColumnWidth(195),
        5: pw.FixedColumnWidth(85),
      },
      children: [
        pw.TableRow(
          decoration: pw.BoxDecoration(color: PdfColors.grey300),
          children: header
              .map(
                (value) => pw.Container(
                      padding: const pw.EdgeInsets.all(6),
                      child: pw.Text(
                        value,
                        style: pw.TextStyle(
                          fontSize: 9,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.black,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
              )
              .toList(),
        ),
        ...rows.map(
          (row) => pw.TableRow(
            children: row
                .map(
                  (value) => pw.Container(
                        padding: const pw.EdgeInsets.all(6),
                        child: pw.Text(
                          value,
                          style: pw.TextStyle(fontSize: 8),
                          maxLines: 5,
                          textAlign: pw.TextAlign.left,
                        ),
                      ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
