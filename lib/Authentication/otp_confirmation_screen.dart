import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../util/size_utils.dart';
import '../widgets/app_button.dart';
import '../widgets/styled_pin_input.dart';
import '../widgets/app_header.dart';
import '../widgets/country_selector.dart';
import 'personal_information_screen.dart';

class OtpConfirmationScreen extends StatefulWidget {
  final String? phoneNumber;
  final String? countryCode;

  const OtpConfirmationScreen({
    Key? key,
    this.phoneNumber,
    this.countryCode,
  }) : super(key: key);

  @override
  State<OtpConfirmationScreen> createState() => _OtpConfirmationScreenState();
}

class _OtpConfirmationScreenState extends State<OtpConfirmationScreen> {
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

  void startCountdown() {
    // Countdown logic will be added later
  }

  void _submit() {
    // Submit OTP logic will be added later
    debugPrint('OTP Confirmed: ${otpPinController.text}');
    
    // Navigate to Personal Information screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PersonalInformationScreen(currentStep: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          // App Header with SafeArea
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
          
          // Main Content - Exact replica of your structure
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
                            text: "A 6 digit code has been sent to your mobile number ",
                            style: AppTextStyles.bodyMedium,
                          ),
                          TextSpan(
                            text: (widget.countryCode ?? '') +
                                maskPhoneNumber(widget.phoneNumber!),
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
                // Backend logic removed as requested
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
            // Loading state removed as requested - no backend logic
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
