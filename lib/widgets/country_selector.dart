import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../util/size_utils.dart';
import '../util/image_constant.dart';
import 'custom_image_view.dart';

class CountryFlag {
  final String code;
  final String name;
  final String flag;
  final String dialCode;

  const CountryFlag({
    required this.code,
    required this.name,
    required this.flag,
    required this.dialCode,
  });

  // Method to get the full flag path
  String get flagPath {
    switch (flag) {
      case 'nigeria':
        return ImageConstant.nigeria;
      case 'uae':
        return ImageConstant.uae;
      case 'english':
        return ImageConstant.english;
      default:
        return ImageConstant.nigeria; // fallback
    }
  }
}

class CountrySelector extends StatelessWidget {
  final CountryFlag selectedCountry;
  final List<CountryFlag> countries;
  final Function(CountryFlag)? onCountryChanged;
  final EdgeInsetsGeometry? margin;

  const CountrySelector({
    Key? key,
    required this.selectedCountry,
    required this.countries,
    this.onCountryChanged,
    this.margin,
  }) : super(key: key);

  // Default countries list
  static const List<CountryFlag> defaultCountries = [
    CountryFlag(
      code: 'NG',
      name: 'Nigeria',
      flag: 'nigeria', // Will use ImageConstant.nigeria
      dialCode: '+234',
    ),
    CountryFlag(
      code: 'US',
      name: 'United States',
      flag: 'uae', // Will use ImageConstant.uae
      dialCode: '+1',
    ),
    CountryFlag(
      code: 'GB',
      name: 'United Kingdom',
      flag: 'english', // Will use ImageConstant.english
      dialCode: '+44',
    ),
    CountryFlag(
      code: 'CA',
      name: 'Canada',
      flag: '🇨🇦',
      dialCode: '+1',
    ),
    CountryFlag(
      code: 'GH',
      name: 'Ghana',
      flag: '🇬🇭',
      dialCode: '+233',
    ),
    CountryFlag(
      code: 'KE',
      name: 'Kenya',
      flag: '🇰🇪',
      dialCode: '+254',
    ),
    CountryFlag(
      code: 'ZA',
      name: 'South Africa',
      flag: '🇿🇦',
      dialCode: '+27',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Primary country (Nigeria) - circular
          GestureDetector(
            onTap: () => _showCountrySelector(context),
            child: Container(
              width: 20.h,
              height: 20.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.white,
                  width: 1,
                ),
              ),
              child: ClipOval(
                child: CustomImageView(
                  imagePath: ImageConstant.nigeria,
                  width: 20.h,
                  height: 20.h,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          
          SizedBox(height: 2.5.v),
          
          // Secondary country (US) - rectangular with dropdown
          GestureDetector(
            onTap: () => _showCountrySelector(context),
            child: Stack(
              children: [
                Container(
                  width: 12.h,
                  height: 8.v,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    border: Border.all(
                      color: AppColors.white,
                      width: 0.5,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: CustomImageView(
                      imagePath: ImageConstant.uae,
                      width: 12.h,
                      height: 8.v,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                
                // Dropdown arrow
                Positioned(
                  right: -4.h,
                  top: 2.v,
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    size: 8.h,
                    color: AppColors.gray800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCountrySelector(BuildContext context) {
    if (onCountryChanged == null) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.h),
        ),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16.h,
          vertical: 20.v,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40.h,
                height: 4.v,
                decoration: BoxDecoration(
                  color: AppColors.gray400,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            
            SizedBox(height: 16.v),
            
            Text(
              'Select Country',
              style: TextStyle(
                fontSize: 18.fSize,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            
            SizedBox(height: 16.v),
            
            // Countries list
            ...countries.map((country) => ListTile(
              leading: Container(
                width: 32.h,
                height: 24.v,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: AppColors.gray400,
                    width: 0.5,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: _getFlagWidget(country.flag),
                ),
              ),
              title: Text(
                country.name,
                style: TextStyle(
                  fontSize: 14.fSize,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              subtitle: Text(
                country.code,
                style: TextStyle(
                  fontSize: 12.fSize,
                  color: AppColors.textSecondary,
                ),
              ),
              trailing: selectedCountry.code == country.code
                  ? Icon(
                      Icons.check_circle,
                      color: AppColors.primaryBlue,
                      size: 20.h,
                    )
                  : null,
              onTap: () {
                onCountryChanged!(country);
                Navigator.pop(context);
              },
            )),
            
            SizedBox(height: 16.v),
          ],
        ),
      ),
    );
  }

  Widget _getFlagWidget(String flag) {
    // Check if it's an asset name (from ImageConstant)
    switch (flag) {
      case 'nigeria':
        return CustomImageView(
          imagePath: ImageConstant.nigeria,
          fit: BoxFit.cover,
        );
      case 'uae':
        return CustomImageView(
          imagePath: ImageConstant.uae,
          fit: BoxFit.cover,
        );
      case 'english':
        return CustomImageView(
          imagePath: ImageConstant.english,
          fit: BoxFit.cover,
        );
      default:
        // Use emoji as fallback
        return Center(
          child: Text(
            flag,
            style: TextStyle(fontSize: 16.fSize),
          ),
        );
    }
  }
}
