import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../config/constants/app_colors.dart';
import '../../../domain/models/empresa_model.dart';
import '../../controllers/gestion_empresa_controller.dart';
import 'formulario_empresa_campos.dart';
import 'formulario_empresa_header.dart';
import 'mapa_empresa_selector.dart';

class FormularioEmpresaBody extends StatefulWidget {
  final EmpresaModel? company;
  final GestionEmpresaController controller;

  const FormularioEmpresaBody({super.key, this.company, required this.controller});

  @override
  State<FormularioEmpresaBody> createState() => _FormularioEmpresaBodyState();
}

class _FormularioEmpresaBodyState extends State<FormularioEmpresaBody> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  bool _isSaving = false;
  late double _latitude;
  late double _longitude;
  late double _radius;

  @override
  void initState() {
    super.initState();
    final c = widget.company;
    _latitude = c?.latitude ?? -0.1807;
    _longitude = c?.longitude ?? -78.4834;
    _radius = c?.allowedRadius ?? 50;

    _controllers['name'] = TextEditingController(text: c?.name ?? '');
    _controllers['ruc'] = TextEditingController(text: c?.ruc ?? '');
    _controllers['address'] = TextEditingController(text: c?.address ?? '');
    _controllers['phone'] = TextEditingController(text: c?.phone ?? '');
    _controllers['email'] = TextEditingController(text: c?.email ?? '');
    _controllers['rep'] = TextEditingController(text: c?.legalRepresentative ?? '');
    _controllers['agreement'] = TextEditingController(text: c?.agreementNumber ?? '');
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final company = EmpresaModel(
      id: widget.company?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: _controllers['name']!.text.trim(),
      ruc: _controllers['ruc']!.text.trim(),
      address: _controllers['address']!.text.trim(),
      phone: _controllers['phone']!.text.trim(),
      email: _controllers['email']!.text.trim(),
      legalRepresentative: _controllers['rep']!.text.trim(),
      agreementNumber: _controllers['agreement']!.text.trim(),
      latitude: _latitude,
      longitude: _longitude,
      allowedRadius: _radius,
      isActive: widget.company?.isActive ?? true,
    );

    final success = await widget.controller.saveCompany(company);
    if (mounted) {
      setState(() => _isSaving = false);
      if (success) context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.company != null;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FormularioEmpresaHeader(isEditing: isEditing),
          const SizedBox(height: 16),
          FormularioEmpresaCampos(controllers: _controllers),
          const SizedBox(height: 16),
          MapaEmpresaSelector(
            initialLatitude: _latitude,
            initialLongitude: _longitude,
            initialRadius: _radius,
            onLocationChanged: (lat, lng) {
              setState(() {
                _latitude = lat;
                _longitude = lng;
              });
            },
            onRadiusChanged: (radius) {
              setState(() => _radius = radius);
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _isSaving ? null : _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: _isSaving
                ? const CircularProgressIndicator(color: AppColors.surface)
                : Text(
                    isEditing ? 'Guardar Cambios' : 'Registrar Empresa',
                    style: const TextStyle(color: AppColors.surface),
                  ),
          ),
        ],
      ),
    );
  }
}