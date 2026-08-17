import 'package:flutter/material.dart';

class AccionRapidaModel {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color? iconBackgroundColor;
  final String? route;
  final VoidCallback onTap;

  const AccionRapidaModel({
    required this.title,
    this.subtitle,
    required this.icon,
    this.iconBackgroundColor,
    this.route,
    required this.onTap,
  });
}