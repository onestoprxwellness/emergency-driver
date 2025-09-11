import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../util/size_utils.dart';

class RegistrationProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const RegistrationProgressIndicator({
    Key? key,
    required this.currentStep,
    this.totalSteps = 4,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.v),
      child: Row(
        children: List.generate(totalSteps, (index) {
          final stepNumber = index + 1;
          final isCompleted = stepNumber <= currentStep;
          
          return [
            Expanded(
              child: Container(
                height: 4.v,
                decoration: BoxDecoration(
                  color: isCompleted ? AppColors.brandBlue : AppColors.surface,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
            if (index < totalSteps - 1) SizedBox(width: 7.h),
          ];
        }).expand((element) => element).toList(),
      ),
    );
  }
}
