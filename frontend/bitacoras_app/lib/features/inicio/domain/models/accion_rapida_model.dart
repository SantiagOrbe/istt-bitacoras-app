import 'package:flutter/material.dart';

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
}