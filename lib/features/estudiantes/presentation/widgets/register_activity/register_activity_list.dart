import 'package:bitacoras_app/features/estudiantes/attendance.dart';
import 'package:flutter/material.dart';
import 'package:bitacoras_app/shared/exports.dart';

class RegisterActivityList extends StatelessWidget {
  final List<TextEditingController> controllers;
  final ValueChanged<int> onRemove;

  const RegisterActivityList({
    super.key,
    required this.controllers,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controllers.length,
      separatorBuilder: (context, index) => AppSizes.gapV16,
      itemBuilder: (context, index) {
        return ActivityInputCard(
          index: index,
          controller: controllers[index],
          canRemove: controllers.length > 1,
          onRemove: () => onRemove(index),
        );
      },
    );
  }
}