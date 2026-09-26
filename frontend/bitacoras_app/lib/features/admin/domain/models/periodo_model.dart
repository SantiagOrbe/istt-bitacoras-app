class PeriodoModel {
  final String id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;

  const PeriodoModel({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    this.isActive = true,
  });

  factory PeriodoModel.fromJson(Map<String, dynamic> json) {
    final start = DateTime.tryParse(json['fecha_inicio'] as String? ?? '');
    final end = DateTime.tryParse(json['fecha_fin'] as String? ?? '');

    return PeriodoModel(
      id: json['id']?.toString() ?? '',
      name: json['nombre'] as String? ?? json['name'] as String? ?? '',
      startDate: start ?? DateTime(1970),
      endDate: end ?? DateTime(1970),
      isActive: json['estado'] as bool? ?? json['is_active'] as bool? ?? true,
    );
  }

  factory PeriodoModel.desdeJson(Map<String, dynamic> json) =>
      PeriodoModel.fromJson(json);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': name,
      'fecha_inicio': _formatDate(startDate),
      'fecha_fin': _formatDate(endDate),
      'estado': isActive,
    };
  }

  Map<String, dynamic> aJson() => toJson();

  static String _formatDate(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  PeriodoModel copyWith({
    String? id,
    String? name,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
  }) {
    return PeriodoModel(
      id: id ?? this.id,
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
    );
  }

  PeriodoModel copiarCon({
    String? nuevoId,
    String? nombre,
    DateTime? fechaInicio,
    DateTime? fechaFin,
    bool? estado,
  }) {
    return PeriodoModel(
      id: nuevoId ?? id,
      name: nombre ?? name,
      startDate: fechaInicio ?? startDate,
      endDate: fechaFin ?? endDate,
      isActive: estado ?? isActive,
    );
  }
}

typedef PeriodoModelo = PeriodoModel;

extension PeriodoModelEspanol on PeriodoModel {
  String get nombre => name;
  DateTime get fechaInicio => startDate;
  DateTime get fechaFin => endDate;
  bool get estado => isActive;

  PeriodoModel conNombre(String nuevoNombre) => copyWith(name: nuevoNombre);
  PeriodoModel conFechaInicio(DateTime nuevaFechaInicio) =>
      copyWith(startDate: nuevaFechaInicio);
  PeriodoModel conFechaFin(DateTime nuevaFechaFin) =>
      copyWith(endDate: nuevaFechaFin);
  PeriodoModel conEstado(bool nuevoEstado) => copyWith(isActive: nuevoEstado);
}
