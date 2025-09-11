import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../util/size_utils.dart';

class AppEmailInputField extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final EdgeInsetsGeometry? margin;
  final String? prefixIconPath;

  const AppEmailInputField({
    Key? key,
    required this.label,
    required this.hintText,
    this.controller,
    this.onChanged,
    this.validator,
    this.margin,
    this.prefixIconPath,
  }) : super(key: key);

  @override
  State<AppEmailInputField> createState() => _AppEmailInputFieldState();
}

class _AppEmailInputFieldState extends State<AppEmailInputField> {
  final double prefixSize = 18.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin ?? EdgeInsets.only(bottom: 16.v),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.prefixIconPath != null) ...[
            Padding(
              padding: EdgeInsets.only(top: 18.v),
              child: SvgPicture.asset(
                widget.prefixIconPath!,
                height: prefixSize,
                width: prefixSize,
              ),
            ),
            // SizedBox(width: 12.h),
          ],
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    widget.label,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                
                // Reduced spacing between label and TextFormField
                SizedBox(height: 4.v), // Add this line to control the spacing
                
                TextFormField(
                  controller: widget.controller,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  onChanged: widget.onChanged,
                  validator: widget.validator ?? _defaultEmailValidator,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.grey,
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.brandBlue.withOpacity(0.3),
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.brandBlue.withOpacity(0.8),
                      ),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.brandBlue.withOpacity(0.3),
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.h,
                      vertical: 8.v, // Reduced from 12.v to 8.v
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

  String? _defaultEmailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email address';
    }
    
    // Email regex pattern
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }
}