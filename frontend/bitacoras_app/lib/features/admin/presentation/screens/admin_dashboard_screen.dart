import 'package:bitacoras_app/app/apps.dart';

class AdminDashboardScreen extends StatelessWidget {
  final UsuarioModel currentUser;

  const AdminDashboardScreen({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    final modules = [
      _AdminModule(
        'Usuarios',
        'Roles y cuentas institucionales',
        Icons.people_outline,
        AppRoutes.userManagement,
      ),
      _AdminModule(
        'Carreras',
        'Catálogo académico',
        Icons.school_outlined,
        AppRoutes.careerManagement,
      ),
      _AdminModule(
        'Periodos lectivos',
        'Fechas y estados',
        Icons.calendar_month_outlined,
        AppRoutes.periodManagement,
      ),
      _AdminModule(
        'Carreras y periodos',
        'Habilita prácticas por periodo',
        Icons.tune_outlined,
        AppRoutes.careerPeriod,
      ),
      _AdminModule(
        'Empresas',
        'Instituciones de práctica',
        Icons.business_outlined,
        AppRoutes.companyManagement,
      ),
      _AdminModule(
        'Bitácoras',
        'Supervisión de prácticas',
        Icons.assignment_outlined,
        AppRoutes.adminPracticeLogs,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: InicioAppBar(user: currentUser, showDrawerButton: true),
      drawer: InicioDrawer(
        user: currentUser,
        sections: OpcionesDrawerFactory.getSectionsForRole(currentUser.role),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSizes.md),
          children: [
            Text('Panel de administración', style: AppTextStyles.heading),
            AppSizes.gapV4,
            Text(
              'Gestiona los catálogos y supervisa la operación académica.',
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            AppSizes.gapV20,
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: modules.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppSizes.sm,
                mainAxisSpacing: AppSizes.sm,
                childAspectRatio: 1.08,
              ),
              itemBuilder: (context, index) {
                final module = modules[index];
                return InkWell(
                  onTap: () => context.push(module.route),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  child: Container(
                    padding: const EdgeInsets.all(AppSizes.md),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      border: Border.all(color: AppColors.outline),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(module.icon, color: AppColors.primary, size: 30),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(module.title, style: AppTextStyles.bodyBold),
                            AppSizes.gapV4,
                            Text(module.subtitle, style: AppTextStyles.caption),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminModule {
  final String title;
  final String subtitle;
  final IconData icon;
  final String route;

  const _AdminModule(this.title, this.subtitle, this.icon, this.route);
}
