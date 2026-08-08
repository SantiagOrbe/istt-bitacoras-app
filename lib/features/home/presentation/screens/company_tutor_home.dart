import 'package:bitacoras_app/core/widgets/location_checker_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:bitacoras_app/features/home/data/repositories/fake_dashboard_repository.dart';
import 'package:bitacoras_app/features/home/data/repositories/fake_user_repository.dart';
import 'home_page.dart';

class CompanyTutorHome extends StatelessWidget {
  const CompanyTutorHome({super.key});

  @override
  Widget build(BuildContext context) {
    return LocationCheckerWrapper(
      child: HomePage(
        user: FakeUserRepository.companyTutor,
        actions: FakeDashboardRepository().companyTutorActions(),
      ),
    );
  }
}