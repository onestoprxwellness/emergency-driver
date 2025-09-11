import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../util/size_utils.dart';

enum AppButtonType {
  primary,
  secondary,
  tertiary,
}

enum AppButtonSize {
  small,
  medium,
  large,
}

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final AppButtonSize size;
  final Widget? leftIcon;
  final Widget? rightIcon;
  final bool isLoading;
  final bool isDisabled;
  final double? width;
  final EdgeInsetsGeometry? margin;

  const AppButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.size = AppButtonSize.medium,
    this.leftIcon,
    this.rightIcon,
    this.isLoading = false,
    this.isDisabled = false,
    this.width,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      margin: margin ?? EdgeInsets.zero,
      child: _buildButton(),
    );
  }

  Widget _buildButton() {
    switch (type) {
      case AppButtonType.primary:
        return _buildPrimaryButton();
      case AppButtonType.secondary:
        return _buildSecondaryButton();
      case AppButtonType.tertiary:
        return _buildTertiaryButton();
    }
  }

  Widget _buildPrimaryButton() {
    return ElevatedButton(
      onPressed: isDisabled || isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonPrimary,
        foregroundColor: AppColors.textOnPrimary,
        disabledBackgroundColor: AppColors.gray400,
        disabledForegroundColor: AppColors.white,
        padding: _getPadding(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1000),
        ),
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
      child: _buildButtonContent(),
    );
  }

  Widget _buildSecondaryButton() {
    return ElevatedButton(
      onPressed: isDisabled || isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonSecondary,
        foregroundColor: AppColors.buttonSecondaryText,
        disabledBackgroundColor: AppColors.gray400.withOpacity(0.1),
        disabledForegroundColor: AppColors.gray400,
        padding: _getPadding(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1000),
        ),
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
      child: _buildButtonContent(),
    );
  }

  Widget _buildTertiaryButton() {
    return OutlinedButton(
      onPressed: isDisabled || isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: AppColors.buttonTertiary,
        foregroundColor: AppColors.buttonTertiaryText,
        disabledForegroundColor: AppColors.gray400,
        padding: _getPadding(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1000),
        ),
        side: const BorderSide(color: Colors.transparent),
      ),
      child: _buildButtonContent(),
    );
  }

  Widget _buildButtonContent() {
    if (isLoading) {
      return SizedBox(
        height: _getContentHeight(),
        child: Center(
          child: SizedBox(
            width: 16.h,
            height: 16.h,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                type == AppButtonType.primary 
                    ? AppColors.white 
                    : AppColors.primaryBlue,
              ),
            ),
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (leftIcon != null) ...[
          leftIcon!,
          SizedBox(width: 8.h),
        ],
        Flexible(
          child: Text(
            text,
            style: _getTextStyle(),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (rightIcon != null) ...[
          SizedBox(width: 8.h),
          rightIcon!,
        ],
      ],
    );
  }

  EdgeInsetsGeometry _getPadding() {
    switch (size) {
      case AppButtonSize.small:
        return EdgeInsets.symmetric(horizontal: 12.h, vertical: 8.v);
      case AppButtonSize.medium:
        return EdgeInsets.symmetric(horizontal: 16.h, vertical: 10.v);
      case AppButtonSize.large:
        return EdgeInsets.symmetric(horizontal: 20.h, vertical: 12.v);
    }
  }

  double _getContentHeight() {
    switch (size) {
      case AppButtonSize.small:
        return 16.v;
      case AppButtonSize.medium:
        return 20.v;
      case AppButtonSize.large:
        return 24.v;
    }
  }

  TextStyle _getTextStyle() {
    Color textColor;
    switch (type) {
      case AppButtonType.primary:
        textColor = AppColors.textOnPrimary;
        break;
      case AppButtonType.secondary:
        textColor = AppColors.buttonSecondaryText;
        break;
      case AppButtonType.tertiary:
        textColor = AppColors.buttonTertiaryText;
        break;
    }

    double fontSize;
    switch (size) {
      case AppButtonSize.small:
        fontSize = 12.fSize;
        break;
      case AppButtonSize.medium:
        fontSize = 14.fSize;
        break;
      case AppButtonSize.large:
        fontSize = 16.fSize;
        break;
    }

    return AppTextStyles.buttonMedium.copyWith(
      color: textColor,
      fontSize: fontSize,
    );
  }
}
