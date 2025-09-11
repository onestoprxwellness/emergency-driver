import 'package:flutter/material.dart';
import 'package:onestoprx_driver/util/image_constant.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../util/size_utils.dart';
import '../widgets/custom_image_view.dart';

enum AppInputType {
  text,
  email,
  phone,
  dropdown,
}

class AppInputField extends StatefulWidget {
  final String label;
  final String hintText;
  final String? prefixIconPath;
  final String? suffixIconPath;
  final AppInputType inputType;
  final TextEditingController? controller;
  final bool enabled;
  final bool showDropdownArrow;
  final VoidCallback? onTap;
  final VoidCallback? onSuffixIconTap;
  final Function(String)? onChanged;
  final TextInputType? keyboardType;
  final Widget? prefix; // For custom prefix like phone country selector
  final EdgeInsetsGeometry? margin;

  const AppInputField({
    Key? key,
    required this.label,
    required this.hintText,
    this.prefixIconPath,
    this.suffixIconPath,
    this.inputType = AppInputType.text,
    this.controller,
    this.enabled = true,
    this.showDropdownArrow = false,
    this.onTap,
    this.onSuffixIconTap,
    this.onChanged,
    this.keyboardType,
    this.prefix,
    this.margin,
  }) : super(key: key);

  @override
  State<AppInputField> createState() => _AppInputFieldState();
}

class _AppInputFieldState extends State<AppInputField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin ?? EdgeInsets.only(bottom: 16.v),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Text(
            widget.label,
            style: AppTextStyles.labelMedium.copyWith(
              fontSize: 12.fSize,
              color: AppColors.textSecondary,
            ),
          ),
          
          SizedBox(height: 8.v),
          
          // Input container
          GestureDetector(
            onTap: widget.inputType == AppInputType.dropdown ? widget.onTap : null,
            child: Container(
              child: Column(
                children: [
                  // Main input row
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 12.v),
                    child: Row(
                      children: [
                        // Prefix icon
                        if (widget.prefixIconPath != null) ...[
                          CustomImageView(
                            imagePath: widget.prefixIconPath!,
                            height: 18.adaptSize,
                            width: 18.adaptSize,
                            color: _isFocused ? AppColors.primary : AppColors.gray400,
                          ),
                          SizedBox(width: 8.h),
                        ],
                        
                        // Custom prefix (like phone country selector)
                        if (widget.prefix != null) ...[
                          widget.prefix!,
                          SizedBox(width: 12.h),
                          Container(
                            width: 1.h,
                            height: 16.v,
                            color: AppColors.gray400,
                          ),
                          SizedBox(width: 12.h),
                        ],
                        
                        // Text field or dropdown display
                        Expanded(
                          child: widget.inputType == AppInputType.dropdown
                            ? Text(
                                widget.hintText,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              )
                            : TextField(
                                controller: widget.controller,
                                focusNode: _focusNode,
                                enabled: widget.enabled,
                                onChanged: widget.onChanged,
                                keyboardType: widget.keyboardType ?? _getKeyboardType(),
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                                decoration: InputDecoration(
                                  hintText: widget.hintText,
                                  hintStyle: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                        ),
                        
                        // Suffix icon or dropdown arrow
                        if (widget.showDropdownArrow || widget.suffixIconPath != null) ...[
                          SizedBox(width: 8.h),
                          GestureDetector(
                            onTap: widget.onSuffixIconTap,
                            child: CustomImageView(
                              imagePath: widget.showDropdownArrow 
                                ? ImageConstant.arrowdown2 
                                : widget.suffixIconPath!,
                              height: 18.adaptSize,
                              width: 18.adaptSize,
                              color: _isFocused ? AppColors.primary : AppColors.gray400,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  
                  // Bottom border
                  Container(
                    height: 1.v,
                    decoration: BoxDecoration(
                      color: _isFocused ? AppColors.primary : AppColors.gray400,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextInputType? _getKeyboardType() {
    switch (widget.inputType) {
      case AppInputType.email:
        return TextInputType.emailAddress;
      case AppInputType.phone:
        return TextInputType.phone;
      default:
        return TextInputType.text;
    }
  }
}
