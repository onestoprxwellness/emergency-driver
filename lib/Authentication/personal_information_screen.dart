import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../util/size_utils.dart';
import '../util/image_constant.dart';
import '../widgets/app_header.dart';
import '../widgets/country_selector.dart';
import '../widgets/app_button.dart';
import '../widgets/registration_progress_indicator.dart';
import '../widgets/custom_input_field.dart';
import 'driver_information_screen.dart';

class PersonalInformationScreen extends StatefulWidget {
  final int currentStep;
  
  const PersonalInformationScreen({
    Key? key,
    this.currentStep = 2, // Default to step 2 (Personal Information)
  }) : super(key: key);

  @override
  State<PersonalInformationScreen> createState() => _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  CountryFlag selectedCountry = CountrySelector.defaultCountries.first;
  
  // Controllers
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController referralCodeController = TextEditingController();
  
  // Gender selection
  String selectedGender = '';
  
  // Form state
  bool isFormValid = false;

  @override
  void initState() {
    super.initState();
    _checkFormValidation();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    referralCodeController.dispose();
    super.dispose();
  }

  void _checkFormValidation() {
    setState(() {
      isFormValid = firstNameController.text.isNotEmpty &&
                   lastNameController.text.isNotEmpty &&
                   selectedGender.isNotEmpty;
    });
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
          
          // Progress Indicator
          RegistrationProgressIndicator(currentStep: widget.currentStep),
          
          // Main Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 12.v),
                  
                  // Header Text Section
                  _buildHeaderSection(),
                  
                  SizedBox(height: 24.v),
                  
                  // Form Fields
                  _buildFormFields(),
                ],
              ),
            ),
          ),
          
          // Bottom Buttons
          _buildBottomButtons(),
        ],
      ),
    );
  }



  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title with sparkles emoji
        Row(
          children: [
            Text(
              "Personal Information",
              style: AppTextStyles.headingLarge.copyWith(
                fontFamily: 'PlusJakartaSans',
                fontSize: 24.h,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(width: 4.h),
            Text(
              "✨",
              style: TextStyle(fontSize: 24.h),
            ),
          ],
        ),
        SizedBox(height: 4.v),
        // Description
        Text(
          "Don't worry, Only your first name and vehicle details are visible to users during booking.",
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            fontSize: 14.h,
          ),
        ),
      ],
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        // First Name Field
        CustomInputField(
          label: "First Name",
          hintText: "e.g., John",
          controller: firstNameController,
          prefixIcon: ImageConstant.imgUser,
          onChanged: (value) => _checkFormValidation(),
        ),
        
        SizedBox(height: 16.v),
        
        // Last Name Field
        CustomInputField(
          label: "Last Name",
          hintText: "e.g., Doe",
          controller: lastNameController,
          prefixIcon: ImageConstant.imgUser,
          onChanged: (value) => _checkFormValidation(),
        ),
        
        SizedBox(height: 16.v),
        
        // Gender Selection
        _buildGenderSelector(),
        
        SizedBox(height: 16.v),
        
        // Referral Code Field
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomInputField(
              label: "Referral Code (Optional)",
              hintText: "ONESTOPRX BONUS",
              controller: referralCodeController,
              prefixIcon: ImageConstant.imgGift,
              onChanged: (value) => _checkFormValidation(),
            ),
            // Helper text
            Padding(
              padding: EdgeInsets.only(left: 26.h, top: 4.v),
              child: Text(
                "If someone referred you, enter their code",
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 12.h,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }



  Widget _buildGenderSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Gender",
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.textPrimary,
            fontSize: 12.h,
          ),
        ),
        SizedBox(height: 8.v),
        Row(
          children: [
            // Male Option
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedGender = 'Male';
                    _checkFormValidation();
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12.v, horizontal: 8.h),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: selectedGender == 'Male' 
                          ? AppColors.brandBlue 
                          : AppColors.gray400,
                    ),
                    borderRadius: BorderRadius.circular(12.h),
                  ),
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        ImageConstant.selectMale,
                        height: 24.h,
                        width: 24.h,
                      ),
                      SizedBox(height: 4.v),
                      Text(
                        "Male",
                        style: AppTextStyles.labelMedium.copyWith(
                          color: selectedGender == 'Male' 
                              ? AppColors.textPrimary 
                              : AppColors.textSecondary,
                          fontSize: 10.h,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 16.h),
            // Female Option
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedGender = 'Female';
                    _checkFormValidation();
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12.v, horizontal: 8.h),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: selectedGender == 'Female' 
                          ? AppColors.brandBlue 
                          : AppColors.gray400,
                    ),
                    borderRadius: BorderRadius.circular(12.h),
                  ),
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        ImageConstant.selectFemale,
                        height: 24.h,
                        width: 24.h,
                      ),
                      SizedBox(height: 4.v),
                      Text(
                        "Female",
                        style: AppTextStyles.labelMedium.copyWith(
                          color: selectedGender == 'Female' 
                              ? AppColors.textPrimary 
                              : AppColors.textSecondary,
                          fontSize: 10.h,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }



  Widget _buildBottomButtons() {
    return Container(
      padding: EdgeInsets.all(16.h),
      child: Row(
        children: [
          // Back Button
          Expanded(
            child: AppButton(
              text: 'Back',
              type: AppButtonType.secondary,
              size: AppButtonSize.medium,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          SizedBox(width: 16.h),
          // Next Button
          Expanded(
            child: AppButton(
              text: 'Next',
              type: AppButtonType.primary,
              size: AppButtonSize.medium,
              isDisabled: !isFormValid,
              onPressed: isFormValid
                ? () {
                    _handleNext();
                  }
                : null,
            ),
          ),
        ],
      ),
    );
  }

  void _handleNext() {
    debugPrint('Personal Information Next pressed');
    debugPrint('First Name: ${firstNameController.text}');
    debugPrint('Last Name: ${lastNameController.text}');
    debugPrint('Gender: $selectedGender');
    debugPrint('Referral Code: ${referralCodeController.text}');
    
    // Navigate to Driver Information screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DriverInformationScreen(),
      ),
    );
  }
}
