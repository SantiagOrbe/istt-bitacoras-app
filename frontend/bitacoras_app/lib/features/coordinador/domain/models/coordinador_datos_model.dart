class CoordinadorCarreraModel {
  final String id;
  final String nombre;
  final String codigo;
  final String sigla;
  final String modalidad;
  final bool estaActiva;

  const CoordinadorCarreraModel({
    required this.id,
    required this.nombre,
    required this.codigo,
    required this.sigla,
    required this.modalidad,
    required this.estaActiva,
  });

  factory CoordinadorCarreraModel.fromJson(Map<String, dynamic> json) {
    return CoordinadorCarreraModel(
      id: json['id']?.toString() ?? '',
      nombre: json['nombre']?.toString() ?? '',
      codigo: json['codigo_carrera']?.toString() ?? '',
      sigla: json['sigla_carrera']?.toString() ?? '',
      modalidad: json['modalidad']?.toString() ?? '',
      estaActiva: json['estado'] as bool? ?? true,
    );
  }
}

class CoordinadorEstudianteModel {
  final String id;
  final String nombre;
  final String username;
  final String correo;
  final String telefono;
  final String cedula;
  final String matricula;
  final String carrera;
  final String semestre;
  final String paralelo;
  final String empresa;
  final String tutorAcademico;
  final String tutorAcademicoCedula;
  final String tutorEmpresarial;
  final String tutorEmpresarialCedula;
  final String tutorEmpresarialCargo;
  final double horasAcumuladas;
  final int horasRequeridas;
  final bool estaActivo;

  const CoordinadorEstudianteModel({
    required this.id,
    required this.nombre,
    required this.username,
    required this.correo,
    required this.telefono,
    required this.cedula,
    required this.matricula,
    required this.carrera,
    required this.semestre,
    required this.paralelo,
    required this.empresa,
    required this.tutorAcademico,
    required this.tutorAcademicoCedula,
    required this.tutorEmpresarial,
    required this.tutorEmpresarialCedula,
    required this.tutorEmpresarialCargo,
    required this.horasAcumuladas,
    required this.horasRequeridas,
    required this.estaActivo,
  });

  factory CoordinadorEstudianteModel.fromJson(Map<String, dynamic> json) {
    return CoordinadorEstudianteModel(
      id: json['id']?.toString() ?? '',
      nombre: json['nombre']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      correo: json['email']?.toString() ?? '',
      telefono: json['telefono']?.toString() ?? '',
      cedula: json['cedula']?.toString() ?? '',
      matricula: json['matricula']?.toString() ?? '',
      carrera: json['carrera_nombre']?.toString() ?? '',
      semestre: json['semestre_nombre']?.toString() ?? '',
      paralelo: json['paralelo_nombre']?.toString() ?? '',
      empresa: json['empresa_nombre']?.toString() ?? '',
      tutorAcademico: json['tutor_academico']?.toString() ?? '',
        tutorAcademicoCedula: json['tutor_academico_cedula']?.toString() ?? '',
        tutorEmpresarial: json['tutor_empresarial']?.toString() ?? '',
        tutorEmpresarialCedula:
          json['tutor_empresarial_cedula']?.toString() ?? '',
        tutorEmpresarialCargo:
          json['tutor_empresarial_cargo']?.toString() ?? '',
        horasAcumuladas:
          double.tryParse(json['horas_acumuladas']?.toString() ?? '') ?? 0,
        horasRequeridas:
          int.tryParse(json['horas_requeridas']?.toString() ?? '') ?? 0,
        estaActivo: json['estado'] as bool? ?? false,
    );
  }
}

class CoordinadorTutorModel {
  final String id;
  final String nombre;
  final String correo;
  final String telefono;
  final String cedula;
  final String carrera;
  final String empresa;
  final bool estaActivo;

  const CoordinadorTutorModel({
    required this.id,
    required this.nombre,
    required this.correo,
    required this.telefono,
    required this.cedula,
    required this.carrera,
    required this.empresa,
    required this.estaActivo,
  });

  factory CoordinadorTutorModel.fromJson(Map<String, dynamic> json) {
    return CoordinadorTutorModel(
      id: json['id']?.toString() ?? '',
      nombre: json['nombre']?.toString() ?? '',
      correo: json['email']?.toString() ?? '',
      telefono: json['telefono']?.toString() ?? '',
      cedula: json['cedula']?.toString() ?? '',
      carrera: json['carrera_nombre']?.toString() ?? '',
      empresa: json['empresa_nombre']?.toString() ?? '',
      estaActivo: json['estado'] as bool? ?? false,
    );
  }
}

class CoordinadorSemestreModel {
  final String id;
  final String nombre;
  final String nivel;
  final int horasPracticas;
  final bool estaActivo;

  const CoordinadorSemestreModel({
    required this.id,
    required this.nombre,
    required this.nivel,
    required this.horasPracticas,
    required this.estaActivo,
  });

  factory CoordinadorSemestreModel.fromJson(Map<String, dynamic> json) {
    return CoordinadorSemestreModel(
      id: json['id']?.toString() ?? '',
      nombre: json['nombre']?.toString() ?? '',
      nivel: json['nivel']?.toString() ?? '',
      horasPracticas: int.tryParse(json['horas_practicas']?.toString() ?? '') ?? 0,
      estaActivo: json['estado'] as bool? ?? false,
    );
  }
}

class CoordinadorParaleloModel {
  final String id;
  final String nombre;
  final String jornada;
  final String semestreId;
  final bool estaActivo;

  const CoordinadorParaleloModel({
    required this.id,
    required this.nombre,
    required this.jornada,
    required this.semestreId,
    required this.estaActivo,
  });

  factory CoordinadorParaleloModel.fromJson(Map<String, dynamic> json) {
    return CoordinadorParaleloModel(
      id: json['id']?.toString() ?? '',
      nombre: json['nombre']?.toString() ?? '',
      jornada: json['jornada']?.toString() ?? '',
      semestreId: json['semestre_id']?.toString() ?? '',
      estaActivo: json['estado'] as bool? ?? false,
    );
  }
}

class CoordinadorDatosModel {
  final String carrera;
  final List<CoordinadorEstudianteModel> estudiantes;
  final List<CoordinadorTutorModel> tutores;
  final List<CoordinadorSemestreModel> semestres;
  final List<CoordinadorParaleloModel> paralelos;

  const CoordinadorDatosModel({
    required this.carrera,
    required this.estudiantes,
    required this.tutores,
    required this.semestres,
    required this.paralelos,
  });

  factory CoordinadorDatosModel.fromJson(Map<String, dynamic> json) {
    final carreraJson = json['carrera'];
    final estudiantesJson = json['estudiantes'];
    final tutoresJson = json['tutores'];
    final semestresJson = json['semestres'];
    final paralelosJson = json['paralelos'];

    return CoordinadorDatosModel(
      carrera: carreraJson is Map<String, dynamic>
          ? carreraJson['nombre']?.toString() ?? ''
          : '',
      estudiantes: estudiantesJson is List
          ? estudiantesJson
                .whereType<Map<String, dynamic>>()
                .map(CoordinadorEstudianteModel.fromJson)
                .toList()
          : const [],
      tutores: tutoresJson is List
          ? tutoresJson
                .whereType<Map<String, dynamic>>()
                .map(CoordinadorTutorModel.fromJson)
                .toList()
          : const [],
      semestres: semestresJson is List
          ? semestresJson
                .whereType<Map<String, dynamic>>()
                .map(CoordinadorSemestreModel.fromJson)
                .toList()
          : const [],
      paralelos: paralelosJson is List
          ? paralelosJson
                .whereType<Map<String, dynamic>>()
                .map(CoordinadorParaleloModel.fromJson)
                .toList()
          : const [],
    );
  }
}
