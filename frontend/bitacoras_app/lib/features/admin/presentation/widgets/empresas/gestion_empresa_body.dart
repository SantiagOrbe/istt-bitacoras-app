import 'package:bitacoras_app/features/admin/admin.dart';

class GestionEmpresaBody extends StatelessWidget {
  final bool isLoading;
  final List<EmpresaModel> empresas;
  final String searchQuery;
  final bool? filterState;
  final Future<void> Function() onRefresh;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<bool?> onFilterChanged;
  final Future<void> Function(EmpresaModel) onOpenDetail;
  final Future<void> Function({EmpresaModel? empresa}) onOpenForm;

  const GestionEmpresaBody({
    super.key,
    required this.isLoading,
    required this.empresas,
    required this.searchQuery,
    required this.filterState,
    required this.onRefresh,
    required this.onSearchChanged,
    required this.onFilterChanged,
    required this.onOpenDetail,
    required this.onOpenForm,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppTamanos.md,
        AppTamanos.sm,
        AppTamanos.md,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CabeceraListadoEmpresas(
            total: empresas.length,
            alBuscar: onSearchChanged,
            filtroEstado: filterState,
            alFiltrar: onFilterChanged,
          ),
          AppTamanos.gapV16,
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColores.primary),
                  )
                : empresas.isEmpty
                ? ListadoVacioEmpresa(filtroEstado: filterState)
                : RefreshIndicator(
                    onRefresh: onRefresh,
                    child: ListView.separated(
                      itemCount: empresas.length,
                      separatorBuilder: (context, index) => AppTamanos.gapV8,
                      itemBuilder: (context, index) {
                        final empresa = empresas[index];
                        return TarjetaEmpresa(
                          empresa: empresa,
                          alAbrir: () => onOpenDetail(empresa),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
