import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../util/image_constant.dart';
import '../widgets/app_header.dart';
import '../widgets/country_selector.dart';
import '../widgets/app_button.dart';
import '../widgets/custom_input_field.dart';
import '../widgets/app_phone_input_field.dart';
import 'login_otp_confirmation_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  CountryFlag selectedCountry = CountrySelector.defaultCountries.first;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  bool isFormValid = false;
  bool isEmailLogin = true;

  @override
  void initState() {
    super.initState();
    _checkFormValidation();
  }

  @override
  void dispose() {
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void _checkFormValidation() {
    setState(() {
      if (isEmailLogin) {
        isFormValid =
            emailController.text.isNotEmpty &&
            _isValidEmail(emailController.text);
      } else {
        isFormValid =
            phoneController.text.isNotEmpty &&
            phoneController.text.length >= 10;
      }
    });
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          SafeArea(
            child: AppHeader(
              selectedCountry: selectedCountry,
              countries: CountrySelector.defaultCountries,
              onCountryChanged: (country) {
                setState(() {
                  selectedCountry = country;
                });
              },
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [_buildHeaderSection(), _buildInputSection()],
              ),
            ),
          ),

          _buildBottomSection(),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Back with dancing emoji
          Row(
            children: [
              Text(
                "Welcome Back",
                style: AppTextStyles.headingLarge.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 12),
              SvgPicture.asset(
                ImageConstant.imgEmojiManDancing,
                width: 28,
                height: 28,
              ),
            ],
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: 320,
            child: Text(
              "Log in to your OneStop RX driver's account.",
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        children: [
          if (isEmailLogin) ...[
            CustomInputField(
              label: "Email",
              hintText: "yourmail@gmail.com",
              controller: emailController,
              prefixIcon: ImageConstant.supportEmail,
              onChanged: (value) => _checkFormValidation(),
            ),
          ] else ...[
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
          ],
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                _handleSwitchLoginMethod();
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  isEmailLogin
                      ? "Use Phone Number Instead"
                      : "Use Email Instead",
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.brandBlue,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: AppButton(
            text: "Continue",
            type: AppButtonType.primary,
            size: AppButtonSize.medium,
            isDisabled: !isFormValid,
            onPressed:
                isFormValid
                    ? () {
                      _handleContinue();
                    }
                    : null,
          ),
        ),
        const SizedBox(height: 16),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don't have an account?",
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                _handleSignUp();
              },
              child: Text(
                "Sign up",
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.brandBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        Container(
          margin: const EdgeInsets.only(bottom: 10),
          width: 108,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.textPrimary,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ],
    );
  }

  void _handleContinue() {
    if (isEmailLogin) {
      debugPrint('Continue pressed with email: ${emailController.text}');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => LoginOtpConfirmationScreen(
                email: emailController.text,
                isEmailLogin: true,
              ),
        ),
      );
    } else {
      debugPrint('Continue pressed with phone: ${phoneController.text}');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => LoginOtpConfirmationScreen(
                phoneNumber: phoneController.text,
                countryCode: selectedCountry.dialCode,
                isEmailLogin: false,
              ),
        ),
      );
    }
  }

  void _handleSwitchLoginMethod() {
    setState(() {
      isEmailLogin = !isEmailLogin;
      emailController.clear();
      phoneController.clear();
      _checkFormValidation();
    });
    debugPrint('Switched to ${isEmailLogin ? "email" : "phone"} login');
  }

  void _handleSignUp() {
    debugPrint('Sign up pressed');
    Navigator.pop(context);
  }
}
