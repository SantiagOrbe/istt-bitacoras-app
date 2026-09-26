import 'package:bitacoras_app/features/admin/admin.dart';

class ItemMenuModel {
  final IconData icon;
  final String title;
  final String route;
  final bool enabled;

  const ItemMenuModel({
    required this.icon,
    required this.title,
    required this.route,
    this.enabled = true,
  });

  ItemMenuModel copyWith({
    IconData? icon,
    String? title,
    String? route,
    bool? enabled,
  }) {
    return ItemMenuModel(
      icon: icon ?? this.icon,
      title: title ?? this.title,
      route: route ?? this.route,
      enabled: enabled ?? this.enabled,
    );
  }

  ItemMenuModel copiarCon({
    IconData? icono,
    String? titulo,
    String? ruta,
    bool? habilitado,
  }) {
    return ItemMenuModel(
      icon: icono ?? icon,
      title: titulo ?? title,
      route: ruta ?? route,
      enabled: habilitado ?? enabled,
    );
  }
}

class SeccionMenuModel {
  final String? title;
  final List<ItemMenuModel> items;

  const SeccionMenuModel({this.title, required this.items});

  SeccionMenuModel copyWith({
    String? title,
    List<ItemMenuModel>? items,
  }) {
    return SeccionMenuModel(
      title: title ?? this.title,
      items: items ?? this.items,
    );
  }

  SeccionMenuModel copiarCon({
    String? titulo,
    List<ItemMenuModel>? elementos,
  }) {
    return SeccionMenuModel(
      title: titulo ?? title,
      items: elementos ?? items,
    );
  }
}

typedef ItemMenuModelo = ItemMenuModel;
typedef SeccionMenuModelo = SeccionMenuModel;

extension ItemMenuModelEspanol on ItemMenuModel {
  IconData get icono => icon;
  String get titulo => title;
  String get ruta => route;
  bool get habilitado => enabled;

  ItemMenuModel conTitulo(String nuevoTitulo) => copyWith(title: nuevoTitulo);
  ItemMenuModel conRuta(String nuevaRuta) => copyWith(route: nuevaRuta);
  ItemMenuModel conHabilitado(bool nuevoEstado) =>
      copyWith(enabled: nuevoEstado);
}

extension SeccionMenuModelEspanol on SeccionMenuModel {
  String? get tituloSeccion => title;
  List<ItemMenuModel> get elementos => items;

  SeccionMenuModel conTitulo(String nuevoTitulo) => copyWith(title: nuevoTitulo);
  SeccionMenuModel conElementos(List<ItemMenuModel> nuevosItems) =>
      copyWith(items: nuevosItems);
}
