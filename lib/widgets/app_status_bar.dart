import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../util/size_utils.dart';

class AppStatusBar extends StatelessWidget {
  final String time;
  final bool isDarkMode;
  final EdgeInsetsGeometry? padding;

  const AppStatusBar({
    Key? key,
    required this.time,
    this.isDarkMode = false,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Set system overlay style based on dark mode
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDarkMode ? Brightness.dark : Brightness.light,
      ),
    );

    return Container(
      padding: padding ?? EdgeInsets.symmetric(
        horizontal: 24.h,
        vertical: 8.v,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Time
          Text(
            time,
            style: AppTextStyles.statusBar.copyWith(
              color: isDarkMode ? AppColors.white : AppColors.textPrimary,
            ),
          ),
          
          // Status icons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // WiFi icon
              _buildWiFiIcon(),
              SizedBox(width: 4.h),
              
              // Network strength icon
              _buildNetworkIcon(),
              SizedBox(width: 4.h),
              
              // Battery icon
              _buildBatteryIcon(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWiFiIcon() {
    return Container(
      width: 16.h,
      height: 16.h,
      child: CustomPaint(
        painter: WiFiPainter(
          color: isDarkMode ? AppColors.white : AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildNetworkIcon() {
    return Container(
      width: 16.h,
      height: 16.h,
      child: CustomPaint(
        painter: NetworkPainter(
          color: isDarkMode ? AppColors.white : AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildBatteryIcon() {
    return Container(
      width: 16.h,
      height: 16.h,
      child: CustomPaint(
        painter: BatteryPainter(
          color: isDarkMode ? AppColors.white : AppColors.textPrimary,
          level: 0.9, // 90% battery
        ),
      ),
    );
  }
}

class WiFiPainter extends CustomPainter {
  final Color color;

  WiFiPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw WiFi signal bars
    final barWidth = size.width * 0.15;
    final barHeight = size.height * 0.6;
    
    // 3 bars with increasing height
    for (int i = 0; i < 3; i++) {
      final x = size.width * 0.2 + (i * size.width * 0.25);
      final height = barHeight * (0.4 + (i * 0.3));
      final y = size.height - height - (size.height * 0.2);
      
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, barWidth, height),
          Radius.circular(1),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class NetworkPainter extends CustomPainter {
  final Color color;

  NetworkPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw 4 signal bars
    final barWidth = size.width * 0.12;
    
    for (int i = 0; i < 4; i++) {
      final x = size.width * 0.1 + (i * size.width * 0.2);
      final height = size.height * (0.3 + (i * 0.2));
      final y = size.height - height - (size.height * 0.1);
      
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, barWidth, height),
          Radius.circular(1),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class BatteryPainter extends CustomPainter {
  final Color color;
  final double level; // 0.0 to 1.0

  BatteryPainter({required this.color, required this.level});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Battery outline
    final batteryRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.15,
        size.height * 0.25,
        size.width * 0.6,
        size.height * 0.5,
      ),
      Radius.circular(2),
    );
    
    canvas.drawRRect(batteryRect, paint);
    
    // Battery tip
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.78,
          size.height * 0.35,
          size.width * 0.1,
          size.height * 0.3,
        ),
        Radius.circular(1),
      ),
      fillPaint,
    );
    
    // Battery fill
    final fillWidth = (size.width * 0.54) * level; // 0.6 - padding
    if (fillWidth > 0) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            size.width * 0.18,
            size.height * 0.3,
            fillWidth,
            size.height * 0.4,
          ),
          Radius.circular(1),
        ),
        fillPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
