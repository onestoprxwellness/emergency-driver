import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:onestoprx_driver/util/image_constant.dart';
import 'package:stacked/stacked.dart';
import '../../../util/size_utils.dart';
import '../viewmodels/payment_summary_viewmodel.dart';
import 'payment_confirmation_page.dart';

class PaymentSummaryPage extends StatelessWidget {
  const PaymentSummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PaymentSummaryViewModel>.reactive(
      viewModelBuilder: () => PaymentSummaryViewModel(),
      onViewModelReady: (viewModel) {
        // Set up navigation callbacks
        viewModel.onNavigateBack = () {
          Navigator.pop(context);
        };
        
        viewModel.onNavigateToConfirmation = () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PaymentConfirmationPage(),
            ),
          );
        };
      },
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFF2F4F7),
          body: SafeArea(
            child: Column(
              children: [
                // Header - App Bar Style
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.v),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back button
                      InkWell(
                        onTap: viewModel.goBack,
                        child: Container(
                          padding: EdgeInsets.all(8.adaptSize),
                          decoration: BoxDecoration(
                            // color: Colors.white,
                            border: Border.all(color: const Color(0xFFD0D5DD)),
                            borderRadius: BorderRadius.circular(1000),
                          ),
                          child: SvgPicture.asset(
                            ImageConstant.image_arrowLeft, 
                            width: 20.adaptSize,
                            height: 20.adaptSize,
                            color: const Color(0xFF1D2939),
                          ),
                        ),
                      ),
                      
                      // Title
                      Text(
                        'Journey summary',
                        style: TextStyle(
                          fontFamily: 'InterSemiBold',
                          fontWeight: FontWeight.w600,
                          fontSize: 14.fSize,
                          height: 1.4285714285714286,
                          letterSpacing: -0.2,
                          color: const Color(0xFF101828),
                        ),
                      ),
                      
                      // Placeholder for balance
                      Container(
                        width: 36.adaptSize,
                        height: 36.adaptSize,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(1000),
                        ),
                      ),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Address Section - Full Width
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.v),
                          child: Column(
                            children: [
                              // Pickup Address Card
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(16.adaptSize),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'PICKUP ADDRESS',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 10.fSize,
                                        height: 1.6,
                                        color: const Color(0xFF475467),
                                      ),
                                    ),
                                    Text(
                                      '16 Computer village, Ikeja, Lagos',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.fSize,
                                        height: 1.4285714285714286,
                                        letterSpacing: -0.2,
                                        color: const Color(0xFF101828),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              SizedBox(height: 8.v),
                              
                              // Drop-off Address Card
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(16.adaptSize),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'DROP-OFF ADDRESS',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 10.fSize,
                                        height: 1.6,
                                        color: const Color(0xFF475467),
                                      ),
                                    ),
                                    Text(
                                      'Happy Luis Hospital, Ikeja, Lagos',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.fSize,
                                        height: 1.4285714285714286,
                                        letterSpacing: -0.2,
                                        color: const Color(0xFF101828),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Payment Method Section
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 16.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 8.v),
                                child: Text(
                                  'PAYMENT METHOD',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10.fSize,
                                    height: 1.6,
                                    color: const Color(0xFF101828),
                                  ),
                                ),
                              ),

                              // Payment Options
                              Column(
                                children: [
                                  // Platform Payment (Only shaded when selected)
                                  _buildPaymentOption(
                                    viewModel,
                                    'platform',
                                    'Platform payment',
                                    '₦7,600',
                                    'Paid',
                                    ImageConstant.wallet, // Platform payment icon
                                    isSelected: viewModel.selectedPaymentMethod == 'platform',
                                    isPaid: true,
                                    iconColor: const Color(0xFF1D9C7D),
                                    backgroundColor: viewModel.selectedPaymentMethod == 'platform' 
                                        ? const Color(0x0D1D9C7D) 
                                        : Colors.white,
                                    borderColor: viewModel.selectedPaymentMethod == 'platform'
                                        ? const Color(0xFF1D9C7D)
                                        : Colors.transparent,
                                  ),
                                  
                                  SizedBox(height: 8.v),
                                  
                                  // Cash Option
                                  _buildPaymentOption(
                                    viewModel,
                                    'cash',
                                    'Cash',
                                    null,
                                    null,
                                    ImageConstant.cashIcon, 
                                    isSelected: viewModel.selectedPaymentMethod == 'cash',
                                    isPaid: false,
                                  ),
                                  
                                  SizedBox(height: 8.v),
                                  
                                  // Didn't receive payment Option
                                  _buildPaymentOption(
                                    viewModel,
                                    'no_payment',
                                    'Didn\'t receive payment',
                                    null,
                                    null,
                                    ImageConstant.noMoney, // No payment icon
                                    isSelected: viewModel.selectedPaymentMethod == 'no_payment',
                                    isPaid: false,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 24.v),

                        // Payment Summary Section
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 16.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 8.v),
                                child: Text(
                                  'PAYMENT SUMMARY',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10.fSize,
                                    height: 1.6,
                                    color: const Color(0xFF101828),
                                  ),
                                ),
                              ),

                              // Summary Items - White Background Container
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(16.adaptSize),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  children: [
                                    _buildSummaryRow('Total Items (2)', '₦7,600'),
                                    SizedBox(height: 4.v),
                                    _buildSummaryRow('VAT', '₦0'),
                                    SizedBox(height: 4.v),
                                    _buildSummaryRow('Service Fee', '- ₦500'),
                                    SizedBox(height: 8.v),
                                    
                                    // Total with border
                                    Container(
                                      padding: EdgeInsets.symmetric(vertical: 8.v),
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          top: BorderSide(color: Color(0xFFEAECF0), width: 1),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Total',
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12.fSize,
                                              height: 1.5,
                                              letterSpacing: -0.2,
                                              color: const Color(0xFF101828),
                                            ),
                                          ),
                                          Text(
                                            '₦7,100',
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14.fSize,
                                              height: 1.4285714285714286,
                                              letterSpacing: -0.2,
                                              color: const Color(0xFF101828),
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

                        SizedBox(height: 40.v), // Extra space for button
                      ],
                    ),
                  ),
                ),

                // Confirm Payment Button
                Container(
                  padding: EdgeInsets.all(16.adaptSize),
                  child: ElevatedButton(
                    onPressed: viewModel.canConfirmPayment ? viewModel.confirmPayment : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: viewModel.canConfirmPayment 
                          ? const Color(0xFF000D1C) 
                          : const Color(0xFFD0D5DD),
                      padding: EdgeInsets.symmetric(vertical: 12.v),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(1000),
                      ),
                      minimumSize: Size(double.infinity, 48.v),
                    ),
                    child: Text(
                      'Confirm Payment',
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

                // Navigation bar space
                Container(
                  height: 24.v,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Container(
                      width: 108.h,
                      height: 4.v,
                      decoration: BoxDecoration(
                        color: const Color(0xFF101828),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPaymentOption(
    PaymentSummaryViewModel viewModel,
    String value,
    String title,
    String? amount,
    String? status,
    String iconAsset, // Add icon parameter
    {
    required bool isSelected,
    required bool isPaid,
    Color? iconColor,
    Color? backgroundColor,
    Color? borderColor,
  }) {
    return InkWell(
      onTap: () => viewModel.selectPaymentMethod(value),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 16.v),
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          border: Border.all(
            color: borderColor ?? (isSelected ? const Color(0xFF1D9C7D) : Colors.transparent),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 28.adaptSize,
              height: 28.adaptSize,
              child: SvgPicture.asset(
                iconAsset, 
              ),
            ),
            
            SizedBox(width: 8.h),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 14.fSize,
                      height: 1.4285714285714286,
                      letterSpacing: -0.2,
                      color: const Color(0xFF101828),
                    ),
                  ),
                  if (amount != null && status != null)
                    Row(
                      children: [
                        Text(
                          amount,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            fontSize: 12.fSize,
                            height: 1.5,
                            letterSpacing: -0.2,
                            color: const Color(0xFF475467),
                          ),
                        ),
                        Text(
                          ' • ',
                          style: TextStyle(
                            fontFamily: 'Helvetica Neue',
                            fontWeight: FontWeight.w400,
                            fontSize: 14.fSize,
                            height: 1.193,
                            color: Colors.black,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 2.v),
                          decoration: BoxDecoration(
                            color: const Color(0x1A12B76A),
                            borderRadius: BorderRadius.circular(1000),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              fontSize: 10.fSize,
                              height: 1.6,
                              color: const Color(0xFF039855),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            
            // Selection indicator
            if (isSelected)
              Container(
                width: 18.adaptSize,
                height: 18.adaptSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF1D9C7D),
                ),
                child: Icon(
                  Icons.check,
                  size: 12.adaptSize,
                  color: Colors.white,
                ),
              )
            else
              Container(
                width: 18.adaptSize,
                height: 18.adaptSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFA4A7B5),
                    width: 1,
                  ),
                  color: Colors.transparent,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            fontSize: 12.fSize,
            height: 1.5,
            letterSpacing: -0.2,
            color: const Color(0xFF101828),
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            fontSize: 14.fSize,
            height: 1.4285714285714286,
            letterSpacing: -0.2,
            color: const Color(0xFF101828),
          ),
        ),
      ],
    );
  }
}
