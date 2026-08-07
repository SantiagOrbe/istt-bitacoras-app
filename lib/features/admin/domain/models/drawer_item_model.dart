import 'package:flutter/material.dart';

class DrawerItemModel {
  final IconData icon;
  final String title;
  final String route;

  const DrawerItemModel({
    required this.icon,
    required this.title,
    required this.route,
  });
}

class DrawerSectionModel {
  final String? title;
  final List<DrawerItemModel> items;

  const DrawerSectionModel({
    this.title,
    required this.items,
  });
}