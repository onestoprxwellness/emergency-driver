import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../util/image_constant.dart';
import '../widgets/app_header.dart';
import '../widgets/country_selector.dart';
import '../widgets/app_button.dart';
import '../widgets/registration_progress_indicator.dart';
import '../widgets/custom_input_field.dart';
import 'registration_success_screen.dart';

class PaymentInformationScreen extends StatefulWidget {
  const PaymentInformationScreen({super.key});

  @override
  State<PaymentInformationScreen> createState() => _PaymentInformationScreenState();
}

class _PaymentInformationScreenState extends State<PaymentInformationScreen> {
  final TextEditingController _accountHolderController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _nextOfKinNameController = TextEditingController();
  final TextEditingController _nextOfKinRelationshipController = TextEditingController();
  final TextEditingController _nextOfKinPhoneController = TextEditingController();
  
  bool _isFormValid = false;

  // Dropdown data
  final List<String> _bankNames = [
    'Access Bank',
    'First Bank',
    'GTBank',
    'Zenith Bank',
    'UBA',
    'Fidelity Bank',
    'FCMB',
    'Sterling Bank',
    'Union Bank',
    'Wema Bank',
    'Stanbic IBTC',
    'Ecobank',
    'Keystone Bank',
    'Polaris Bank',
    'Heritage Bank',
    'Providus Bank',
    'Kuda Bank',
    'Opay',
    'Palmpay',
    'Other',
  ];

  final List<String> _relationships = [
    'Father',
    'Mother',
    'Brother',
    'Sister',
    'Spouse',
    'Son',
    'Daughter',
    'Uncle',
    'Aunt',
    'Cousin',
    'Friend',
    'Guardian',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _accountHolderController.addListener(_validateForm);
    _accountNumberController.addListener(_validateForm);
    _bankNameController.addListener(_validateForm);
    _nextOfKinNameController.addListener(_validateForm);
    _nextOfKinRelationshipController.addListener(_validateForm);
    _nextOfKinPhoneController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _accountHolderController.removeListener(_validateForm);
    _accountNumberController.removeListener(_validateForm);
    _bankNameController.removeListener(_validateForm);
    _nextOfKinNameController.removeListener(_validateForm);
    _nextOfKinRelationshipController.removeListener(_validateForm);
    _nextOfKinPhoneController.removeListener(_validateForm);
    
    _accountHolderController.dispose();
    _accountNumberController.dispose();
    _bankNameController.dispose();
    _nextOfKinNameController.dispose();
    _nextOfKinRelationshipController.dispose();
    _nextOfKinPhoneController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _isFormValid = _accountHolderController.text.trim().isNotEmpty &&
          _accountNumberController.text.trim().isNotEmpty &&
          _bankNameController.text.trim().isNotEmpty &&
          _nextOfKinNameController.text.trim().isNotEmpty &&
          _nextOfKinRelationshipController.text.trim().isNotEmpty &&
          _nextOfKinPhoneController.text.trim().isNotEmpty;
    });
  }

  void _showBankDropdown() async {
    final String? selectedBank = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Select Bank',
            style: AppTextStyles.headingSmall.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: ListView.builder(
              itemCount: _bankNames.length,
              itemBuilder: (context, index) {
                final bank = _bankNames[index];
                return ListTile(
                  title: Text(
                    bank,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  onTap: () => Navigator.of(context).pop(bank),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (selectedBank != null) {
      _bankNameController.text = selectedBank;
    }
  }

  void _showRelationshipDropdown() async {
    final String? selectedRelationship = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Select Relationship',
            style: AppTextStyles.headingSmall.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: ListView.builder(
              itemCount: _relationships.length,
              itemBuilder: (context, index) {
                final relationship = _relationships[index];
                return ListTile(
                  title: Text(
                    relationship,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  onTap: () => Navigator.of(context).pop(relationship),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (selectedRelationship != null) {
      _nextOfKinRelationshipController.text = selectedRelationship;
    }
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
            const RegistrationProgressIndicator(currentStep: 4),

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
                            'Payment Information',
                            style: AppTextStyles.headingMedium.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 4),
                          // Sparkles emoji
                          Container(
                            width: 24,
                            height: 24,
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 0,
                                  top: 0,
                                  child: Container(
                                    width: 16.5,
                                    height: 24,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFFE724E),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 15.75,
                                  top: 0,
                                  child: Container(
                                    width: 8.25,
                                    height: 12,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF1D9C7D),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 13.88,
                                  top: 12,
                                  child: Container(
                                    width: 8.25,
                                    height: 12,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF077BF8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "We need your payment details to pay you.",
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Bank Account Holder Name Input
                      CustomInputField(
                        label: "Bank account holder name",
                        hintText: 'e.g., John Doe',
                        prefixIcon: ImageConstant.imgUser,
                        controller: _accountHolderController,
                      ),
                      const SizedBox(height: 16),

                      // Bank Account Number Input
                      CustomInputField(
                        label: "Bank account number",
                        hintText: 'e.g., John Doe',
                        prefixIcon: ImageConstant.cardIcon,
                        controller: _accountNumberController,
                      ),
                      const SizedBox(height: 16),

                      // Bank Name Input with dropdown
                      GestureDetector(
                        onTap: _showBankDropdown,
                        child: CustomInputField(
                          label: "Bank name",
                          hintText: 'Select your bank name',
                          prefixIcon: ImageConstant.bank,
                          suffixIcon: "assets/images/arrow-down2.svg",
                          controller: _bankNameController,
                          enabled: false,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Next of Kin Full Name Input
                      CustomInputField(
                        label: "Next of kin full name",
                        hintText: 'e.g., John Doe',
                        prefixIcon: ImageConstant.imgUser,
                        controller: _nextOfKinNameController,
                      ),
                      const SizedBox(height: 16),

                      // Next of Kin Relationship Input with dropdown
                      GestureDetector(
                        onTap: _showRelationshipDropdown,
                        child: CustomInputField(
                          label: "Next of kin relationship",
                          hintText: 'Select next of kin relationship',
                          prefixIcon: ImageConstant.nextOfKin,
                          suffixIcon: "assets/images/arrow-down2.svg",
                          controller: _nextOfKinRelationshipController,
                          enabled: false,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Next of Kin Phone Number Input
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Next of kin phone number",
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: AppColors.gray400,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                // Country Flag and Code
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  child: Row(
                                    children: [
                                      // Nigerian Flag
                                      Container(
                                        width: 18,
                                        height: 18,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(9),
                                        ),
                                        child: Stack(
                                          children: [
                                            Container(
                                              width: 6,
                                              height: 18,
                                              decoration: const BoxDecoration(
                                                color: Color(0xFF2AB844),
                                              ),
                                            ),
                                            Positioned(
                                              right: 0,
                                              child: Container(
                                                width: 6,
                                                height: 18,
                                                decoration: const BoxDecoration(
                                                  color: Color(0xFF2AB844),
                                                ),
                                              ),
                                            ),
                                            Center(
                                              child: Container(
                                                width: 6,
                                                height: 18,
                                                decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '+234',
                                        style: AppTextStyles.bodyMedium.copyWith(
                                          color: AppColors.textPrimary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      SvgPicture.asset(
                                        "assets/images/arrow-down2.svg",
                                        width: 18,
                                        height: 18,
                                        colorFilter: const ColorFilter.mode(
                                          AppColors.gray400,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Phone Number Input
                                Expanded(
                                  child: TextFormField(
                                    controller: _nextOfKinPhoneController,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      hintText: '8112345678',
                                      hintStyle: AppTextStyles.bodyMedium.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      focusedErrorBorder: InputBorder.none,
                                      contentPadding: EdgeInsets.zero,
                                      isDense: true,
                                    ),
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.textPrimary,
                                    ),
                                    onChanged: (value) => _validateForm(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),

            // Buttons
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Back Button
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
                  // Next Button
                  Expanded(
                    child: AppButton(
                      text: "Next",
                      type: AppButtonType.primary,
                      size: AppButtonSize.medium,
                      isDisabled: !_isFormValid,
                      onPressed: _isFormValid ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegistrationSuccessScreen(),
                          ),
                        );
                      } : null,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
