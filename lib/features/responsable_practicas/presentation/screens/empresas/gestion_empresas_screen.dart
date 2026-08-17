import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../app/apps.dart' hide EmpresaCard;
import '../../../../../config/constants/app_colors.dart';
import '../../../../inicio/data/repositories/fake_usuario_repository.dart';
import '../../../../inicio/presentation/widgets/inicio_app_bar.dart';
import '../../../data/repositories/fake_responsable_practicas_repository.dart';
import '../../controllers/gestion_empresa_controller.dart';
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
      repository: FakeResponsablePracticasRepository(),
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
            user: FakeUsuarioRepository.practiceManager,
            showBackButton: true,
            showDrawerButton: false,
            onBackPressed: () => context.pop(),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  onChanged: _controller.searchCompanies,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Buscar por nombre, RUC o convenio...',
                    hintStyle: const TextStyle(color: AppColors.textHint),
                    prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textSecondary),
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.outline),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.outline),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
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
                                onEdit: () {
                                  context.push(
                                    AppRoutes.responsablePracticasCompanyForm,
                                    extra: {
                                      'company': company,
                                      'controller': _controller,
                                    },
                                  );
                                },
                                onToggleStatus: () async {
                                  final willDeactivate = company.isActive;
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: Text(
                                        willDeactivate
                                            ? '¿Deseas desactivar esta empresa?'
                                            : '¿Deseas activar esta empresa?',
                                        style: const TextStyle(
                                          color: AppColors.textPrimary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      content: Text(
                                        willDeactivate
                                            ? 'La empresa no será eliminada permanentemente, sino que quedará inactiva y no podrá utilizarse para nuevas asignaciones.'
                                            : 'La empresa volverá a estar disponible para asignaciones de estudiantes.',
                                        style: const TextStyle(color: AppColors.textSecondary),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(ctx, false),
                                          child: const Text(
                                            'Cancelar',
                                            style: TextStyle(color: AppColors.textSecondary),
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () => Navigator.pop(ctx, true),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: willDeactivate
                                                ? AppColors.error
                                                : AppColors.success,
                                          ),
                                          child: Text(
                                            willDeactivate ? 'Desactivar' : 'Activar',
                                            style: const TextStyle(color: AppColors.surface),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (confirm == true) {
                                    await _controller.toggleCompanyActiveStatus(
                                      company.id,
                                      !willDeactivate,
                                    );
                                  }
                                },
                              );
                            },
                          ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: AppColors.primary,
            onPressed: () {
              context.push(
                AppRoutes.responsablePracticasCompanyForm,
                extra: {
                  'controller': _controller,
                },
              );
            },
            icon: const Icon(Icons.add_rounded, color: AppColors.surface),
            label: const Text(
              'Nueva Empresa',
              style: TextStyle(color: AppColors.surface, fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }
}