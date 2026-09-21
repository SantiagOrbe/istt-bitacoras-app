import 'package:bitacoras_app/features/admin/domain/models/registro_practica_model.dart';
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

class _SeguimientoEstudiantesScreenState extends State<SeguimientoEstudiantesScreen>
    with SingleTickerProviderStateMixin {
  final ITutorRepository _repository = FakeTutorRepository();
  final List<EstudianteAsignadoModel> _assignedList = [];
  final List<RegistroPracticaModel> _allPracticeLogs = [];
  bool _isLoading = true;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final data = await _repository.getAssignedStudents(widget.currentUser.id, isAcademic: widget.isAcademic);

      final records = <RegistroPracticaModel>[];
      for (final item in data) {
        final logs = await _repository.getStudentLogs(item.student.id);
        records.addAll(logs);
      }

      if (!mounted) return;

      setState(() {
        _assignedList.clear();
        _assignedList.addAll(data);
        _allPracticeLogs.clear();
        _allPracticeLogs.addAll(records);
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _assignedList.clear();
        _allPracticeLogs.clear();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _toggleLogStatus(RegistroPracticaModel log) async {
    try {
      final updated = await _repository.updateLog(logId: log.id, isActive: !log.isActive);
      if (!mounted) return;

      setState(() {
        final index = _allPracticeLogs.indexWhere((item) => item.id == log.id);
        if (index != -1) {
          _allPracticeLogs[index] = updated;
        }
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo cambiar el estado del registro.')),
      );
    }
  }

  Future<void> _editLog(RegistroPracticaModel log) async {
    final controller = TextEditingController(text: log.activityDescription);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar registro'),
        content: TextField(
          controller: controller,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: 'Describe la actividad realizada',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );

    if (result == null || result.isEmpty || !mounted) {
      return;
    }

    try {
      final updated = await _repository.updateLog(
        logId: log.id,
        activityDescription: result,
      );

      if (!mounted) return;

      setState(() {
        final index = _allPracticeLogs.indexWhere((item) => item.id == log.id);
        if (index != -1) {
          _allPracticeLogs[index] = updated;
        }
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo guardar el registro.')),
      );
    }
  }

  Widget _buildTutoriadosTab() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }

    if (_assignedList.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'No hay tutoriados asignados.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 15),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _assignedList.length,
      itemBuilder: (context, index) {
        final item = _assignedList[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: SeguimientoEstudianteCard(
            item: item,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetalleSeguimientoEstudianteScreen(assignedStudent: item),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRegistrosTab() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }

    if (_allPracticeLogs.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'No hay registros de práctica para mostrar.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 15),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _allPracticeLogs.length,
      itemBuilder: (context, index) {
        final log = _allPracticeLogs[index];
        final isActive = log.isActive;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            log.studentName,
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            log.date,
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          _editLog(log);
                        } else if (value == 'toggle') {
                          _toggleLogStatus(log);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit_outlined, size: 18),
                              SizedBox(width: 8),
                              Text('Editar'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'toggle',
                          child: Row(
                            children: [
                              Icon(isActive ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 18),
                              const SizedBox(width: 8),
                              Text(isActive ? 'Desactivar' : 'Activar'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  log.activityDescription,
                  style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.access_time_filled, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 6),
                    Text(
                      '${log.entryTimeLabel} - ${log.exitTimeLabel}',
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: log.status == 'Aprobado'
                            ? AppColors.successSoft
                            : isActive
                                ? AppColors.warningSoft
                                : AppColors.errorSoft,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        isActive ? log.status : 'Desactivado',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: isActive
                              ? (log.status == 'Aprobado' ? AppColors.success : AppColors.warning)
                              : AppColors.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
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
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.outline),
                boxShadow: const [
                  BoxShadow(color: AppColors.shadow, blurRadius: 12, offset: Offset(0, 4)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Seguimiento de Prácticas',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tutor: ${widget.currentUser.name}',
                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.outline),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorColor: AppColors.primary,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textSecondary,
                labelStyle: const TextStyle(fontWeight: FontWeight.w600),
                tabs: const [
                  Tab(text: 'Tutoriados'),
                  Tab(text: 'Registros'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTutoriadosTab(),
                  _buildRegistrosTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}