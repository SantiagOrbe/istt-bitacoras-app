class EstadoVisitaTutorModel {
  final String? id;
  final String? empresaId;
  final String empresaNombre;
  final String? fecha;
  final String? horaEntrada;
  final String? horaSalida;
  final String actividades;
  final bool tieneEntrada;
  final bool tieneSalida;
  final bool tieneActividades;
  final bool puedeRegistrarEntrada;
  final bool puedeRegistrarSalida;
  final bool puedeRegistrarActividades;

  const EstadoVisitaTutorModel({
    this.id,
    this.empresaId,
    this.empresaNombre = '',
    this.fecha,
    this.horaEntrada,
    this.horaSalida,
    this.actividades = '',
    this.tieneEntrada = false,
    this.tieneSalida = false,
    this.tieneActividades = false,
    this.puedeRegistrarEntrada = true,
    this.puedeRegistrarSalida = false,
    this.puedeRegistrarActividades = false,
  });

  factory EstadoVisitaTutorModel.fromJson(Map<String, dynamic> json) {
    final hasEntry = json['tiene_entrada'] as bool? ?? json['hora_entrada'] != null;
    final hasExit = json['tiene_salida'] as bool? ?? json['hora_salida'] != null;
    final hasActivities = json['tiene_actividades'] as bool? ??
      (json['actividades']?.toString().trim().isNotEmpty ?? false);
    return EstadoVisitaTutorModel(
      id: json['id']?.toString(),
      empresaId: (json['empresa'] ?? json['empresa_id'])?.toString(),
      empresaNombre: json['empresa_nombre']?.toString() ?? '',
      fecha: json['fecha']?.toString(),
      horaEntrada: json['hora_entrada']?.toString(),
      horaSalida: json['hora_salida']?.toString(),
      actividades: json['actividades']?.toString() ?? '',
      tieneEntrada: hasEntry,
      tieneSalida: hasExit,
      tieneActividades: hasActivities,
      puedeRegistrarEntrada: json['puede_registrar_entrada'] as bool? ?? !hasEntry,
      puedeRegistrarSalida: json['puede_registrar_salida'] as bool? ?? hasActivities && !hasExit,
      puedeRegistrarActividades: json['puede_registrar_actividades'] as bool? ?? hasEntry && !hasExit,
    );
  }
}
