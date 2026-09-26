import 'package:flutter/material.dart';

/// Modelo de una acción rápida del tablero principal.
class AccionRapidaModel {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color? iconBackgroundColor;
  final String? route;
  final VoidCallback onTap;
  final bool enabled;

  const AccionRapidaModel({
    required this.title,
    this.subtitle,
    required this.icon,
    this.iconBackgroundColor,
    this.route,
    required this.onTap,
    this.enabled = true,
  });

  AccionRapidaModel copyWith({bool? enabled, String? route}) {
    return AccionRapidaModel(
      title: title,
      subtitle: subtitle,
      icon: icon,
      iconBackgroundColor: iconBackgroundColor,
      route: route ?? this.route,
      onTap: onTap,
      enabled: enabled ?? this.enabled,
    );
  }

  /// Alias en español para la copia.
  AccionRapidaModel copiarCon({bool? enabled, String? route}) =>
      copyWith(enabled: enabled, route: route);

  /// Alias en español para la propiedad principal.
  String get titulo => title;

  /// Alias en español para la descripción secundaria.
  String? get subtitulo => subtitle;

  /// Alias en español para la ruta.
  String? get ruta => route;

  /// Alias en español para el ícono.
  IconData get icono => icon;

  /// Alias en español para el estado habilitado.
  bool get habilitado => enabled;
}

typedef AccionRapida = AccionRapidaModel;