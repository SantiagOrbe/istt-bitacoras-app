import 'package:bitacoras_app/shared/exports.dart';

class PerfilModel {
  final UsuarioModel user;
  final String cedula;
  final String tutorAcademico;
  final String tutorEmpresarial;

  PerfilModel({
    required this.user,
    required this.cedula,
    this.tutorAcademico = 'Sin asignar',
    this.tutorEmpresarial = 'Sin asignar',
  });

  factory PerfilModel.fromUser(
    UsuarioModel user, {
    Map<String, dynamic>? extraData,
  }) {
    return PerfilModel(
      user: user,
      cedula:
          extraData?['cedula']?.toString() ?? user.cedula ?? 'Sin registrar',
      tutorAcademico:
          extraData?['tutor_academico']?.toString() ??
          user.tutorAcademico ??
          'Sin asignar',
      tutorEmpresarial:
          extraData?['tutor_empresarial']?.toString() ??
          user.tutorEmpresarial ??
          'Sin asignar',
    );
  }
}
