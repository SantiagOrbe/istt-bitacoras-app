import 'package:bitacoras_app/core/widgets/location_checker_wrapper.dart';

import 'package:intl/intl.dart';
import '../../../../../app/apps.dart';

import '../../../data/repositories/fake_tutor_repository.dart';
import '../../../domain/models/visita_academica_model.dart';
import '../../../domain/models/estudiante_asignado_model.dart';

class RegistroVisitaScreen extends StatefulWidget {
  final UsuarioModel currentUser;

  const RegistroVisitaScreen({super.key, required this.currentUser});

  @override
  State<RegistroVisitaScreen> createState() => _RegistroVisitaScreenState();
}

class _RegistroVisitaScreenState extends State<RegistroVisitaScreen> {
  final FakeTutorRepository _repo = FakeTutorRepository();
  EstudianteAsignadoModel? _selectedStudent;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final list = await _repo.getAssignedStudents(widget.currentUser.id, isAcademic: true);
    setState(() {
      if (list.isNotEmpty) _selectedStudent = list.first;
      _isLoading = false;
    });
  }

  void _confirmArrival() {
  // Si no hay estudiante seleccionado de la lista, creamos una instancia por defecto
  // para no bloquear la prueba del flujo de registro de la visita.
  final studentName = _selectedStudent?.student.name ?? 'Estudiante Asignado';
  final companyName = _selectedStudent?.student.company ?? 'Municipio Tena';
  final companyTutor = _selectedStudent?.companyTutorName ?? 'Tutor Empresarial';
  final careerName = _selectedStudent?.student.careerName ?? 'Desarrollo de Software';
  final studentId = _selectedStudent?.student.id ?? '1';

  final now = DateTime.now();
  final visit = VisitaAcademicaModel(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
    studentId: studentId,
    studentName: studentName,
    companyName: companyName,
    companyTutorName: companyTutor,
    career: careerName,
    date: DateFormat('yyyy-MM-dd').format(now),
    arrivalTime: DateFormat('hh:mm a').format(now),
    status: 'En Curso',
  );

  // Navegación directa garantizada al formulario de actividades
  context.push(AppRoutes.visitActivityForm, extra: visit);
}

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return LocationCheckerWrapper(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: InicioAppBar(user: widget.currentUser),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Registrar Entrada',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                    const SizedBox(height: 16),
                    
                    // Tarjeta HORA / FECHA
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: AppColors.divider.withOpacity(0.5)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            const Icon(Icons.access_time_rounded, color: AppColors.primary, size: 28),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('HORA', style: TextStyle(fontSize: 10, color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
                                Text(DateFormat('hh:mm a').format(now), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const Spacer(),
                            Container(width: 1, height: 30, color: AppColors.divider),
                            const Spacer(),
                            const Icon(Icons.calendar_month_rounded, color: AppColors.primary, size: 28),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('FECHA', style: TextStyle(fontSize: 10, color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
                                Text(DateFormat('yyyy-MM-dd').format(now), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Card Mapa y GPS Status
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: const Color(0xFFC8E6C9),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Stack(
                        children: [
                          const Center(child: Icon(Icons.location_on, color: AppColors.primary, size: 40)),
                          Positioned(
                            right: 12,
                            bottom: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.explore_outlined, size: 14, color: AppColors.primary),
                                  SizedBox(width: 4),
                                  Text('GPS Activo', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Indicador de Rango
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F8E9),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFAED581)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.location_on, color: Color(0xFF689F38)),
                          SizedBox(width: 8),
                          Text('Dentro del rango permitido', style: TextStyle(color: Color(0xFF33691E), fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Empresa / Lugar Precargado
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: AppColors.divider.withOpacity(0.5)),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.business, color: AppColors.primary),
                        title: Text(_selectedStudent?.student.company ?? 'Municipio Tena', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Estudiante: ${_selectedStudent?.student.name ?? ""}'),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Botón Confirmar Entrada
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.login_rounded, color: Colors.white),
                        label: const Text('Confirmar Entrada', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        onPressed: _confirmArrival,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Botón Cancelar
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () => context.pop(),
                        child: const Text('Cancelar', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}