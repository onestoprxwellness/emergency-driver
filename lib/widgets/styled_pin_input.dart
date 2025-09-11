import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import '../core/theme/app_colors.dart';

class StyledPinInput extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onCompleted;

  const StyledPinInput({
    Key? key,
    required this.controller,
    required this.onCompleted,
  }) : super(key: key);

  double pageWidth(BuildContext context) => MediaQuery.of(context).size.width;
  double pageHeight(BuildContext context) => MediaQuery.of(context).size.height;

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: pageWidth(context) * 0.65,
      height: pageHeight(context) * 0.06,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: AppColors.brandBlue.withOpacity(0.3),
          width: 1,
        ),
      ),
      textStyle: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        fontFamily: 'PlusJakartaSans'
      ),
    );

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Pinput(
        controller: controller,
        length: 6,
        defaultPinTheme: defaultPinTheme,
        separatorBuilder: (index) {
          if (index == 2) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Container(
                width: 12,
                height: 2,
                margin: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            );
          }
          return const SizedBox(width: 8);
        },
        onCompleted: onCompleted,
        focusedPinTheme: defaultPinTheme.copyWith(
          decoration: defaultPinTheme.decoration!.copyWith(
            border: Border.all(
              color: AppColors.brandBlue,
              width: 2,
            ),
          ),
        ),
        submittedPinTheme: defaultPinTheme.copyWith(
          decoration: defaultPinTheme.decoration!.copyWith(
            border: Border.all(
              color: AppColors.brandBlue,
              width: 1,
            ),
          ),
        ),
        errorPinTheme: defaultPinTheme.copyWith(
          decoration: defaultPinTheme.decoration!.copyWith(
            border: Border.all(
              color: Colors.red.shade300,
              width: 1,
            ),
          ),
        ),
        crossAxisAlignment: CrossAxisAlignment.center,
        pinAnimationType: PinAnimationType.fade,
        cursor: Container(
          width: 2,
          height: 20,
          margin: const EdgeInsets.only(bottom: 6),
          decoration: BoxDecoration(
            color: AppColors.brandBlue.withOpacity(0.7),
            borderRadius: BorderRadius.circular(1),
          ),
        ),
      ),
    );
  }
}
