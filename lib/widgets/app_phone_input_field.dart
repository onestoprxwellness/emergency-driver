import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../util/size_utils.dart';
import '../widgets/country_selector.dart';
import '../widgets/custom_image_view.dart';
import '../util/image_constant.dart';

class AppPhoneInputField extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final EdgeInsetsGeometry? margin;
  final CountryFlag selectedCountry;
  final List<CountryFlag> countries;
  final Function(CountryFlag) onCountryChanged;

  const AppPhoneInputField({
    Key? key,
    required this.label,
    required this.hintText,
    this.controller,
    this.onChanged,
    this.validator,
    this.margin,
    required this.selectedCountry,
    required this.countries,
    required this.onCountryChanged,
  }) : super(key: key);

  @override
  State<AppPhoneInputField> createState() => _AppPhoneInputFieldState();
}

class _AppPhoneInputFieldState extends State<AppPhoneInputField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin ?? EdgeInsets.only(bottom: 16.v),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.h),
            child: Text(
              widget.label,
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          
          SizedBox(height: 3.v),
          
          // Phone Input Field
          TextFormField(
            controller: widget.controller,
            keyboardType: TextInputType.number,
            maxLength: 11,
            textInputAction: TextInputAction.next,
            onChanged: widget.onChanged,
            validator: widget.validator ?? _defaultValidator,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: widget.hintText,
              counterText: '', // Hide character counter
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              prefixIcon: Container(
                width: 90.h,
                height: 32.v,
                margin: EdgeInsets.only(bottom: 8.v),
                child: _buildCountryCodePicker(),
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
                vertical: 12.v,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountryCodePicker() {
    return GestureDetector(
      onTap: () => _showCountrySelector(context),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Country Flag
            Container(
              width: 20.adaptSize,
              height: 16.v,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: CustomImageView(
                  imagePath: widget.selectedCountry.flagPath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            
            SizedBox(width: 4.h),
            
            // Country Dial Code
            Text(
              widget.selectedCountry.dialCode,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            
            SizedBox(width: 4.h),
            
            // Dropdown Arrow
            CustomImageView(
              imagePath: ImageConstant.arrowdown2,
              height: 12.adaptSize,
              width: 12.adaptSize,
              color: AppColors.gray400,
            ),
          ],
        ),
      ),
    );
  }

  void _showCountrySelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.adaptSize),
        ),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(16.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40.h,
              height: 4.v,
              decoration: BoxDecoration(
                color: AppColors.gray400,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            SizedBox(height: 16.v),
            
            Text(
              'Select Country',
              style: AppTextStyles.headingMedium.copyWith(
                fontSize: 18.fSize,
              ),
            ),
            
            SizedBox(height: 16.v),
            
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.countries.length,
                itemBuilder: (context, index) {
                  final country = widget.countries[index];
                  final isSelected = country.code == widget.selectedCountry.code;
                  
                  return ListTile(
                    leading: Container(
                      width: 24.adaptSize,
                      height: 20.v,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: CustomImageView(
                          imagePath: country.flagPath,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(
                      country.name,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected ? AppColors.brandBlue : AppColors.textPrimary,
                      ),
                    ),
                    trailing: Text(
                      country.dialCode,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    selected: isSelected,
                    selectedTileColor: AppColors.brandBlue.withOpacity(0.1),
                    onTap: () {
                      widget.onCountryChanged(country);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _defaultValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a valid phone number';
    }
    if (value.length < 10) {
      return 'Phone number must be greater than 9 digits';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Phone number can only contain digits';
    }
    return null;
  }
}
