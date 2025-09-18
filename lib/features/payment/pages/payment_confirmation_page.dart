import 'package:flutter/material.dart';
import '../../../util/size_utils.dart';
import '../../../util/image_constant.dart';
import '../../../widgets/custom_image_view.dart';

class PaymentConfirmationPage extends StatelessWidget {
  const PaymentConfirmationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF077BF8),
              Color(0xFF077BF8),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Background pattern with logo marks
            _buildBackgroundPattern(),
            
            Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Success icon
                      _buildSuccessIcon(),
                      
                      SizedBox(height: 32.v),
                      
                      // Text content
                      _buildTextContent(),
                    ],
                  ),
                ),
                
                // Bottom section with button
                _buildBottomSection(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundPattern() {
    return Positioned.fill(
      child: Opacity(
        opacity: 0.05,
        child: Row(
          children: List.generate(6, (columnIndex) => 
            Expanded(
              child: Column(
                children: List.generate(8, (rowIndex) => 
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(10.h),
                      child: CustomImageView(
                        imagePath: ImageConstant.logoLone,
                        color: Colors.white,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }



  Widget _buildSuccessIcon() {
    return Container(
      width: 100.adaptSize,
      height: 100.adaptSize,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Stack(
        children: [
          // Decorative elements around the circle
          Positioned(
            top: -5,
            left: -5,
            child: CustomImageView(
              imagePath: ImageConstant.successConfetti,
              width: 110.adaptSize,
              height: 110.adaptSize,
              color: Colors.white,
            ),
          ),
          // Check mark icon
          Center(
            child: Icon(
              Icons.check,
              color: const Color(0xFF077BF8),
              size: 40.adaptSize,
              weight: 700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextContent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: Column(
        children: [
          Text(
            'Payment Confirmed',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w700,
              fontSize: 30.fSize,
              height: 1.266,
              letterSpacing: -1.0,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: 4.v),
          
          Text(
            'Help is on the way. Click \'View Details\' for full trip and driver information.',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              fontSize: 12.fSize,
              height: 1.5,
              letterSpacing: -0.2,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.h),
      child: Column(
        children: [
          // View Details button
          Builder(
            builder: (context) => InkWell(
              onTap: () {
                // Navigate to dashboard - pop all screens and go to root
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 10.v),
                decoration: BoxDecoration(
                  color: const Color(0xFF000D1C),
                  borderRadius: BorderRadius.circular(1000),
                ),
                child: Center(
                  child: Text(
                    'Go home',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 14.fSize,
                      height: 1.4285714285714286,
                      letterSpacing: -0.2,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          
        ],
      ),
    );
  }
}
