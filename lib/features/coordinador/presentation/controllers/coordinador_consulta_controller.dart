import 'package:flutter/material.dart';
import '../../domain/repositories/i_coordinador_repository.dart';

class CoordinadorConsultaController extends ChangeNotifier {
  final ICoordinadorRepository repository;

  List<Map<String, dynamic>> items = [];
  bool isLoading = false;

  CoordinadorConsultaController({required this.repository});

  Future<void> cargarEstudiantes() async {
    _setLoading(true);
    items = await repository.getEstudiantes();
    _setLoading(false);
  }

  Future<void> cargarCarreras() async {
    _setLoading(true);
    items = await repository.getCarreras();
    _setLoading(false);
  }

  Future<void> cargarTutores() async {
    _setLoading(true);
    items = await repository.getTutores();
    _setLoading(false);
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}