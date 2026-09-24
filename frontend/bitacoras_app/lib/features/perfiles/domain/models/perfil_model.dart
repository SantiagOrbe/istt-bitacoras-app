import 'package:bitacoras_app/features/perfiles/perfiles.dart';

class PerfilModel {
  final UsuarioModel user;
  final String cedula;
  final String tutorAcademico;
  final String tutorEmpresarial;
  final String empresaAsignada;

  PerfilModel({
    required this.user,
    required this.cedula,
    this.tutorAcademico = 'Sin asignar',
    this.tutorEmpresarial = 'Sin asignar',
    this.empresaAsignada = 'Sin asignar',
  });

  bool get puedeMostrarEmpresa =>
      user.role == RolUsuarioModel.student ||
      user.role == RolUsuarioModel.academicTutor ||
      user.role == RolUsuarioModel.companyTutor;

  factory PerfilModel.fromUser(
    UsuarioModel user, {
    Map<String, dynamic>? extraData,
  }) {
    final canHaveCompany = user.role == RolUsuarioModel.student ||
        user.role == RolUsuarioModel.academicTutor ||
        user.role == RolUsuarioModel.companyTutor;

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
      empresaAsignada: canHaveCompany
          ? (extraData?['empresa_asignada']?.toString() ??
              user.company ??
              'Sin asignar')
          : '',
    );
  }
}
