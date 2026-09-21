import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../inicio/domain/models/usuario_model.dart';
import '../../../../config/constants/app_colors.dart';
import '../../../inicio/presentation/widgets/inicio_app_bar.dart';
import '../controllers/coordinador_consulta_controller.dart';
import '../../domain/repositories/i_coordinador_repository.dart';
import '../widgets/coordinador_info_card.dart';

class CoordinadorTutoresScreen extends StatefulWidget {
  final UsuarioModel currentUser;

  const CoordinadorTutoresScreen({super.key, required this.currentUser});

  @override
  State<CoordinadorTutoresScreen> createState() =>
      _CoordinadorTutoresScreenState();
}

class _CoordinadorTutoresScreenState
    extends State<CoordinadorTutoresScreen> {
  late final CoordinadorConsultaController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CoordinadorConsultaController(
      repository: context.read<ICoordinadorRepository>(),
    );
    _controller.cargarTutores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: InicioAppBar(
        user: widget.currentUser,
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
            separatorBuilder: (_, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = _controller.items[index];
              return CoordinadorDetalleCard(
                title: item['nombre']?.toString() ?? 'Tutor sin nombre',
                icon: Icons.badge_rounded,
                details: [
                  MapEntry('Correo', item['email']?.toString() ?? 'Sin correo registrado'),
                  MapEntry('Teléfono', item['telefono']?.toString().isNotEmpty == true ? item['telefono'].toString() : 'Sin teléfono registrado'),
                  MapEntry('Cédula', item['cedula']?.toString() ?? 'Sin cédula registrada'),
                  MapEntry('Carrera', item['carrera_nombre']?.toString() ?? widget.currentUser.careerName ?? 'Sin carrera registrada'),
                  MapEntry('Empresa asignada', item['empresa_nombre']?.toString() ?? 'Sin empresa asignada'),
                  MapEntry('Estado', item['estado'] == true ? 'Activo' : 'Inactivo'),
                ],
              );
            },
          );
        },
      ),
    );
  }
}