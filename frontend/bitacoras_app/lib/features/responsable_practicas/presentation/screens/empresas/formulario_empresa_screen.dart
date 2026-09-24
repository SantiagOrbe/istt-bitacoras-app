import 'package:bitacoras_app/features/responsable_practicas/responsable_practicas.dart';


class FormularioEmpresaScreen extends StatelessWidget {
  final EmpresaModel? company;
  final GestionEmpresaController controller;

  const FormularioEmpresaScreen({super.key, this.company, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: InicioAppBar(
        user: context.read<AuthSession>().currentUser!,
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