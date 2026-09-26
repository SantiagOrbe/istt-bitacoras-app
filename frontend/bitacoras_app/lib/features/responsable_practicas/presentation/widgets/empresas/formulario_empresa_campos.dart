import 'package:bitacoras_app/features/responsable_practicas/responsable_practicas.dart';


class FormularioEmpresaCampos extends StatelessWidget {
  final Map<String, TextEditingController> controllers;

  const FormularioEmpresaCampos({super.key, required this.controllers});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColores.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColores.outline),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _input(controllers['name']!, 'Razón Social', Icons.business_rounded),
            const SizedBox(height: 12),
            _input(controllers['ruc']!, 'RUC', Icons.badge_outlined, isNum: true),
            const SizedBox(height: 12),
            _selectCanton(controllers['canton']!),
            const SizedBox(height: 12),
            _input(controllers['agreement']!, 'Número de Convenio', Icons.assignment_outlined),
            const SizedBox(height: 12),
            _input(controllers['rep']!, 'Representante Legal', Icons.person_outline_rounded),
            const SizedBox(height: 12),
            _input(controllers['address']!, 'Dirección', Icons.location_on_outlined),
            const SizedBox(height: 12),
            _input(controllers['phone']!, 'Teléfono', Icons.phone_outlined, isNum: true),
            const SizedBox(height: 12),
            _input(controllers['email']!, 'Correo', Icons.email_outlined),
          ],
        ),
      ),
    );
  }

  Widget _input(TextEditingController ctrl, String label, IconData icon, {bool isNum = false}) {
    return TextFormField(
      controller: ctrl,
      keyboardType: isNum ? TextInputType.number : TextInputType.text,
      style: const TextStyle(color: AppColores.textPrimary, fontSize: 14),
      validator: (v) => v == null || v.trim().isEmpty ? 'Campo requerido' : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColores.primary, size: 20),
        filled: true,
        fillColor: AppColores.background,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _selectCanton(TextEditingController ctrl) {
    const opciones = [
      'El Chaco',
      'Quijos',
      'Archidona',
      'Tena',
      'Arosemena Tola',
    ];

    return DropdownButtonFormField<String>(
      initialValue: ctrl.text.isEmpty ? null : ctrl.text,
      isExpanded: true,
      validator: (value) =>
          (value == null || value.trim().isEmpty) ? 'Campo requerido' : null,
      decoration: InputDecoration(
        labelText: 'Cantón',
        prefixIcon: const Icon(Icons.location_city_outlined, color: AppColores.primary, size: 20),
        filled: true,
        fillColor: AppColores.background,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      items: opciones
          .map(
            (canton) => DropdownMenuItem<String>(
              value: canton,
              child: Text(
                canton,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          )
          .toList(),
      onChanged: (value) {
        if (value != null) {
          ctrl.text = value;
        }
      },
    );
  }
}