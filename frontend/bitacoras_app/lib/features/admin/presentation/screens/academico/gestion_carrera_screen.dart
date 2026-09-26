import 'package:bitacoras_app/features/admin/admin.dart';

class GestionCarreraScreen extends StatefulWidget {
  final UsuarioModel currentUser;
  final IAdminRepository adminRepository;

  const GestionCarreraScreen({
    super.key,
    required this.currentUser,
    required this.adminRepository,
  });

  @override
  State<GestionCarreraScreen> createState() => _GestionCarreraScreenState();
}

typedef CarrerasManagementScreen = GestionCarreraScreen;

class _GestionCarreraScreenState extends State<GestionCarreraScreen> {
  late final GestionCarreraController _controller;

  @override
  void initState() {
    super.initState();
    _controller = GestionCarreraController(repository: widget.adminRepository);
    _controller.loadCareers();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openCareerForm() async {
    final newCareer = await showModalBottomSheet<CarreraModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          HojaFormularioCarrera(existingCareers: _controller.careers),
    );

    if (newCareer == null || !mounted) {
      return;
    }

    final success = await _controller.createCareer(newCareer);
    if (!success && mounted && _controller.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_controller.errorMessage!),
          backgroundColor: AppColores.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColores.background,
          appBar: InicioAppBar(
            user: widget.currentUser,
            showBackButton: true,
            onBackPressed: () => context.pop(),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: _openCareerForm,
            backgroundColor: AppColores.primary,
            icon: const Icon(Icons.add_rounded, color: AppColores.surface),
            label: Text(
              'Nueva carrera',
              style: AppEstiloTexto.bodyBold.copyWith(
                color: AppColores.surface,
              ),
            ),
          ),
          body: SafeArea(
            child: GestionCarreraBody(
              careers: _controller.filteredCareers,
              totalCareers: _controller.filteredCareers.length,
              searchQuery: _controller.searchQuery,
              onSearchChanged: _controller.setSearchQuery,
              onCareerTap: (career) async {
                final updated = await context.push<CarreraModel>(
                  AppRoutes.detalleCarrera,
                  extra: career,
                );
                if (updated != null) {
                  await _controller.loadCareers();
                }
              },
            ),
          ),
        );
      },
    );
  }
}
