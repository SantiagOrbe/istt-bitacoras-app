import 'package:bitacoras_app/app/auth_session.dart';
import 'package:bitacoras_app/core/widgets/location_checker_wrapper.dart';
import 'package:bitacoras_app/features/inicio/data/repositories/fake_tablero_repository.dart';
import 'package:bitacoras_app/features/inicio/data/repositories/fake_usuario_repository.dart';
import 'package:bitacoras_app/features/inicio/domain/models/usuario_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bitacoras_app/features/tutores/data/opciones_drawer_tutor.dart';
import 'package:bitacoras_app/features/tutores/data/repositories/fake_tutor_repository.dart';
import 'package:bitacoras_app/features/tutores/domain/models/estado_visita_tutor_model.dart';
import 'package:bitacoras_app/features/admin/domain/models/item_menu_model.dart';
import 'package:bitacoras_app/app/routes/app_routes.dart';
import '../inicio_screen.dart';

class InicioTutorAcademicoScreen extends StatefulWidget {
  final UsuarioModel? user;
  final String? refreshToken;

  const InicioTutorAcademicoScreen({super.key, this.user, this.refreshToken});

  @override
  State<InicioTutorAcademicoScreen> createState() => _InicioTutorAcademicoScreenState();
}

class _InicioTutorAcademicoScreenState extends State<InicioTutorAcademicoScreen> {
  EstadoVisitaTutorModel _visit = const EstadoVisitaTutorModel();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadVisitState();
  }

  @override
  void didUpdateWidget(covariant InicioTutorAcademicoScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.refreshToken != widget.refreshToken) {
      _loadVisitState();
    }
  }

  Future<void> _loadVisitState() async {
    try {
      final visit = await FakeTutorRepository().getTodayVisitStatus();
      if (!mounted) return;
      setState(() {
        _visit = visit;
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = widget.user ?? context.read<AuthSession>().currentUser ?? FakeUsuarioRepository.academicTutor;
    final baseActions = FakeTableroRepository().academicTutorActions();
    final actions = baseActions.map((action) {
      if (action.route == AppRoutes.academicTutorRegisterVisit) {
        return action.copyWith(enabled: !_loading && _visit.puedeRegistrarEntrada);
      }
      if (action.route == AppRoutes.academicTutorRegisterDeparture) {
        return action.copyWith(enabled: !_loading && _visit.puedeRegistrarSalida);
      }
      if (action.route == AppRoutes.academicTutorActivities) {
        return action.copyWith(enabled: !_loading && _visit.puedeRegistrarActividades);
      }
      return action;
    }).toList();
    final drawerSections = getOpcionesDrawerTutorAcademico().map((section) {
      return SeccionMenuModel(
        title: section.title,
        items: section.items.map((item) {
          if (item.route == AppRoutes.academicTutorRegisterVisit) {
            return ItemMenuModel(icon: item.icon, title: item.title, route: item.route, enabled: !_loading && _visit.puedeRegistrarEntrada);
          }
          if (item.route == AppRoutes.academicTutorRegisterDeparture) {
            return ItemMenuModel(icon: item.icon, title: item.title, route: item.route, enabled: !_loading && _visit.puedeRegistrarSalida);
          }
          if (item.route == AppRoutes.academicTutorActivities) {
            return ItemMenuModel(icon: item.icon, title: item.title, route: item.route, enabled: !_loading && _visit.puedeRegistrarActividades);
          }
          return item;
        }).toList(),
      );
    }).toList();

    return LocationCheckerWrapper(
      child: InicioScreen(
        user: currentUser,
        actions: actions,
        drawerSections: drawerSections,
      ),
    );
  }
}