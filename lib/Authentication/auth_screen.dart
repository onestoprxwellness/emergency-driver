import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../util/image_constant.dart';
import '../widgets/country_selector.dart';
import '../widgets/custom_image_view.dart';
import 'login_screen.dart';
import 'registration_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';


class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  CountryFlag selectedCountry = CountrySelector.defaultCountries.first;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Color(0xFFFFFFFF), // AppColors.background
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF), // AppColors.background
      body: Column(
        children: [
          _buildHeroImageSection(),
          _buildContentSection(),
           _buildButtonsSection(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0, // 16.h
        vertical: 12.0,   // 12.v
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        SvgPicture.asset(
            ImageConstant.AppLogoNew,
            height: 20.0, // 20.v
            fit: BoxFit.contain,
          ),
          
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
          Positioned.fill(
            child: CustomImageView(
              imagePath: ImageConstant.ambulanceTruck, 
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
          
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: _buildHeader(),
            ),
          ),
          
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
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0, 
        vertical: 16.0,   
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RichText(
            textAlign: TextAlign.left,
            text: const TextSpan(
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontWeight: FontWeight.w600,
                fontSize: 30.0, 
                height: 1.267,
                color: Color(0xFF191919),
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
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0, 
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 16.0), // 16.v
            child: ElevatedButton(
              onPressed: () {
                _handleLogIn();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF000D1C), // AppColors.buttonPrimary
                foregroundColor: const Color(0xFFFFFFFF), // AppColors.textOnPrimary
                disabledBackgroundColor: const Color(0xFF9CA3AF), // AppColors.gray400
                disabledForegroundColor: const Color(0xFFFFFFFF), // AppColors.white
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0), // medium size
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1000),
                ),
                elevation: 0,
                shadowColor: Colors.transparent,
              ),
              child: Text(
                'Log In',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  fontSize: 14.0, // medium button size
                  height: 1.429,
                  color: Color(0xFFFFFFFF),
                  letterSpacing: -0.2,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 16.0), // 16.v
            child: ElevatedButton(
              onPressed: () {
                _handleSignUp();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE5F3FF), // AppColors.buttonSecondary
                foregroundColor: const Color(0xFF077BF8), // AppColors.buttonSecondaryText
                disabledBackgroundColor: const Color(0xFF9CA3AF).withOpacity(0.1), // AppColors.gray400
                disabledForegroundColor: const Color(0xFF9CA3AF), // AppColors.gray400
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0), // medium size
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1000),
                ),
                elevation: 0,
                shadowColor: Colors.transparent,
              ),
              child: Text(
                'Sign Up',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  fontSize: 14.0, // medium button size
                  height: 1.429,
                  color: Color(0xFF077BF8),
                  letterSpacing: -0.2,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 16.0), // 16.v
            child: OutlinedButton(
              onPressed: () {
                _handleContinueSignUp();
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color(0xFFFFFFFF), // AppColors.buttonTertiary
                foregroundColor: const Color(0xFF077BF8), // AppColors.buttonTertiaryText
                disabledForegroundColor: const Color(0xFF9CA3AF), // AppColors.gray400
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0), // medium size
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1000),
                ),
                side: const BorderSide(color: Colors.transparent),
              ),
              child: Text(
                'Continue Sign up',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  fontSize: 14.0, // medium button size
                  height: 1.429,
                  color: Color(0xFF077BF8),
                  letterSpacing: -0.2,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleLogIn() {
    debugPrint('Log In button pressed');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  void _handleSignUp() {
    debugPrint('Sign Up button pressed');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RegistrationScreen(),
      ),
    );
  }

  void _handleContinueSignUp() {
    debugPrint('Continue Sign');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RegistrationScreen(),
      ),
    );
  }
}
