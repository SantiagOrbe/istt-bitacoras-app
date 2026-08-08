import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/constants/app_colors.dart';
import '../../../home/data/repositories/fake_user_repository.dart';
import '../../../home/presentation/widgets/home_app_bar.dart';
import '../../domain/models/company_model.dart';
import '../controllers/company_management_controller.dart';
import '../widgets/company_form_body.dart';

class CompanyFormScreen extends StatelessWidget {
  final CompanyModel? company;
  final CompanyManagementController controller;

  const CompanyFormScreen({super.key, this.company, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: HomeAppBar(
        user: FakeUserRepository.practiceManager,
        showBackButton: true,
        showDrawerButton: false,
        onBackPressed: () => context.pop(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: CompanyFormBody(company: company, controller: controller),
      ),
    );
  }
}