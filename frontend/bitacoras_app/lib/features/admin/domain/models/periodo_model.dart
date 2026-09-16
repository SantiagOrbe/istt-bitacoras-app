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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': name,
      'fecha_inicio': _formatDate(startDate),
      'fecha_fin': _formatDate(endDate),
      'estado': isActive,
    };
  }

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
}
