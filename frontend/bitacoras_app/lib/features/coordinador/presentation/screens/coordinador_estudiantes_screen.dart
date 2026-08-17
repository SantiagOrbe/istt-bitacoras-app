import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/constants/app_colors.dart';
import '../../../inicio/data/repositories/fake_usuario_repository.dart';
import '../../../inicio/presentation/widgets/inicio_app_bar.dart';
import '../../data/repositories/fake_coordinador_repository.dart';
import '../controllers/coordinador_consulta_controller.dart';
import '../widgets/coordinador_info_card.dart';

class CoordinadorEstudiantesScreen extends StatefulWidget {
  const CoordinadorEstudiantesScreen({super.key});

  @override
  State<CoordinadorEstudiantesScreen> createState() =>
      _CoordinadorEstudiantesScreenState();
}

class _CoordinadorEstudiantesScreenState
    extends State<CoordinadorEstudiantesScreen> {
  late final CoordinadorConsultaController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CoordinadorConsultaController(
      repository: FakeCoordinadorRepository(),
    );
    _controller.cargarEstudiantes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: InicioAppBar(
        user: FakeUsuarioRepository.coordinator,
        showBackButton: true,
        showDrawerButton: false,
        onBackPressed: () => context.pop(),
      ),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          if (_controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: _controller.items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = _controller.items[index];
              return CoordinadorInfoCard(
                title: item['nombre'] ?? '',
                subtitle: 'Carrera: ${item['carrera']}',
                extraInfo: 'Tutor: ${item['tutor']}',
                icon: Icons.school_rounded,
              );
            },
          );
        },
      ),
    );
  }
}