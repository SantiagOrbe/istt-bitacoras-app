import 'package:bitacoras_app/shared/exports.dart';

class PerfilModel {
  final UsuarioModel user;
  final String cedula;
  final String matricula;
  final String tutorAcademico;
  final String tutorEmpresarial;

  PerfilModel({
    required this.user,
    required this.cedula,
    required this.matricula,
    this.tutorAcademico = 'Sin asignar',
    this.tutorEmpresarial = 'Sin asignar',
  });

  factory PerfilModel.fromUser(UsuarioModel user, {Map<String, dynamic>? extraData}) {
    return PerfilModel(
      user: user,
      cedula: extraData?['cedula'] ?? '1500000000',
      matricula: extraData?['matricula'] ?? 'EST-2026-001',
      tutorAcademico: extraData?['tutor_academico'] ?? 'Ing. Juan Pérez',
      tutorEmpresarial: extraData?['tutor_empresarial'] ?? 'Ing. María López',
    );
  }
}