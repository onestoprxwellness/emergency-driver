import 'package:flutter/material.dart';

/// App Text Styles based on Figma design
class AppTextStyles {
  // Font Families
  static const String onest = 'Onest';
  static const String inter = 'Inter';
  static const String plusJakarta = 'PlusJakartaSans';
  static const String interMedium = 'InterMedium';
  static const String interSemiBold = 'InterSemiBold';
  static const String interBold = 'InterBold';
  static String interRegular = 'InterRegular';

  // Logo Text Styles
  static const TextStyle logoLarge = TextStyle(
    fontFamily: onest,
    fontWeight: FontWeight.w600,
    fontSize: 17.6,
    height: 1.275,
    color: Color(0xFF001C3A),
    letterSpacing: 0,
  );
  
  static const TextStyle logoSmall = TextStyle(
    fontFamily: onest,
    fontWeight: FontWeight.w600,
    fontSize: 4.8,
    height: 1.275,
    color: Color(0xFF001C3A),
    letterSpacing: 0,
  );
  
  // Heading Styles
  static const TextStyle headingLarge = TextStyle(
    fontFamily: plusJakarta,
    fontWeight: FontWeight.w600,
    fontSize: 30,
    height: 1.267,
    color: Color(0xFF191919),
    letterSpacing: -1.0, // -3.33% of font size
  );
  
  static const TextStyle headingMedium = TextStyle(
    fontFamily: plusJakarta,
    fontWeight: FontWeight.w600,
    fontSize: 24,
    height: 1.3,
    color: Color(0xFF191919),
    letterSpacing: -0.8,
  );
  
  static const TextStyle headingSmall = TextStyle(
    fontFamily: plusJakarta,
    fontWeight: FontWeight.w600,
    fontSize: 20,
    height: 1.35,
    color: Color(0xFF191919),
    letterSpacing: -0.6,
  );
  
  // Button Text Styles
  static const TextStyle buttonMedium = TextStyle(
    fontFamily: inter,
    fontWeight: FontWeight.w600,
    fontSize: 14,
    height: 1.429,
    color: Color(0xFFFFFFFF),
    letterSpacing: -0.2, // -1.43% of font size
  );
  
  static const TextStyle buttonSecondary = TextStyle(
    fontFamily: inter,
    fontWeight: FontWeight.w600,
    fontSize: 14,
    height: 1.429,
    color: Color(0xFF077BF8),
    letterSpacing: -0.2,
  );
  
  // Body Text Styles
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: inter,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 1.5,
    color: Color(0xFF191919),
    letterSpacing: 0,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: inter,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 1.429,
    color: Color(0xFF191919),
    letterSpacing: 0,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontFamily: inter,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    height: 1.333,
    color: Color(0xFF6B7280),
    letterSpacing: 0,
  );
  
  // Status Bar Text
  static const TextStyle statusBar = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w500,
    fontSize: 14,
    height: 1.172,
    color: Color(0xFF191919),
    letterSpacing: 0,
  );
  
  // Label Styles
  static const TextStyle labelLarge = TextStyle(
    fontFamily: inter,
    fontWeight: FontWeight.w500,
    fontSize: 14,
    height: 1.429,
    color: Color(0xFF191919),
    letterSpacing: 0,
  );
  
  static const TextStyle labelMedium = TextStyle(
    fontFamily: inter,
    fontWeight: FontWeight.w500,
    fontSize: 12,
    height: 1.333,
    color: Color(0xFF6B7280),
    letterSpacing: 0,
  );
  
  static const TextStyle labelSmall = TextStyle(
    fontFamily: inter,
    fontWeight: FontWeight.w500,
    fontSize: 10,
    height: 1.4,
    color: Color(0xFF6B7280),
    letterSpacing: 0,
  );
}
