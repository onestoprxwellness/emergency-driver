// import 'package:flutter/material.dart';
// import '../core/theme/app_colors.dart';
// import '../core/theme/app_text_styles.dart';
// import '../util/size_utils.dart';
// import '../util/image_constant.dart';
// import 'custom_image_view.dart';

// enum LogoType {
//   full,
//   iconOnly,
//   textOnly,
// }

// enum LogoSize {
//   small,
//   medium,
//   large,
// }

// class AppLogo extends StatelessWidget {
//   final LogoType type;
//   final LogoSize size;
//   final Color? iconColor;
//   final Color? textColor;
//   final EdgeInsetsGeometry? margin;

//   const AppLogo({
//     Key? key,
//     this.type = LogoType.full,
//     this.size = LogoSize.medium,
//     this.iconColor,
//     this.textColor,
//     this.margin,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: margin ?? EdgeInsets.zero,
//       child: _buildLogo(),
//     );
//   }

//   Widget _buildLogo() {
//     switch (type) {
//       case LogoType.full:
//         return _buildFullLogo();
//       case LogoType.iconOnly:
//         return _buildIconOnly();
//       case LogoType.textOnly:
//         return _buildTextOnly();
//     }
//   }

//   Widget _buildFullLogo() {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         _buildLogoIcon(),
//         SizedBox(width: _getIconTextSpacing()),
//         _buildLogoText(),
//       ],
//     );
//   }

//   Widget _buildLogoIcon() {
//     final iconSize = _getIconSize();
//     return CustomImageView(
//       imagePath: ImageConstant.AppLogoNew,
//       width: iconSize,
//       height: iconSize,
//       fit: BoxFit.contain,
//     );
//   }

//   Widget _buildLogoText() {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.baseline,
//       textBaseline: TextBaseline.alphabetic,
//       children: [
//         Text(
//           'OneStop',
//           style: _getMainTextStyle(),
//         ),
//         Text(
//           'Rx',
//           style: _getSubTextStyle(),
//         ),
//       ],
//     );
//   }

//   Widget _buildIconOnly() {
//     return _buildLogoIcon();
//   }

//   Widget _buildTextOnly() {
//     return _buildLogoText();
//   }

//   double _getIconSize() {
//     switch (size) {
//       case LogoSize.small:
//         return 16.h;
//       case LogoSize.medium:
//         return 24.h;
//       case LogoSize.large:
//         return 32.h;
//     }
//   }

//   double _getIconTextSpacing() {
//     switch (size) {
//       case LogoSize.small:
//         return 4.h;
//       case LogoSize.medium:
//         return 6.h;
//       case LogoSize.large:
//         return 8.h;
//     }
//   }

//   TextStyle _getMainTextStyle() {
//     double fontSize;
//     switch (size) {
//       case LogoSize.small:
//         fontSize = 12.fSize;
//         break;
//       case LogoSize.medium:
//         fontSize = 17.6.fSize;
//         break;
//       case LogoSize.large:
//         fontSize = 24.fSize;
//         break;
//     }

//     return AppTextStyles.logoLarge.copyWith(
//       fontSize: fontSize,
//       color: textColor ?? AppColors.brandDark,
//     );
//   }

//   TextStyle _getSubTextStyle() {
//     double fontSize;
//     switch (size) {
//       case LogoSize.small:
//         fontSize = 3.2.fSize;
//         break;
//       case LogoSize.medium:
//         fontSize = 4.8.fSize;
//         break;
//       case LogoSize.large:
//         fontSize = 6.4.fSize;
//         break;
//     }

//     return AppTextStyles.logoSmall.copyWith(
//       fontSize: fontSize,
//       color: textColor ?? AppColors.brandDark,
//     );
//   }
// }
