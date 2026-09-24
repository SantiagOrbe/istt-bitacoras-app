import 'dart:convert';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:bitacoras_app/features/responsable_practicas/responsable_practicas.dart';


const double kNapoDefaultLatitude = -0.9953013232331654;
const double kNapoDefaultLongitude = -77.81497383331016;

class MapaEmpresaSelector extends StatefulWidget {
  final double initialLatitude;
  final double initialLongitude;
  final double initialRadius;
  final void Function(double latitude, double longitude) onLocationChanged;
  final ValueChanged<double> onRadiusChanged;

  const MapaEmpresaSelector({
    super.key,
    required this.initialLatitude,
    required this.initialLongitude,
    required this.initialRadius,
    required this.onLocationChanged,
    required this.onRadiusChanged,
  });

  @override
  State<MapaEmpresaSelector> createState() => _MapaEmpresaSelectorState();
}

class _MapaEmpresaSelectorState extends State<MapaEmpresaSelector> {
  final MapController _mapController = MapController();

  late double _latitude;
  late double _longitude;
  late double _radius;
  bool _mapFailed = false;

  late final TextEditingController _radiusController;

  @override
  void initState() {
    super.initState();
    _latitude = kNapoDefaultLatitude;
    _longitude = kNapoDefaultLongitude;
    _radius = widget.initialRadius;

    _radiusController = TextEditingController(text: _radius.toStringAsFixed(0));
  }

  @override
  void dispose() {
    _mapController.dispose();
    _radiusController.dispose();
    super.dispose();
  }

  void _updateLocation(double lat, double lng) {
    final nextLat = lat.clamp(-90.0, 90.0);
    final nextLng = lng.clamp(-180.0, 180.0);

    setState(() {
      _latitude = nextLat;
      _longitude = nextLng;
    });

    widget.onLocationChanged(_latitude, _longitude);
  }

  void _updateRadius(double radius) {
    if (radius <= 0) return;
    setState(() => _radius = radius);
    _radiusController.text = radius.toStringAsFixed(0);
    widget.onRadiusChanged(radius);
  }

  bool _isAllowedNapoLocation(double lat, double lng) {
    const minLat = -1.8;
    const maxLat = -0.4;
    const minLng = -78.3;
    const maxLng = -77.0;

    return lat >= minLat && lat <= maxLat && lng >= minLng && lng <= maxLng;
  }

  Future<void> _openFullMapPicker() async {
    final result = await showDialog<Map<String, double>>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        final dialogController = MapController();
        final dialogSearchController = TextEditingController();
        var dialogLat = kNapoDefaultLatitude;
        var dialogLng = kNapoDefaultLongitude;
        var dialogMapFailed = false;
        var dialogIsSearching = false;

        return StatefulBuilder(
          builder: (context, setState) {
            Future<void> searchInDialog(String rawQuery) async {
              final query = rawQuery.trim();
              if (query.isEmpty) return;

              final messenger = ScaffoldMessenger.maybeOf(context);
              final navigator = Navigator.of(context);

              setState(() => dialogIsSearching = true);

              try {
                final uri = Uri.https(
                  'nominatim.openstreetmap.org',
                  '/search',
                  {
                    'q': query,
                    'format': 'jsonv2',
                    'limit': '5',
                    'addressdetails': '1',
                    'countrycodes': 'ec',
                    'viewbox': '-78.3,-0.4,-77.0,-1.8',
                    'bounded': '1',
                  },
                );

                final response = await http.get(
                  uri,
                  headers: {
                    'Accept-Language': 'es',
                    'User-Agent': 'BitacorasApp/1.0',
                  },
                );

                if (response.statusCode != 200) {
                  setState(() => dialogIsSearching = false);
                  messenger?.showSnackBar(
                    const SnackBar(
                      content: Text('No se pudo buscar el lugar indicado.'),
                    ),
                  );
                  return;
                }

                final data = jsonDecode(response.body) as List<dynamic>;
                final filtered = data.whereType<Map<String, dynamic>>().where((item) {
                  final lat = double.tryParse(item['lat']?.toString() ?? '') ?? double.nan;
                  final lng = double.tryParse(item['lon']?.toString() ?? '') ?? double.nan;

                  if (lat.isNaN || lng.isNaN) return false;

                  final address = item['address'];
                  final countryCode = (address is Map ? address['country_code'] : '')?.toString().toLowerCase() ?? '';
                  return countryCode == 'ec' && _isAllowedNapoLocation(lat, lng);
                }).toList();

                if (filtered.isEmpty) {
                  setState(() => dialogIsSearching = false);
                  messenger?.showSnackBar(
                    const SnackBar(
                      content: Text('Solo se permiten ubicaciones en Ecuador y provincia de Napo.'),
                    ),
                  );
                  return;
                }

                final item = filtered.first;
                final foundLat = double.tryParse(item['lat']?.toString() ?? '') ?? dialogLat;
                final foundLng = double.tryParse(item['lon']?.toString() ?? '') ?? dialogLng;

                setState(() => dialogIsSearching = false);
                dialogController.move(LatLng(foundLat, foundLng), 15);
                navigator.pop({'lat': foundLat, 'lng': foundLng});
              } catch (_) {
                setState(() => dialogIsSearching = false);
                messenger?.showSnackBar(
                  const SnackBar(content: Text('La búsqueda no está disponible ahora.')),
                );
              }
            }

            return Dialog.fullscreen(
              child: Scaffold(
                floatingActionButton: FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.of(context).pop({
                      'lat': dialogLat,
                      'lng': dialogLng,
                    });
                  },
                  icon: const Icon(Icons.save_alt_rounded),
                  label: const Text('Guardar ubicación'),
                ),
                floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
                appBar: AppBar(
                  title: const Text('Selecciona la ubicación'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop({
                          'lat': dialogLat,
                          'lng': dialogLng,
                        });
                      },
                      child: const Text('Guardar'),
                    ),
                  ],
                ),
                body: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: TextField(
                        controller: dialogSearchController,
                        decoration: InputDecoration(
                          hintText: 'Buscar lugar o dirección',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          suffixIcon: dialogIsSearching
                              ? const Padding(
                                  padding: EdgeInsets.all(12),
                                  child: SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                )
                              : IconButton(
                                  icon: const Icon(Icons.search),
                                  onPressed: () => searchInDialog(dialogSearchController.text),
                                ),
                        ),
                        onSubmitted: searchInDialog,
                      ),
                    ),
                    Expanded(
                      child: dialogMapFailed
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Text(
                                  'El mapa no pudo cargarse. Puedes seguir usando las coordenadas manualmente.',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          : FlutterMap(
                              mapController: dialogController,
                              options: MapOptions(
                                initialCenter: LatLng(dialogLat, dialogLng),
                                initialZoom: 15,
                                interactionOptions: const InteractionOptions(
                                  flags: InteractiveFlag.all,
                                ),
                                onTap: (_, point) {
                                  setState(() {
                                    dialogLat = point.latitude;
                                    dialogLng = point.longitude;
                                  });
                                },
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  userAgentPackageName: 'com.example.bitacoras_app',
                                  errorTileCallback: (tile, error, stackTrace) {
                                    setState(() => dialogMapFailed = true);
                                  },
                                ),
                                CircleLayer(
                                  circles: [
                                    CircleMarker(
                                      point: LatLng(dialogLat, dialogLng),
                                      radius: _radius,
                                      useRadiusInMeter: true,
                                      color: const Color(0xFF42A5F5).withValues(alpha: 0.22),
                                      borderColor: const Color(0xFF1565C0),
                                      borderStrokeWidth: 2,
                                    ),
                                  ],
                                ),
                                MarkerLayer(
                                  markers: [
                                    Marker(
                                      point: LatLng(dialogLat, dialogLng),
                                      width: 32,
                                      height: 32,
                                      child: const Icon(
                                        Icons.location_on,
                                        color: Color(0xFF1565C0),
                                        size: 32,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (result != null && mounted) {
      _updateLocation(result['lat']!, result['lng']!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mapContent = _mapFailed
        ? Container(
            height: 260,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xFFEAF3FF),
              border: Border.all(color: const Color(0xFFCBD5E1)),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(painter: _MapaLocalPainter()),
                ),
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      'Mapa local sin internet',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF334155),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        : SizedBox(
            height: 260,
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: LatLng(_latitude, _longitude),
                initialZoom: 15,
                interactionOptions: const InteractionOptions(flags: InteractiveFlag.all),
                onTap: (_, point) => _updateLocation(point.latitude, point.longitude),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.bitacoras_app',
                  errorTileCallback: (tile, error, stackTrace) {
                    if (mounted) {
                      setState(() => _mapFailed = true);
                    }
                  },
                ),
                CircleLayer(
                  circles: [
                    CircleMarker(
                      point: LatLng(_latitude, _longitude),
                      radius: _radius,
                      useRadiusInMeter: true,
                      color: const Color(0xFF42A5F5).withValues(alpha: 0.22),
                      borderColor: const Color(0xFF1565C0),
                      borderStrokeWidth: 2,
                    ),
                  ],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(_latitude, _longitude),
                      width: 32,
                      height: 32,
                      child: const Icon(
                        Icons.location_on,
                        color: Color(0xFF1565C0),
                        size: 32,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  child: Text(
                    'Ubicación y radio permitido',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    overflow: TextOverflow.visible,
                  ),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: _openFullMapPicker,
                  icon: const Icon(Icons.map_outlined),
                  label: const Text('Mapa completo'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _openFullMapPicker,
              child: mapContent,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: TextEditingController(text: _latitude.toStringAsFixed(6))
                      ..selection = const TextSelection.collapsed(offset: 0),
                    readOnly: true,
                    decoration: const InputDecoration(labelText: 'Latitud'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: TextEditingController(text: _longitude.toStringAsFixed(6))
                      ..selection = const TextSelection.collapsed(offset: 0),
                    readOnly: true,
                    decoration: const InputDecoration(labelText: 'Longitud'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_mapFailed)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.orange),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'El mapa real no está disponible; la ubicación se mantiene según la última selección válida.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            Row(
              children: [
                const Text('Radio:'),
                Expanded(
                  child: Slider(
                    value: _radius,
                    min: 10,
                    max: 500,
                    divisions: 49,
                    label: '${_radius.round()} m',
                    onChanged: _updateRadius,
                  ),
                ),
                Text('${_radius.round()} m'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MapaLocalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final basePaint = Paint()
      ..color = const Color(0xFFB9E7FF)
      ..style = PaintingStyle.fill;

    final gridPaint = Paint()
      ..color = const Color(0xFFB0DFF8)
      ..strokeWidth = 1;

    final roadPaint = Paint()
      ..color = const Color(0xFFE5E7EB)
      ..strokeWidth = 10;

    final greenPaint = Paint()
      ..color = const Color(0xFF9ED38D)
      ..style = PaintingStyle.fill;

    canvas.drawRect(Offset.zero & size, basePaint);

    for (int i = 0; i <= 8; i++) {
      final x = (size.width / 8) * i;
      final y = (size.height / 8) * i;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final parkRect = Rect.fromLTWH(16, 18, 120, 70);
    canvas.drawRect(parkRect, greenPaint);

    final roadPath = ui.Path();
    roadPath.moveTo(20, 120);
    roadPath.lineTo(60, 90);
    roadPath.lineTo(120, 140);
    roadPath.lineTo(200, 60);
    roadPath.lineTo(290, 120);
    roadPath.lineTo(340, 180);
    roadPath.lineTo(240, 230);
    roadPath.lineTo(120, 210);
    roadPath.lineTo(40, 150);
    roadPath.close();

    canvas.drawPath(roadPath, roadPaint);
    canvas.drawLine(const Offset(40, 90), const Offset(300, 120), roadPaint);
    canvas.drawLine(const Offset(80, 150), const Offset(250, 40), roadPaint);
    canvas.drawLine(const Offset(10, 50), const Offset(150, 180), roadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
