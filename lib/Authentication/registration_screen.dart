import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../util/image_constant.dart';
import '../util/size_utils.dart';
import '../widgets/app_button.dart';
import '../widgets/app_header.dart';
import '../widgets/app_phone_input_field.dart';
import '../widgets/custom_input_field.dart';
import '../widgets/country_selector.dart';
import 'otp_confirmation_screen.dart';
import 'login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  CountryFlag selectedCountry = CountrySelector.defaultCountries.first;
  
  // Controllers
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  
  // Form state
  bool agreedToTerms = true;
  bool isFormValid = false;

  @override
  void initState() {
    super.initState();
    _checkFormValidation();
  }

  @override
  void dispose() {
    phoneController.dispose();
    emailController.dispose();
    cityController.dispose();
    super.dispose();
  }

  void _checkFormValidation() {
    setState(() {
      isFormValid = phoneController.text.isNotEmpty &&
                   emailController.text.isNotEmpty &&
                   cityController.text.isNotEmpty &&
                   agreedToTerms;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Set system UI overlay style for this screen
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.background,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              selectedCountry: selectedCountry,
              countries: CountrySelector.defaultCountries,
              onCountryChanged: (country) {
                setState(() {
                  selectedCountry = country;
                });
              },
            ),
            
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Header Text Section
                    _buildHeaderTextSection(),
                    
                    // Form Fields Section
                    _buildFormSection(),
                  ],
                ),
              ),
            ),
            
            // Bottom Section with Button and Navigation
            _buildBottomSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderTextSection() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.h,
        vertical: 12.v,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Join our team as a driver ',
                style: AppTextStyles.headingLarge.copyWith(
                  fontSize: 24.fSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
              // Sparkles emoji
              Text(
                '✨',
                style: TextStyle(fontSize: 24.fSize),
              ),
            ],
          ),
          
          SizedBox(height: 4.v),
          
          // Subtitle
          Text(
            'Join our team as a driver and be the hero in times of need!',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.h,
        vertical: 12.v,
      ),
      child: Column(
        children: [
          // Phone Number Field with country selector
          AppPhoneInputField(
            label: 'Phone Number',
            hintText: '8019292046',
            controller: phoneController,
            selectedCountry: selectedCountry,
            countries: CountrySelector.defaultCountries,
            onCountryChanged: (country) {
              setState(() {
                selectedCountry = country;
              });
            },
            onChanged: (value) => _checkFormValidation(),
            validator: (value) {
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
            },
          ),
          SizedBox(height: 16.v),

          // Email Field
          CustomInputField(
            label: 'Email Address',
            hintText: 'e.g youremail@example.com',
            prefixIcon: ImageConstant.supportEmail,
            controller: emailController,
            onChanged: (value) => _checkFormValidation(),
          ),
          
          // City Field (Dropdown)
          GestureDetector(
            onTap: () => _showCitySelector(context),
            child: CustomInputField(
              label: 'City',
              hintText: 'Select your city',
              prefixIcon: ImageConstant.cityIcon,
              suffixIcon: "assets/images/arrow-down2.svg",
              controller: cityController,
              enabled: false,
            ),
          ),
          
          SizedBox(height: 8.v),
          
          // Terms and conditions checkbox
          _buildTermsCheckbox(),
        ],
      ),
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Checkbox
        GestureDetector(
          onTap: () {
            setState(() {
              agreedToTerms = !agreedToTerms;
              _checkFormValidation();
            });
          },
          child: Container(
            width: 20.adaptSize,
            height: 20.adaptSize,
            decoration: BoxDecoration(
              color: agreedToTerms ? AppColors.brandBlue : Colors.transparent,
              border: Border.all(
                color: agreedToTerms ? AppColors.brandBlue : AppColors.gray400,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(4.adaptSize),
            ),
            child: agreedToTerms
              ? Icon(
                  Icons.check,
                  size: 14.adaptSize,
                  color: AppColors.white,
                )
              : null,
          ),
        ),
        
        SizedBox(width: 8.h),
        
        // Terms text
        Expanded(
          child: Text(
            'By ticking, you are confirming that you have read, understood,agree and comply with Onestoprx Terms of Service and Privacy Policy.',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomSection() {
    return Container(
      padding: EdgeInsets.all(16.h),
      child: Column(
        children: [
          // Register Button
          AppButton(
            text: 'Register as a driver',
            type: isFormValid ? AppButtonType.primary : AppButtonType.primary,
            size: AppButtonSize.medium,
            onPressed: isFormValid
              ? () {
                  _handleRegistration();
                }
              : null,
            margin: EdgeInsets.only(bottom: 16.v),
          ),
          
          // Login Link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Have an account? ',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              GestureDetector(
                onTap: () {
                  _handleLogin();
                },
                child: Text(
                  'Login',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.brandBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Action handlers
  void _showCitySelector(BuildContext context) {
    final cities = ['Lagos', 'Abuja', 'Port Harcourt', 'Kano', 'Ibadan', 'Benin City'];
    
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select City',
              style: AppTextStyles.headingMedium,
            ),
            SizedBox(height: 16.v),
            ...cities.map((city) => ListTile(
              title: Text(city),
              onTap: () {
                setState(() {
                  cityController.text = city;
                  _checkFormValidation();
                });
                Navigator.pop(context);
              },
            )),
          ],
        ),
      ),
    );
  }

  void _handleRegistration() {
    debugPrint('Register as driver pressed');
    debugPrint('Phone: ${phoneController.text}');
    debugPrint('Email: ${emailController.text}');
    debugPrint('City: ${cityController.text}');
    
    // Navigate to OTP confirmation screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OtpConfirmationScreen(
          phoneNumber: phoneController.text,
          countryCode: selectedCountry.dialCode,
        ),
      ),
    );
  }

  void _handleLogin() {
    debugPrint('Login pressed');
    // Navigate to login screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }
}
