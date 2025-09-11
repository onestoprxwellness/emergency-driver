import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../util/image_constant.dart';
import '../widgets/app_header.dart';
import '../widgets/country_selector.dart';
import '../widgets/app_button.dart';
import '../widgets/registration_progress_indicator.dart';
import '../widgets/app_license_input_field.dart';
import 'vehicle_information_screen.dart';

class DriverInformationScreen extends StatefulWidget {
  const DriverInformationScreen({super.key});

  @override
  State<DriverInformationScreen> createState() => _DriverInformationScreenState();
}

class _DriverInformationScreenState extends State<DriverInformationScreen> {
  final TextEditingController _licenseController = TextEditingController();
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _licenseController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _licenseController.removeListener(_validateForm);
    _licenseController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _isFormValid = _licenseController.text.trim().isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            AppHeader(
              selectedCountry: const CountryFlag(
                name: 'Nigeria',
                flag: 'nigeria',
                code: 'NG',
                dialCode: '+234',
              ),
              countries: const [],
              onCountryChanged: (CountryFlag country) {},
            ),

            // Progress Indicator
            const RegistrationProgressIndicator(currentStep: 2),

            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Text
                      Row(
                        children: [
                          Text(
                            'Driver Information',
                            style: AppTextStyles.headingMedium.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 4),
                          SvgPicture.asset(
                            ImageConstant.imgEmojiSparkles,
                            width: 24,
                            height: 24,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Don't worry, your national ID and license details will be kept private.",
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Driver's License Number Input
                      CustomInputField(
                        label: "Driver's License Number",
                        hintText: 'e.g., AB123456',
                        prefixIcon: ImageConstant.vehicle,
                        controller: _licenseController,
                      ),
                      const SizedBox(height: 16),

                      // Driver's Profile Picture Upload
                      Container(
                        padding: const EdgeInsets.only(bottom: 16),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Color(0xFFEAECF0),
                              width: 1,
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Driver's profile picture",
                              style: AppTextStyles.bodyLarge.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Please provide a clear portrait picture (not a full body picture) of yourself. It should show your full face, front view, with your eyes open.',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Upload Button
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(1000),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(
                                    ImageConstant.imgPlus,
                                    width: 14,
                                    height: 14,
                                    colorFilter: ColorFilter.mode(
                                      AppColors.textPrimary,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Upload file',
                                    style: AppTextStyles.labelMedium.copyWith(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Driver's License Document Upload
                      Container(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Driver's license document",
                              style: AppTextStyles.bodyLarge.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Please provide a clear document showing the document number, your name, and date of birth.',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Upload Button
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(1000),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(
                                    ImageConstant.imgPlus,
                                    width: 14,
                                    height: 14,
                                    colorFilter: ColorFilter.mode(
                                      AppColors.textPrimary,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Upload file',
                                    style: AppTextStyles.labelMedium.copyWith(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Buttons
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: "Back",
                      type: AppButtonType.secondary,
                      size: AppButtonSize.medium,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AppButton(
                      text: "Next",
                      type: AppButtonType.primary,
                      size: AppButtonSize.medium,
                      isDisabled: !_isFormValid,
                      onPressed: _isFormValid ? () {
                        debugPrint('Driver Information Next pressed');
                        debugPrint('License Number: ${_licenseController.text}');
                        
                        // Navigate to Vehicle Information screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const VehicleInformationScreen(),
                          ),
                        );
                      } : null,
                    ),
                  ),
                ],
              ),
            ),

            // Navigation handle
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
        ),
      ),
    );
  }
}
