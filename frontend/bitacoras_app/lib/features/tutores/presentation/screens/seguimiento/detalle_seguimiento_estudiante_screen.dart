import 'package:bitacoras_app/features/admin/domain/models/registro_practica_model.dart';
import 'package:flutter/material.dart';
import '../../../../../config/constants/app_colors.dart';
import '../../../data/repositories/fake_tutor_repository.dart';
import '../../../domain/models/estudiante_asignado_model.dart';
import '../../../domain/repositories/i_tutor_repository.dart';

class DetalleSeguimientoEstudianteScreen extends StatefulWidget {
  final EstudianteAsignadoModel assignedStudent;

  const DetalleSeguimientoEstudianteScreen({super.key, required this.assignedStudent});

  @override
  State<DetalleSeguimientoEstudianteScreen> createState() => _DetalleSeguimientoEstudianteScreenState();
}

class _DetalleSeguimientoEstudianteScreenState extends State<DetalleSeguimientoEstudianteScreen>
    with SingleTickerProviderStateMixin {
  final ITutorRepository _repository = FakeTutorRepository();
  List<RegistroPracticaModel> _logs = [];
  bool _isLoading = true;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchLogs();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchLogs() async {
    try {
      final logs = await _repository.getStudentLogs(widget.assignedStudent.student.id);
      setState(() {
        _logs = logs;
      });
    } catch (_) {
      setState(() {
        _logs = [];
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
        final idx = _logs.indexWhere((item) => item.id == log.id);
        if (idx != -1) {
          _logs[idx] = updated;
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
    final value = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar registro'),
        content: TextField(
          controller: controller,
          maxLines: 4,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );

    if (value == null || value.isEmpty || !mounted) return;

    try {
      final updated = await _repository.updateLog(logId: log.id, activityDescription: value);
      if (!mounted) return;
      setState(() {
        final idx = _logs.indexWhere((item) => item.id == log.id);
        if (idx != -1) {
          _logs[idx] = updated;
        }
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo guardar el registro.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.assignedStudent;
    final student = item.student;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(student.name),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.outline),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(student.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 6),
                  Text(student.company ?? 'Empresa no registrada', style: const TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _StatPill(label: 'Horas', value: '${item.totalHoursCompleted} / ${item.totalHoursRequired} h'),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _StatPill(label: 'Estado', value: item.status),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: item.progressPercentage,
                    minHeight: 9,
                    backgroundColor: AppColors.divider,
                    color: AppColors.primary,
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
                tabs: const [
                  Tab(text: 'Resumen'),
                  Tab(text: 'Registros'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildResumenTab(item),
                  _buildRegistrosTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResumenTab(EstudianteAsignadoModel item) {
    final student = item.student;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoTile(icon: Icons.business, title: 'Empresa', value: student.company ?? 'Sin empresa'),
          _InfoTile(icon: Icons.person, title: 'Tutor empresarial', value: '${item.companyTutorName} ${item.companyTutorPhone.isNotEmpty ? '(${item.companyTutorPhone})' : ''}'),
          _InfoTile(icon: Icons.note_alt_outlined, title: 'Última actividad', value: item.lastActivityDescription ?? 'Sin actividad registrada'),
          _InfoTile(icon: Icons.calendar_today, title: 'Última fecha', value: item.lastActivityDate ?? 'Sin registro'),
        ],
      ),
    );
  }

  Widget _buildRegistrosTab() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }

    if (_logs.isEmpty) {
      return const Center(
        child: Text('Sin registros de práctica.', style: TextStyle(color: AppColors.textSecondary)),
      );
    }

    return ListView.builder(
      itemCount: _logs.length,
      itemBuilder: (context, index) {
        final log = _logs[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            title: Text('${log.date} • ${log.entryTimeLabel}'),
            subtitle: Text(log.activityDescription),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  _editLog(log);
                } else if (value == 'toggle') {
                  _toggleLogStatus(log);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'edit', child: Text('Editar')),
                PopupMenuItem(value: 'toggle', child: Text(log.isActive ? 'Desactivar' : 'Activar')),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StatPill extends StatelessWidget {
  final String label;
  final String value;

  const _StatPill({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.infoSoft,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoTile({required this.icon, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.outline),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}