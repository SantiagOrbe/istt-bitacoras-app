import 'package:bitacoras_app/features/home/data/repositories/fake_dashboard_repository.dart';
import 'package:bitacoras_app/features/home/data/repositories/fake_user_repository.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

class CoordinatorHome extends StatelessWidget {
  const CoordinatorHome({super.key});

  @override
  Widget build(BuildContext context) {
    return HomePage(
      user: FakeUserRepository.coordinator,
      actions: FakeDashboardRepository.coordinatorActions(),
    );
  }
}