import 'package:flutter/material.dart';
import 'package:onestoprx_driver/features/dashboard/dashboard_screen.dart';
import 'package:onestoprx_driver/features/home/home_screen.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../util/size_utils.dart';
import '../widgets/app_button.dart';
import '../widgets/styled_pin_input.dart';
import '../widgets/app_header.dart';
import '../widgets/country_selector.dart';

class LoginOtpConfirmationScreen extends StatefulWidget {
  final String? phoneNumber;
  final String? email;
  final String? countryCode;
  final bool isEmailLogin;

  const LoginOtpConfirmationScreen({
    Key? key,
    this.phoneNumber,
    this.email,
    this.countryCode,
    this.isEmailLogin = true,
  }) : super(key: key);

  @override
  State<LoginOtpConfirmationScreen> createState() => _LoginOtpConfirmationScreenState();
}

class _LoginOtpConfirmationScreenState extends State<LoginOtpConfirmationScreen> {
  final TextEditingController otpPinController = TextEditingController();
  bool resendNow = false;
  CountryFlag selectedCountry = CountrySelector.defaultCountries.first;

  @override
  void dispose() {
    otpPinController.dispose();
    super.dispose();
  }

  String maskPhoneNumber(String phoneNumber) {
    if (phoneNumber.length <= 4) return phoneNumber;
    return '****${phoneNumber.substring(phoneNumber.length - 4)}';
  }

  String maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;
    
    final localPart = parts[0];
    final domain = parts[1];
    
    if (localPart.length <= 2) return email;
    
    final maskedLocal = localPart.substring(0, 2) + 
        '*' * (localPart.length - 2);
    return '$maskedLocal@$domain';
  }

  void startCountdown() {
  }

  void _submit() {
    debugPrint('Login OTP Confirmed: ${otpPinController.text}');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Login successful! Welcome to OneStopRx Driver'),
        backgroundColor: AppColors.success,
      ),
    );
    
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const DashboardScreen()),
    );

   


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
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 19.v),
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Enter OTP 👏",
                    style: AppTextStyles.headingLarge.copyWith(
                      fontFamily: 'PlusJakartaSemiBold',
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 11.v),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 289.h,
                    margin: EdgeInsets.only(right: 30.h),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: widget.isEmailLogin 
                                ? "A 6 digit code has been sent to your email address "
                                : "A 6 digit code has been sent to your mobile number ",
                            style: AppTextStyles.bodyMedium,
                          ),
                          TextSpan(
                            text: widget.isEmailLogin
                                ? maskEmail(widget.email ?? '')
                                : (widget.countryCode ?? '') + maskPhoneNumber(widget.phoneNumber ?? ''),
                            style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                SizedBox(height: 40.v),
                StyledPinInput(
                  controller: otpPinController,
                  onCompleted: (pin) {
                    debugPrint('Completed: $pin');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                setState(() => resendNow = false);
                startCountdown();
              },
              child: Text(
                'Resend OTP',
                textAlign: TextAlign.center,
                style: AppTextStyles.labelMedium.copyWith(
                  fontSize: 14, 
                  fontFamily: 'InterSemiBold'
                ),
              ),
            ),
            SizedBox(height: 14.v),
            AppButton(
              margin: const EdgeInsets.all(16),
              text: "Confirm",
              onPressed: () => _submit(),
            ),
          ],
        ),
      ),
    );
  }
}
