import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../config/constants/app_colors.dart';
import '../../../../inicio/data/repositories/fake_usuario_repository.dart';
import '../../../../inicio/presentation/widgets/inicio_app_bar.dart';
import '../../../domain/models/empresa_model.dart';
import '../../controllers/gestion_empresa_controller.dart';
import '../../widgets/empresas/formulario_empresa_body.dart';

class FormularioEmpresaScreen extends StatelessWidget {
  final EmpresaModel? company;
  final GestionEmpresaController controller;

  const FormularioEmpresaScreen({super.key, this.company, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: InicioAppBar(
        user: FakeUsuarioRepository.practiceManager,
        showBackButton: true,
        showDrawerButton: false,
        onBackPressed: () => context.pop(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: FormularioEmpresaBody(company: company, controller: controller),
      ),
    );
  }
}