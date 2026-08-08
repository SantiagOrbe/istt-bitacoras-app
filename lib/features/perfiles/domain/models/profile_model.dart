import 'package:bitacoras_app/shared/exports.dart';

class ProfileModel {
  final UserModel user;
  final String cedula;
  final String matricula;
  final String tutorAcademico;
  final String tutorEmpresarial;

  ProfileModel({
    required this.user,
    required this.cedula,
    required this.matricula,
    this.tutorAcademico = 'Sin asignar',
    this.tutorEmpresarial = 'Sin asignar',
  });

  factory ProfileModel.fromUser(UserModel user, {Map<String, dynamic>? extraData}) {
    return ProfileModel(
      user: user,
      cedula: extraData?['cedula'] ?? '1500000000',
      matricula: extraData?['matricula'] ?? 'EST-2026-001',
      tutorAcademico: extraData?['tutor_academico'] ?? 'Ing. Juan Pérez',
      tutorEmpresarial: extraData?['tutor_empresarial'] ?? 'Ing. María López',
    );
  }
}