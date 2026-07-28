import 'package:flutter/material.dart';

class QuickAction {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const QuickAction({
    required this.title,
    required this.icon,
    required this.onTap,
  });
}