import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class DashboardEarnings extends StatelessWidget {
  const DashboardEarnings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: const Center(
        child: Text(
          'Earnings',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
