import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

class CustomInputField extends StatelessWidget {
  final String label;
  final String hintText;
  final String? prefixIcon;
  final String? suffixIcon;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final EdgeInsetsGeometry? margin;
  final bool enabled;
  final VoidCallback? onTap;

  const CustomInputField({
    Key? key,
    required this.label,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.onChanged,
    this.margin,
    this.enabled = true,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (prefixIcon != null)
                SvgPicture.asset(
                  prefixIcon!,
                  width: 18,
                  height: 18,
                  // colorFilter: ColorFilter.mode(
                  //   AppColors.gray400,
                  //   BlendMode.srcIn,
                  // ),
                ),
              if (prefixIcon != null) const SizedBox(width: 8),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                        fontFamily: "InterMedium",
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: controller,
                            enabled: enabled,
                            readOnly: !enabled,
                            onTap: onTap,
                            decoration: InputDecoration(
                              hintText: hintText,
                              hintStyle: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                                fontFamily: "InterRegular",
                              ),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              isDense: true,
                            ),
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: enabled ? AppColors.textPrimary : AppColors.textSecondary,
                            ),
                            onChanged: onChanged,
                          ),
                        ),
                        if (suffixIcon != null) ...[
                          const SizedBox(width: 8),
                          SvgPicture.asset(
                            suffixIcon!,
                            width: 18,
                            height: 18,
                            // colorFilter: ColorFilter.mode(
                            //   AppColors.gray400,
                            //   BlendMode.srcIn,
                            // ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 1,
            width: double.infinity,
            color: AppColors.gray400,
          ),
        ],
      ),
    );
  }
}
