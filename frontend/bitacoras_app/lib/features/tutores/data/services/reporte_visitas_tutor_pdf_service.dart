import 'package:bitacoras_app/features/tutores/tutores.dart';
import 'package:pdf/widgets.dart' as pw;

class ReporteVisitasTutorPdfService {
  static Future<String> saveToFile({
    required UsuarioModel user,
    required List<Map<String, dynamic>> visits,
  }) async {
    final bytes = await _generate(user: user, visits: visits);
    final directory = await _downloadsDirectory();
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    final safeName = user.name
        .replaceAll(RegExp(r'[^A-Za-z0-9]+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
    final file = File('${directory.path}/reporte_visitas_${safeName}_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(bytes);
    return file.path;
  }

  static Future<Directory> _downloadsDirectory() async {
    if (Platform.isAndroid) {
      final downloads = Directory('/storage/emulated/0/Download');
      if (await downloads.exists()) return downloads;
    }
    return await getDownloadsDirectory() ?? await getApplicationDocumentsDirectory();
  }

  static Future<Uint8List> _generate({
    required UsuarioModel user,
    required List<Map<String, dynamic>> visits,
  }) async {
    final pdf = pw.Document();
    final rows = visits.isEmpty
        ? [
            ['Sin registros', '', '', 'No se registraron visitas.', '', '', ''],
          ]
        : visits.map((visit) {
            return [
              _text(visit['fecha']),
              _text(visit['empresa_nombre'] ?? visit['empresa']),
              _formatTime(visit['hora_entrada']),
              _text(visit['actividades']).isEmpty ? 'Sin actividades' : _text(visit['actividades']),
              'Responsable de la empresa',
              _formatTime(visit['hora_salida']),
              '________________',
            ];
          }).toList();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.fromLTRB(28, 24, 28, 24),
        build: (_) => [
          _header(),
          pw.SizedBox(height: 8),
          pw.Center(child: pw.Text('HOJA DE RUTA INSTITUCIONAL', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13))),
          pw.SizedBox(height: 10),
          _infoTable(
            user: user,
            firstArrival: visits.isEmpty ? '' : _formatTime(visits.first['hora_entrada']),
            lastDeparture: visits.isEmpty ? '' : _formatTime(visits.last['hora_salida']),
          ),
          pw.SizedBox(height: 14),
          _table(
            ['Fecha', 'Lugar/institución de visita', 'Hora de llegada', 'Actividad realizada', 'Nombres y apellidos de quien atiende', 'Hora de salida', 'Firma / Sello'],
            rows,
          ),
          pw.SizedBox(height: 22),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              _signature('Elaborado por', user.name),
              _signature('Validado por', 'Coordinación de carrera'),
              _signature('Autorizado por', 'Talento Humano'),
            ],
          ),
          pw.SizedBox(height: 18),
          pw.Text('Punto de Atención al Usuario: km 1 1/2 vía Tena – Archidona', style: const pw.TextStyle(fontSize: 8)),
          pw.Text('Teléfono: 062311709 | secretaria.general@isttena.edu.ec', style: const pw.TextStyle(fontSize: 8)),
        ],
      ),
    );
    return pdf.save();
  }

  static pw.Widget _header() => pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text('REPÚBLICA\nDEL ECUADOR', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
          pw.Column(children: [
            pw.Text('INSTITUTO SUPERIOR TECNOLÓGICO TENA', style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold)),
            pw.Text('Tecnología, Innovación y Desarrollo', style: const pw.TextStyle(fontSize: 8)),
          ]),
          pw.Text('Ministerio de Educación,\nDeporte y Cultura', textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
        ],
      );

  static pw.Widget _infoTable({
    required UsuarioModel user,
    required String firstArrival,
    required String lastDeparture,
  }) {
    final labelStyle = pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold);
    final valueStyle = pw.TextStyle(fontSize: 8);
    final leftTable = pw.Table(
      border: pw.TableBorder.all(color: PdfColors.black),
      columnWidths: const {
        0: pw.FixedColumnWidth(112),
        1: pw.FixedColumnWidth(322),
      },
      children: [
        pw.TableRow(children: [
          _infoCell('PROFESOR', labelStyle, background: PdfColors.blue100),
          _infoCell(user.name, valueStyle),
        ]),
        pw.TableRow(children: [
          _infoCell('CARRERA/DEPENDENCIA', labelStyle, background: PdfColors.blue100),
          _infoCell(user.careerName ?? 'Sin carrera registrada', valueStyle),
        ]),
        pw.TableRow(children: [
          _infoCell('FECHA DE ELABORACIÓN', labelStyle, background: PdfColors.blue100),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.black),
            columnWidths: const {
              0: pw.FixedColumnWidth(85),
              1: pw.FixedColumnWidth(78),
              2: pw.FixedColumnWidth(50),
              3: pw.FixedColumnWidth(65),
              4: pw.FixedColumnWidth(44),
            },
            children: [
              pw.TableRow(children: [
                _infoCell(_today(), valueStyle),
                _infoCell('HORA DE LLEGADA', labelStyle, background: PdfColors.blue100),
                _infoCell(firstArrival, valueStyle),
                _infoCell('HORA DE SALIDA', labelStyle, background: PdfColors.blue100),
                _infoCell(lastDeparture, valueStyle),
              ]),
            ],
          ),
        ]),
      ],
    );

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.black),
      columnWidths: const {
        0: pw.FixedColumnWidth(434),
        1: pw.FixedColumnWidth(105),
      },
      children: [
        pw.TableRow(children: [
          leftTable,
          pw.Container(
            height: 96,
            padding: const pw.EdgeInsets.all(5),
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'VISTO BUENO DE TALENTO HUMANO',
                  textAlign: pw.TextAlign.center,
                  style: labelStyle,
                ),
                pw.Text(user.name, textAlign: pw.TextAlign.center, style: valueStyle),
              ],
            ),
          ),
        ]),
      ],
    );
  }

  static pw.Widget _infoCell(
    String text,
    pw.TextStyle style, {
    PdfColor? background,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(5),
      color: background,
      child: pw.Text(text, style: style),
    );
  }

  static pw.Widget _table(List<String> headers, List<List<String>> rows) => pw.Table(
        border: pw.TableBorder.all(color: PdfColors.black),
        columnWidths: const {0: pw.FixedColumnWidth(48), 1: pw.FixedColumnWidth(90), 2: pw.FixedColumnWidth(58), 3: pw.FixedColumnWidth(125), 4: pw.FixedColumnWidth(95), 5: pw.FixedColumnWidth(52), 6: pw.FixedColumnWidth(65)},
        children: [
          pw.TableRow(
            decoration: const pw.BoxDecoration(color: PdfColors.blue100),
            children: headers.map((header) {
              return pw.Padding(
                padding: const pw.EdgeInsets.all(5),
                child: pw.Text(header, textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold)),
              );
            }).toList(),
          ),
          ...rows.map((row) {
            return pw.TableRow(
              children: row.map((cell) {
                return pw.Container(
                  height: 58,
                  padding: const pw.EdgeInsets.all(5),
                  child: pw.Text(cell, style: const pw.TextStyle(fontSize: 7)),
                );
              }).toList(),
            );
          }),
        ],
      );

  static pw.Widget _signature(String label, String value) => pw.Container(
        width: 165,
        child: pw.Column(
          children: [
            pw.Container(
              height: 58,
              width: double.infinity,
              decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.black)),
            ),
            pw.Container(
              height: 30,
              width: double.infinity,
              decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.black)),
              alignment: pw.Alignment.center,
              padding: const pw.EdgeInsets.all(3),
              child: pw.Text('$label: $value', textAlign: pw.TextAlign.center, style: const pw.TextStyle(fontSize: 8)),
            ),
          ],
        ),
      );

  static String _text(dynamic value) => value?.toString() ?? '';
  static String _formatTime(dynamic value) => _text(value).isEmpty ? '' : _text(value).substring(0, _text(value).length > 5 ? 5 : _text(value).length);
  static String _today() => DateTime.now().toIso8601String().substring(0, 10);
}
