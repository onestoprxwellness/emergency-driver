import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../util/size_utils.dart';

class AppCityInputField extends StatefulWidget {
  final String label;
  final String hintText;
  final String? prefixIconPath;
  final TextEditingController? controller;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;

  const AppCityInputField({
    Key? key,
    required this.label,
    required this.hintText,
    this.prefixIconPath,
    this.controller,
    this.onTap,
    this.margin,
    this.validator,
    this.onChanged,
  }) : super(key: key);

  @override
  State<AppCityInputField> createState() => _AppCityInputFieldState();
}

class _AppCityInputFieldState extends State<AppCityInputField> {
  final double prefixSize = 18.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin ?? EdgeInsets.only(bottom: 16.v),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon on the left
          if (widget.prefixIconPath != null) ...[
            Padding(
              padding: EdgeInsets.only(top: 18.v), // Adjust to align with input field
              child: SvgPicture.asset(
                widget.prefixIconPath!,
                height: prefixSize,
                width: prefixSize,
              ),
            ),
            // SizedBox(width: 12.h),
          ],
          
          // Column with label and input field
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    widget.label,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                
                3.hh,
                
                // City Input Field (Dropdown style)
                GestureDetector(
                  onTap: widget.onTap,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: AppColors.brandBlue.withOpacity(0.3),
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: TextFormField(
                      controller: widget.controller,
                      enabled: false, // Make it read-only since it's a dropdown
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: widget.hintText,
                        hintStyle: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.grey,
                        ),
                        suffixIcon: Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.textSecondary,
                          size: 20.h,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12.h,
                          vertical: 12.v,
                        ),
                      ),
                      validator: widget.validator,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
