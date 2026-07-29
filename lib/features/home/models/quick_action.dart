import 'package:flutter/material.dart';

class QuickAction {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;

  const QuickAction({
    required this.title,
    required this.icon,
    required this.onTap,
    this.enabled = true,
  });
}