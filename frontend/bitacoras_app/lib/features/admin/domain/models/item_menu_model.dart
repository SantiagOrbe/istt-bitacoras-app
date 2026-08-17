import 'package:flutter/material.dart';

class ItemMenuModel {
  final IconData icon;
  final String title;
  final String route;

  const ItemMenuModel({
    required this.icon,
    required this.title,
    required this.route,
  });
}

class SeccionMenuModel {
  final String? title;
  final List<ItemMenuModel> items;

  const SeccionMenuModel({
    this.title,
    required this.items,
  });
}