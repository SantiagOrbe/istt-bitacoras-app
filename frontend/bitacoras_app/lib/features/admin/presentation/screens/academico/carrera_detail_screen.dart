import 'package:bitacoras_app/features/admin/admin.dart';

class CarreraDetailScreen extends StatefulWidget {
  final UsuarioModel currentUser;
  final CarreraModel career;
  final IAdminRepository adminRepository;

  const CarreraDetailScreen({
    super.key,
    required this.currentUser,
    required this.career,
    required this.adminRepository,
  });

  @override
  State<CarreraDetailScreen> createState() => _CarreraDetailScreenState();
}

class _CarreraDetailScreenState extends State<CarreraDetailScreen> {
  late CarreraModel _career;

  @override
  void initState() {
    super.initState();
    _career = widget.career;
  }

  Future<void> _toggleStatus() async {
    final willActivate = !_career.isActive;

    if (!willActivate) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Desactivar carrera'),
          content: const Text(
            'Si desactivas esta carrera, dejará de estar disponible para nuevos registros y no podrá seleccionarse en formularios activos. Esto incluye semestres y estudiantes asociados.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              style: FilledButton.styleFrom(backgroundColor: AppColores.error),
              child: const Text('Confirmar'),
            ),
          ],
        ),
      );
      if (confirmed != true) return;
    }

    final updated = _career.copyWith(isActive: willActivate);
    try {
      await widget.adminRepository.actualizarCarrera(
        updated,
        confirmDesactivate: !willActivate,
      );
      if (!mounted) return;
      setState(() => _career = updated);
      if (mounted) {
        Navigator.pop(context, updated);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            willActivate ? 'Carrera activada.' : 'Carrera desactivada.',
          ),
          backgroundColor: willActivate ? AppColores.success : AppColores.error,
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(
          content: Text(error.toString(), maxLines: 3, softWrap: true),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColores.background,
      appBar: InicioAppBar(
        user: widget.currentUser,
        showBackButton: true,
        onBackPressed: () => context.pop(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTamanos.md),
          child: CarreraDetailSummaryCard(
            career: _career,
            onEdit: () async {
              final updated = await showModalBottomSheet<CarreraModel>(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => HojaFormularioCarrera(
                  career: _career,
                  existingCareers: [_career],
                ),
              );
              if (updated == null || !context.mounted) return;

              try {
                await widget.adminRepository.actualizarCarrera(
                  updated,
                  confirmDesactivate: !updated.isActive && _career.isActive,
                );
                if (context.mounted) {
                  setState(() => _career = updated);
                  context.pop(updated);
                }
              } catch (error) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(
                  SnackBar(
                    content: Text(error.toString(), maxLines: 3, softWrap: true),
                  ),
                );
              }
            },
            onOpenSemesters: () => context.push(
              AppRoutes.gestionSemestres.replaceFirst(':carreraId', _career.id),
            ),
            onToggleStatus: _toggleStatus,
          ),
        ),
      ),
    );
  }
}
