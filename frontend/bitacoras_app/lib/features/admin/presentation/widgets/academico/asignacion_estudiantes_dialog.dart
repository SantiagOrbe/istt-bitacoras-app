import 'package:bitacoras_app/features/admin/admin.dart';

class AsignacionEstudiantesDialog extends StatefulWidget {
  final List<Map<String, dynamic>> estudiantes;
  final Set<int> seleccionados;
  final String nombreParalelo;

  const AsignacionEstudiantesDialog({
    super.key,
    required this.estudiantes,
    required this.seleccionados,
    required this.nombreParalelo,
  });

  @override
  State<AsignacionEstudiantesDialog> createState() =>
      _AsignacionEstudiantesDialogState();
}

class _AsignacionEstudiantesDialogState
    extends State<AsignacionEstudiantesDialog> {
  final _controladorBusqueda = TextEditingController();
  late final Set<int> _seleccionados;

  @override
  void initState() {
    super.initState();
    _seleccionados = {...widget.seleccionados};
  }

  @override
  void dispose() {
    _controladorBusqueda.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final consulta = _controladorBusqueda.text.trim().toLowerCase();
    final visibles = widget.estudiantes.where((estudiante) {
      final texto =
          '${estudiante['nombre'] ?? ''} ${estudiante['email'] ?? ''} '
                  '${estudiante['cedula'] ?? ''}'
              .toLowerCase();
      return consulta.isEmpty || texto.contains(consulta);
    }).toList();
    final asignados = visibles
        .where((estudiante) => estudiante['seleccionado'] == true)
        .toList();
    final disponibles = visibles
        .where(
          (estudiante) =>
              estudiante['seleccionado'] != true &&
              estudiante['bloqueado'] != true,
        )
        .toList();
    final bloqueados = visibles
        .where((estudiante) => estudiante['bloqueado'] == true)
        .toList();

    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      title: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            ),
            child: const Icon(
              Icons.person_add_alt_1_outlined,
              color: AppColors.secondary,
            ),
          ),
          AppSizes.gapH12,
          Expanded(
            child: Text(
              'Asignar estudiantes\nParalelo ${widget.nombreParalelo}',
              style: AppTextStyles.title.copyWith(fontSize: 18),
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        height: MediaQuery.sizeOf(context).height * 0.52,
        child: Column(
          children: [
            BarraBusquedaPrisma(
              controlador: _controladorBusqueda,
              etiqueta: 'Buscar estudiantes',
              textoSugerido: 'Nombre, correo o cédula',
              alCambiar: (_) => setState(() {}),
            ),
            AppSizes.gapV12,
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${_seleccionados.length} seleccionados de ${widget.estudiantes.length}',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            AppSizes.gapV8,
            Expanded(
              child: visibles.isEmpty
                  ? const Center(child: Text('No hay estudiantes disponibles.'))
                  : ListView(
                      children: [
                        _EncabezadoAsignacion(
                          titulo: 'Ya pertenecen a este paralelo',
                          cantidad: asignados.length,
                          icono: Icons.check_circle_outline,
                        ),
                        if (asignados.isEmpty)
                          const _MensajeAsignacion(
                            texto: 'Todavía no hay estudiantes asignados.',
                          )
                        else
                          ...asignados.map(
                            (estudiante) => _tarjeta(estudiante),
                          ),
                        _EncabezadoAsignacion(
                          titulo: 'Estudiantes disponibles',
                          cantidad: disponibles.length,
                          icono: Icons.person_add_alt_1_outlined,
                        ),
                        if (disponibles.isEmpty)
                          const _MensajeAsignacion(
                            texto:
                                'No hay estudiantes disponibles para asignar.',
                          )
                        else
                          ...disponibles.map(
                            (estudiante) => _tarjeta(estudiante),
                          ),
                        if (bloqueados.isNotEmpty) ...[
                          _EncabezadoAsignacion(
                            titulo: 'Ya pertenecen a otro paralelo',
                            cantidad: bloqueados.length,
                            icono: Icons.lock_outline,
                          ),
                          ...bloqueados.map(
                            (estudiante) =>
                                _tarjeta(estudiante, bloqueado: true),
                          ),
                        ],
                      ],
                    ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        BotonPrisma(
          texto: 'Guardar asignación',
          icono: Icons.check_rounded,
          alPresionar: () => Navigator.pop(context, _seleccionados),
        ),
      ],
    );
  }

  Widget _tarjeta(Map<String, dynamic> estudiante, {bool bloqueado = false}) {
    final id = int.tryParse(estudiante['id']?.toString() ?? '');
    if (id == null) return const SizedBox.shrink();

    return EstudianteParaleloCard(
      student: estudiante,
      selected: _seleccionados.contains(id),
      blocked: bloqueado,
      onChanged: (valor) => setState(() {
        valor == true ? _seleccionados.add(id) : _seleccionados.remove(id);
      }),
    );
  }
}

class _EncabezadoAsignacion extends StatelessWidget {
  final String titulo;
  final int cantidad;
  final IconData icono;

  const _EncabezadoAsignacion({
    required this.titulo,
    required this.cantidad,
    required this.icono,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSizes.sm, bottom: AppSizes.xs),
      child: Row(
        children: [
          Icon(icono, size: 18, color: AppColors.primary),
          AppSizes.gapH8,
          Expanded(
            child: Text(
              '$titulo ($cantidad)',
              style: AppTextStyles.bodyBold.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MensajeAsignacion extends StatelessWidget {
  final String texto;

  const _MensajeAsignacion({required this.texto});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.sm),
      child: Text(
        texto,
        style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
      ),
    );
  }
}
