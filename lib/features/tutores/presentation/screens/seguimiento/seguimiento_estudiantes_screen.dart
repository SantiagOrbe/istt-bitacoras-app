import 'package:bitacoras_app/features/inicio/domain/models/usuario_model.dart';
import 'package:bitacoras_app/features/inicio/presentation/widgets/inicio_app_bar.dart';
import 'package:bitacoras_app/features/tutores/presentation/screens/seguimiento/detalle_seguimiento_estudiante_screen.dart';
import 'package:flutter/material.dart';
import '../../../../../config/constants/app_colors.dart';

import '../../../data/repositories/fake_tutor_repository.dart';
import '../../../domain/models/estudiante_asignado_model.dart';
import '../../../domain/repositories/i_tutor_repository.dart';
import '../../widgets/seguimiento/seguimiento_estudiante_card.dart';

class SeguimientoEstudiantesScreen extends StatefulWidget {
  final UsuarioModel currentUser;
  final bool isAcademic;

  const SeguimientoEstudiantesScreen({super.key, required this.currentUser, required this.isAcademic});

  @override
  State<SeguimientoEstudiantesScreen> createState() => _SeguimientoEstudiantesScreenState();
}

class _SeguimientoEstudiantesScreenState extends State<SeguimientoEstudiantesScreen> {
  final ITutorRepository _repository = FakeTutorRepository();
  List<EstudianteAsignadoModel> _assignedList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await _repository.getAssignedStudents(widget.currentUser.id, isAcademic: widget.isAcademic);
    setState(() {
      _assignedList = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: InicioAppBar(user: widget.currentUser),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Seguimiento de Prácticas', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                  : ListView.builder(
                      itemCount: _assignedList.length,
                      itemBuilder: (context, index) {
                        final item = _assignedList[index];
                        return SeguimientoEstudianteCard(
                          item: item,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetalleSeguimientoEstudianteScreen(assignedStudent: item))),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}