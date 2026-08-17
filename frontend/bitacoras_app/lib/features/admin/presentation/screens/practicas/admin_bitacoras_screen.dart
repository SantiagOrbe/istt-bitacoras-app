import 'package:bitacoras_app/app/apps.dart';
import '../../../data/repositories/fake_admin_repository.dart';
import '../../../domain/models/registro_practica_model.dart';

class AdminBitacorasScreen extends StatefulWidget {
  final UsuarioModel currentUser;

  const AdminBitacorasScreen({
    super.key,
    required this.currentUser,
  });

  @override
  State<AdminBitacorasScreen> createState() => _AdminBitacorasScreenState();
}

class _AdminBitacorasScreenState extends State<AdminBitacorasScreen> {
  final FakeAdminRepository _repository = FakeAdminRepository();
  List<RegistroPracticaModel> _logs = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchLogs();
  }

  Future<void> _fetchLogs() async {
    setState(() => _isLoading = true);
    final data = await _repository.getPracticeLogs();
    setState(() {
      _logs = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredLogs = _logs.where((log) {
      return log.studentName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             log.companyName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             log.activityDescription.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: InicioAppBar(user: widget.currentUser),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Auditoría y Bitácoras de Prácticas',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                hintText: 'Buscar por estudiante, empresa o actividad...',
                prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.divider),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.divider),
                ),
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                  : filteredLogs.isEmpty
                      ? const Center(child: Text('No hay registros de bitácoras encontrados.'))
                      : ListView.builder(
                          itemCount: filteredLogs.length,
                          itemBuilder: (context, index) {
                            final log = filteredLogs[index];
                            return _buildLogCard(log);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogCard(RegistroPracticaModel log) {
    Color statusColor;
    switch (log.status.toLowerCase()) {
      case 'aprobado':
        statusColor = AppColors.success;
        break;
      case 'rechazado':
        statusColor = AppColors.error;
        break;
      default:
        statusColor = Colors.orange;
    }

    return Card(
      elevation: 1.5,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    log.studentName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: statusColor, width: 1),
                  ),
                  child: Text(
                    log.status.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Empresa: ${log.companyName}',
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const Divider(height: 16),
            Row(
              children: [
                const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(log.date, style: const TextStyle(fontSize: 12)),
                const SizedBox(width: 16),
                const Icon(Icons.access_time, size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(
                  '${log.entryTime} - ${log.exitTime ?? 'En curso'}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              log.activityDescription,
              style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}