import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../inicio/domain/models/usuario_model.dart';
import '../../../../config/constants/app_colors.dart';
import '../../../inicio/presentation/widgets/inicio_app_bar.dart';
import '../controllers/coordinador_consulta_controller.dart';
import '../../domain/repositories/i_coordinador_repository.dart';
import '../widgets/coordinador_info_card.dart';

class CoordinadorEstudiantesScreen extends StatefulWidget {
  final UsuarioModel currentUser;

  const CoordinadorEstudiantesScreen({super.key, required this.currentUser});

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
      repository: context.read<ICoordinadorRepository>(),
    );
    _controller.cargarEstudiantes();
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
          final semesters = <String, Map<String, List<Map<String, dynamic>>>>{};
          for (final item in _controller.items) {
            final semester = item['semestre_nombre']?.toString() ?? 'Semestre sin asignar';
            final parallel = item['paralelo_nombre']?.toString() ?? 'Paralelo sin asignar';
            semesters.putIfAbsent(semester, () => {});
            semesters[semester]!.putIfAbsent(parallel, () => []).add(item);
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('Estudiantes de ${_controller.datosCarrera['carrera']?['nombre'] ?? widget.currentUser.careerName ?? 'mi carrera'}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
              const SizedBox(height: 12),
              ...semesters.entries.map((semester) => Card(
                child: ExpansionTile(
                  leading: const Icon(Icons.school_outlined, color: AppColors.primary),
                  title: Text(semester.key, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${semester.value.values.expand((items) => items).length} estudiante(s)'),
                  children: semester.value.entries.map((parallel) => Card(
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: ExpansionTile(
                      leading: const Icon(Icons.class_outlined, color: AppColors.info),
                      title: Text(parallel.key, style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text('${parallel.value.length} estudiante(s)'),
                      children: parallel.value.map((item) => CoordinadorDetalleCard(
                        title: item['nombre']?.toString() ?? '',
                        icon: Icons.person_outline,
                        details: [
                          MapEntry('Correo', item['email']?.toString() ?? 'Sin correo registrado'),
                          MapEntry('Empresa', item['empresa_nombre']?.toString() ?? 'Sin empresa asignada'),
                          MapEntry('Tutor académico', item['tutor_academico']?.toString() ?? 'Sin tutor asignado'),
                          MapEntry('Semestre', item['semestre_nombre']?.toString() ?? 'Sin semestre'),
                          MapEntry('Paralelo', item['paralelo_nombre']?.toString() ?? 'Sin paralelo'),
                        ],
                      )).toList(),
                    ),
                  )).toList(),
                ),
              )),
            ],
          );
        },
      ),
    );
  }
}