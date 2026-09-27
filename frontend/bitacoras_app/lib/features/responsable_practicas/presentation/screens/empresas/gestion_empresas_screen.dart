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
    _controller.repository.invalidarCache();
    _controller.loadCompanies();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: AppColores.background,
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
                  AppTamanos.md,
                  AppTamanos.md,
                  AppTamanos.md,
                  AppTamanos.sm,
                ),
                child: InstitutionalGlowCard(
                  accentColor: AppColores.primary,
                  child: Padding(
                    padding: const EdgeInsets.all(AppTamanos.md),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColores.primary.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(AppTamanos.radiusSm),
                          ),
                          child: const Icon(
                            Icons.business_rounded,
                            color: AppColores.primary,
                          ),
                        ),
                        AppTamanos.gapH12,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Empresas e instituciones', style: AppEstiloTexto.title),
                              AppTamanos.gapV4,
                              Text(
                                '${_controller.companies.length} registros disponibles',
                                style: AppEstiloTexto.caption,
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
                padding: const EdgeInsets.fromLTRB(AppTamanos.md, AppTamanos.sm, AppTamanos.md, AppTamanos.md),
                child: TextField(
                  onChanged: _controller.searchCompanies,
                  style: const TextStyle(color: AppColores.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Buscar por nombre o dirección...',
                    hintStyle: const TextStyle(color: AppColores.textHint),
                    prefixIcon: const Icon(Icons.search_rounded, color: AppColores.textSecondary),
                    filled: true,
                    fillColor: AppColores.surface,
                    prefixIconColor: AppColores.primary,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppTamanos.radiusMd), borderSide: const BorderSide(color: AppColores.outline)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTamanos.radiusMd),
                      borderSide: const BorderSide(color: AppColores.outline),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTamanos.radiusMd),
                      borderSide: const BorderSide(color: AppColores.primary, width: 1.5),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
              Expanded(
                child: _controller.isLoading
                    ? const Center(child: CircularProgressIndicator(color: AppColores.primary))
                    : _controller.companies.isEmpty
                        ? const Center(
                            child: Text(
                              'No se encontraron empresas registradas.',
                              style: TextStyle(color: AppColores.textSecondary),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _controller.companies.length,
                            itemBuilder: (context, index) {
                              final company = _controller.companies[index];
                              return EmpresaCard(
                                company: company,
                                onTap: () => context.push(
                                  AppRoutes.detalleEmpresaResponsable,
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