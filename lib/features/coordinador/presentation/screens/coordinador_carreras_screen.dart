import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/constants/app_colors.dart';
import '../../../home/data/repositories/fake_user_repository.dart';
import '../../../home/presentation/widgets/home_app_bar.dart';
import '../../data/repositories/fake_coordinador_repository.dart';
import '../controllers/coordinador_consulta_controller.dart';
import '../widgets/coordinador_info_card.dart';

class CoordinadorCarrerasScreen extends StatefulWidget {
  const CoordinadorCarrerasScreen({super.key});

  @override
  State<CoordinadorCarrerasScreen> createState() =>
      _CoordinadorCarrerasScreenState();
}

class _CoordinadorCarrerasScreenState
    extends State<CoordinadorCarrerasScreen> {
  late final CoordinadorConsultaController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CoordinadorConsultaController(
      repository: FakeCoordinadorRepository(),
    );
    _controller.cargarCarreras();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: HomeAppBar(
        user: FakeUserRepository.coordinator,
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
                subtitle: 'Código: ${item['codigo']}',
                extraInfo: 'Modalidad: ${item['modalidad']}',
                icon: Icons.account_tree_rounded,
              );
            },
          );
        },
      ),
    );
  }
}