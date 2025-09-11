import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../util/image_constant.dart';
import '../util/size_utils.dart';
import '../widgets/app_button.dart';
import '../widgets/app_logo.dart';
import '../widgets/country_selector.dart';
import '../widgets/custom_image_view.dart';
import 'login_screen.dart';
import 'registration_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  CountryFlag selectedCountry = CountrySelector.defaultCountries.first;

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
      body: Column(
        children: [
          // Hero Image Section
          _buildHeroImageSection(),
          
          // Content Section
          _buildContentSection(),
          
          // Buttons Section
          _buildButtonsSection(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.h,
        vertical: 12.v,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
        Image.asset(
            ImageConstant.AppLogoNew,
            height: 20.v,
            fit: BoxFit.contain,
          ),
          
          // Language/Country Selector
          CountrySelector(
            selectedCountry: selectedCountry,
            countries: CountrySelector.defaultCountries,
            onCountryChanged: (country) {
              setState(() {
                selectedCountry = country;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeroImageSection() {
    return Expanded(
      child: Stack(
        children: [
          // Hero Image - extends to edges
          Positioned.fill(
            child: CustomImageView(
              imagePath: ImageConstant.ambulanceTruck, // Using ambulanceTruck from ImageConstant
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
          
          // Header overlaid on top of hero image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: _buildHeader(),
            ),
          ),
          
          // Optional gradient overlay for better text readability
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.1),
                  ],
                  stops: const [0.6, 1.0],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentSection() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.h,
        vertical: 16.v,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Main heading
          RichText(
            textAlign: TextAlign.left,
            text: TextSpan(
              style: AppTextStyles.headingLarge.copyWith(
                fontSize: 30.fSize,
                height: 1.267,
                letterSpacing: -1.0,
              ),
              children: [
                TextSpan(
                  text: 'Drive, earn, and be the ',
                ),
                TextSpan(
                  text: 'everyday hero your community needs!',
                  style: TextStyle(
                    color: Color(0xFF077BF8), 
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonsSection() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.h,
        vertical: 0,
      ),
      child: Column(
        children: [
          // Log In Button (Primary)
          AppButton(
            text: 'Log In',
            type: AppButtonType.primary,
            size: AppButtonSize.medium,
            onPressed: () {
              // Handle log in navigation
              _handleLogIn();
            },
            margin: EdgeInsets.only(bottom: 16.v),
          ),
          
          // Sign Up Button (Secondary)
          AppButton(
            text: 'Sign Up',
            type: AppButtonType.secondary,
            size: AppButtonSize.medium,
            onPressed: () {
              // Handle sign up navigation
              _handleSignUp();
            },
            margin: EdgeInsets.only(bottom: 16.v),
          ),
          
          // Continue Sign up Button (Tertiary)
          AppButton(
            text: 'Continue Sign up',
            type: AppButtonType.tertiary,
            size: AppButtonSize.medium,
            onPressed: () {
              // Handle continue sign up navigation
              _handleContinueSignUp();
            },
            margin: EdgeInsets.only(bottom: 16.v),
          ),
        ],
      ),
    );
  }

  // Action handlers
  void _handleLogIn() {
    // Navigate to login screen
    debugPrint('Log In button pressed');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  void _handleSignUp() {
    // Navigate to sign up screen
    debugPrint('Sign Up button pressed');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RegistrationScreen(),
      ),
    );
  }

  void _handleContinueSignUp() {
    // Navigate to continue sign up screen
    debugPrint('Continue Sign up button pressed');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RegistrationScreen(),
      ),
    );
  }
}
