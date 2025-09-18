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
import 'payment_information_screen.dart';

class VehicleInformationScreen extends StatefulWidget {
  const VehicleInformationScreen({super.key});

  @override
  State<VehicleInformationScreen> createState() => _VehicleInformationScreenState();
}

class _VehicleInformationScreenState extends State<VehicleInformationScreen> {
  final TextEditingController _vehicleYearController = TextEditingController();
  final TextEditingController _manufacturerController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _licensePlateController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  
  bool _isFormValid = false;

  // Dropdown data
  final List<String> _vehicleYears = List.generate(30, (index) => (DateTime.now().year - index).toString());
  final List<String> _vehicleColors = [
    'Black',
    'White',
    'Silver',
    'Gray',
    'Red',
    'Blue',
    'Green',
    'Yellow',
    'Orange',
    'Brown',
    'Purple',
    'Gold',
    'Maroon',
    'Navy',
    'Beige',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _vehicleYearController.addListener(_validateForm);
    _manufacturerController.addListener(_validateForm);
    _modelController.addListener(_validateForm);
    _licensePlateController.addListener(_validateForm);
    _colorController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _vehicleYearController.removeListener(_validateForm);
    _manufacturerController.removeListener(_validateForm);
    _modelController.removeListener(_validateForm);
    _licensePlateController.removeListener(_validateForm);
    _colorController.removeListener(_validateForm);
    
    _vehicleYearController.dispose();
    _manufacturerController.dispose();
    _modelController.dispose();
    _licensePlateController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _isFormValid = _vehicleYearController.text.trim().isNotEmpty &&
          _manufacturerController.text.trim().isNotEmpty &&
          _modelController.text.trim().isNotEmpty &&
          _licensePlateController.text.trim().isNotEmpty &&
          _colorController.text.trim().isNotEmpty;
    });
  }

  void _showYearDropdown() async {
    final String? selectedYear = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Select Vehicle Year',
            style: AppTextStyles.headingSmall.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: ListView.builder(
              itemCount: _vehicleYears.length,
              itemBuilder: (context, index) {
                final year = _vehicleYears[index];
                return ListTile(
                  title: Text(
                    year,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  onTap: () => Navigator.of(context).pop(year),
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

    if (selectedYear != null) {
      _vehicleYearController.text = selectedYear;
    }
  }

  void _showColorDropdown() async {
    final String? selectedColor = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Select Vehicle Color',
            style: AppTextStyles.headingSmall.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: ListView.builder(
              itemCount: _vehicleColors.length,
              itemBuilder: (context, index) {
                final color = _vehicleColors[index];
                return ListTile(
                  title: Text(
                    color,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  onTap: () => Navigator.of(context).pop(color),
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

    if (selectedColor != null) {
      _colorController.text = selectedColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
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

            const RegistrationProgressIndicator(currentStep: 3),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Vehicle Information',
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
                        "We're legally required to ask you for some documents to sign you up as a driver. Documents scans and quality photos are accepted.",
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      GestureDetector(
                        onTap: _showYearDropdown,
                        child: CustomInputField(
                          label: "Vehicle year",
                          hintText: 'Select your vehicle year',
                          prefixIcon: ImageConstant.imgCalendarUpload,
                          suffixIcon: "assets/images/arrow-down2.svg",
                          controller: _vehicleYearController,
                          enabled: false,
                        ),
                      ),
                      const SizedBox(height: 16),

                      CustomInputField(
                        label: "Vehicle Manufacturer",
                        hintText: 'Select your vehicle manufacturer',
                        prefixIcon: ImageConstant.vehicle,
                        controller: _manufacturerController,
                      ),
                      const SizedBox(height: 16),

                      CustomInputField(
                        label: "Vehicle Model",
                        hintText: 'Select your vehicle model',
                        prefixIcon: ImageConstant.vehicle,
                        controller: _modelController,
                       
                      ),
                      const SizedBox(height: 16),

                      CustomInputField(
                        label: "License Plate",
                        hintText: 'Input your vehicle license plate number',
                        prefixIcon: ImageConstant.vehicle,
                        controller: _licensePlateController,
                      ),
                      const SizedBox(height: 16),

                      GestureDetector(
                        onTap: _showColorDropdown,
                        child: CustomInputField(
                          label: "Vehicle Colour",
                          hintText: 'Select your vehicle colour',
                          prefixIcon: ImageConstant.imgCalendarUpload,
                          suffixIcon: "assets/images/arrow-down2.svg",
                          controller: _colorController,
                          enabled: false,
                        ),
                      ),
                      const SizedBox(height: 16),

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
                              "Exterior picture of your vehicle",
                              style: AppTextStyles.bodyLarge.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            RichText(
                              text: TextSpan(
                                text: 'Upload a clear exterior picture that captures the plate number. Look at ',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Sample of Exterior Picture',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.brandBlue,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
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
                              "Interior picture of your vehicle",
                              style: AppTextStyles.bodyLarge.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            RichText(
                              text: TextSpan(
                                text: 'Upload a clear interior picture that captures the plate number. Look at ',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Sample of Interior Picture',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.brandBlue,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
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

                      Container(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Vehicle License Certificate",
                              style: AppTextStyles.bodyLarge.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            RichText(
                              text: TextSpan(
                                text: 'Upload the vehicle license document of the car. Look at ',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Sample of Vehicle License Certificate',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.brandBlue,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
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
                        debugPrint('Vehicle Information Next pressed');
                        debugPrint('Vehicle Year: ${_vehicleYearController.text}');
                        debugPrint('Manufacturer: ${_manufacturerController.text}');
                        debugPrint('Model: ${_modelController.text}');
                        debugPrint('License Plate: ${_licensePlateController.text}');
                        debugPrint('Color: ${_colorController.text}');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PaymentInformationScreen(),
                          ),
                        );
                      } : null,
                    ),
                  ),
                ],
              ),
            ),
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
