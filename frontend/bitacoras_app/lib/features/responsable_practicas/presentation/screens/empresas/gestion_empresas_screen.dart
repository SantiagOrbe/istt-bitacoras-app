import '../../../../../app/apps.dart' hide EmpresaCard;
import '../../widgets/empresas/empresa_card.dart';

class GestionEmpresasScreen extends StatefulWidget {
  const GestionEmpresasScreen({super.key});

  @override
  State<GestionEmpresasScreen> createState() => _GestionEmpresasScreenState();
}

class _GestionEmpresasScreenState extends State<GestionEmpresasScreen> {
  late final GestionEmpresaController _controller;

  @override
  void initState() {
    super.initState();
    _controller = GestionEmpresaController(
      repository: context.read<IResponsablePracticasRepository>(),
    );
    _controller.loadCompanies();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: InicioAppBar(
            user: context.read<AuthSession>().currentUser!,
            showBackButton: true,
            showDrawerButton: false,
            onBackPressed: () => context.pop(),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSizes.md,
                  AppSizes.md,
                  AppSizes.md,
                  AppSizes.sm,
                ),
                child: InstitutionalGlowCard(
                  accentColor: AppColors.primary,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSizes.md),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                          ),
                          child: const Icon(
                            Icons.business_rounded,
                            color: AppColors.primary,
                          ),
                        ),
                        AppSizes.gapH12,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Empresas e instituciones', style: AppTextStyles.title),
                              AppSizes.gapV4,
                              Text(
                                '${_controller.companies.length} registros disponibles',
                                style: AppTextStyles.caption,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSizes.md, AppSizes.sm, AppSizes.md, AppSizes.md),
                child: TextField(
                  onChanged: _controller.searchCompanies,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Buscar por nombre o dirección...',
                    hintStyle: const TextStyle(color: AppColors.textHint),
                    prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textSecondary),
                    filled: true,
                    fillColor: AppColors.surface,
                    prefixIconColor: AppColors.primary,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSizes.radiusMd), borderSide: const BorderSide(color: AppColors.outline)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      borderSide: const BorderSide(color: AppColors.outline),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
              Expanded(
                child: _controller.isLoading
                    ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                    : _controller.companies.isEmpty
                        ? const Center(
                            child: Text(
                              'No se encontraron empresas registradas.',
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _controller.companies.length,
                            itemBuilder: (context, index) {
                              final company = _controller.companies[index];
                              return EmpresaCard(
                                company: company,
                                onTap: () => context.push(
                                  AppRoutes.responsablePracticasCompanyDetail,
                                  extra: company,
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        );
      },
    );
  }
}