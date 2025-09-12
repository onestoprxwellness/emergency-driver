import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';
import '../../../util/image_constant.dart';
import '../../../util/size_utils.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../viewmodels/trips_activity_viewmodel.dart';
import '../../payment/pages/payment_summary_page.dart';
import '../../chat/pages/patient_chat_page.dart';
import '../../chat/pages/hospital_chat_page.dart';

class TripsActivity extends StackedView<TripsActivityViewModel> {
  final Position? currentPosition;
  final bool hasLocationPermission;
  
  const TripsActivity({
    super.key,
    this.currentPosition,
    this.hasLocationPermission = false,
  });

  @override
  Widget builder(
    BuildContext context,
    TripsActivityViewModel viewModel,
    Widget? child,
  ) {
    // Set up navigation callback
    viewModel.onNavigateToPayment = () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PaymentSummaryPage(),
        ),
      );
    };

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Full screen map
          Positioned.fill(
            child: GoogleMap(
              initialCameraPosition: viewModel.initialCameraPosition,
              onMapCreated: viewModel.onMapCreated,
              markers: viewModel.mapMarkers,
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              compassEnabled: false,
            ),
          ),


          // Top right go offline button
          Positioned(
            top: 50.v,
            right: 16.h,
            child: InkWell(
              onTap: () => viewModel.goOffline(context),
              child: Container(
                width: 44.adaptSize,
                height: 44.adaptSize,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFEAECF0)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromRGBO(77, 79, 82, 0.16),
                      offset: Offset(0, 2.v),
                      blurRadius: 4.adaptSize,
                    ),
                    BoxShadow(
                      color: const Color.fromRGBO(77, 79, 82, 0.06),
                      offset: Offset(0, -1.v),
                      blurRadius: 2.adaptSize,
                    ),
                  ],
                ),
                child: SvgPicture.asset(
                  ImageConstant.goOffline,
                  height: 24.adaptSize,
                  width: 24.adaptSize,
                ),
              ),
            ),
          ),

          // GPS/Location button positioned near emergency banner
          Positioned(
            right: 16.h,
            bottom: 240.v, 
            child: Container(
              width: 44.adaptSize,
              height: 44.adaptSize,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFEAECF0)),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromRGBO(77, 79, 82, 0.16),
                    offset: Offset(0, 2.v),
                    blurRadius: 4.adaptSize,
                  ),
                  BoxShadow(
                    color: const Color.fromRGBO(77, 79, 82, 0.04),
                    offset: Offset(0, -1.v),
                    blurRadius: 2.adaptSize,
                  ),
                ],
              ),
              child: IconButton(
                onPressed: viewModel.centerMapOnLocation,
                icon: Icon(
                  Icons.my_location,
                  size: 24.adaptSize,
                  color: const Color(0xFF1D2939),
                ),
              ),
            ),
          ),

          // Bottom sheet with emergency banner & waiting panel (only if still waiting)
          if (viewModel.showWaitingPanel)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFEAECF0)),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.v),
                      decoration: BoxDecoration(
                        color: const Color(0xFF077BF8),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.flash_on,
                            size: 16.adaptSize,
                            color: const Color(0xFFF79009),
                          ),
                          SizedBox(width: 8.h),
                          Flexible(
                            child: Text(
                              'Emergency requests typically takes 30 minutes',
                              style: TextStyle(
                                fontSize: 12.fSize,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                                fontFamily: 'Inter',
                                letterSpacing: -0.2,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Distance controls
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 16.v),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Minus button
                          Container(
                            width: 44.adaptSize,
                            height: 44.adaptSize,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFFEAECF0)),
                            ),
                            child: IconButton(
                              onPressed: viewModel.decreaseDistance,
                              icon: Icon(
                                Icons.remove,
                                size: 24.adaptSize,
                                color: const Color(0xFF1D2939),
                              ),
                            ),
                          ),
                          SizedBox(width: 16.h),
                          
                          // Distance text
                          Text(
                            '${viewModel.distance}km',
                            style: TextStyle(
                              fontSize: 18.fSize,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF000407),
                              fontFamily: 'Plus Jakarta Sans',
                              letterSpacing: -0.5,
                            ),
                          ),
                          SizedBox(width: 16.h),
                          
                          // Plus button
                          Container(
                            width: 44.adaptSize,
                            height: 44.adaptSize,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFFEAECF0)),
                            ),
                            child: IconButton(
                              onPressed: viewModel.increaseDistance,
                              icon: Icon(
                                Icons.add,
                                size: 24.adaptSize,
                                color: const Color(0xFF1D2939),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Waiting message
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.v),
                      child: Column(
                        children: [
                          Text(
                            'Waiting for a request...',
                            style: TextStyle(
                              fontSize: 24.fSize,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF101828),
                              fontFamily: 'Plus Jakarta Sans',
                              letterSpacing: -1.0,
                              height: 1.33,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          
                        
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Emergency Request Bottom Sheet
          if (viewModel.showEmergencyRequest)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildEmergencyRequestBottomSheet(viewModel),
            ),

          // Accepted Request Bottom Sheet (NEW)
          if (viewModel.showAcceptedRequest)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildAcceptedRequestBottomSheet(viewModel),
            ),

          // Waiting to Onboard Bottom Sheet (NEWEST)
          if (viewModel.showWaitingToOnboard)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildWaitingToOnboardBottomSheet(viewModel),
            ),

          // Hospital Route Bottom Sheet (FINAL)
          if (viewModel.showHospitalRoute)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildHospitalRouteBottomSheet(viewModel),
            ),
        ],
      ),
    );
  }

  Widget _buildEmergencyRequestBottomSheet(TripsActivityViewModel viewModel) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F7), // Changed to #F2F4F7
        border: Border.all(color: const Color(0xFFEAECF0)),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(77, 79, 82, 0.2),
            offset: Offset(0, -1.v),
            blurRadius: 20.adaptSize,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Dragger
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.v),
            child: Container(
              width: 80.h,
              height: 4.v,
              decoration: BoxDecoration(
                color: AppColors.gray400,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),

          // Patient's Information Card
          Container(
            margin: EdgeInsets.all(8.adaptSize),
            padding: EdgeInsets.all(16.adaptSize), // Increased padding
            decoration: BoxDecoration(
              color: Colors.white, // Ensure white background
              borderRadius: BorderRadius.circular(12), // Ensure 12px border radius
              border: Border.all(color: const Color(0xFFEAECF0)), // Optional: add border for definition
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with dropdown - CLICKABLE
                InkWell(
                  onTap: viewModel.togglePatientInfo,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Patient\'s Information',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          fontSize: 14.fSize,
                          height: 1.4285714285714286,
                          letterSpacing: -0.2,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      AnimatedRotation(
                        turns: viewModel.isPatientInfoExpanded ? 0.5 : 0.0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          size: 18.adaptSize,
                          color: AppColors.gray400,
                        ),
                      ),
                    ],
                  ),
                ),

                // Animated patient details
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: viewModel.isPatientInfoExpanded ? null : 0,
                  child: viewModel.isPatientInfoExpanded
                      ? Column(
                          children: [
                            SizedBox(height: 8.v),

                            // Patient Details
                            Column(
                              children: [
                                _buildInfoRow(
                                  ImageConstant.imgUser,
                                  'Gender',
                                  'Female',
                                ),
                                SizedBox(height: 8.v),
                                _buildInfoRow(
                                  ImageConstant.ageGroupIcon,
                                  'Age group',
                                  '20 to 39 years',
                                ),
                                SizedBox(height: 8.v),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          ImageConstant.emergencyLevel,
                                          width: 14.adaptSize,
                                          height: 14.adaptSize,
                                        ),
                                        SizedBox(width: 8.h),
                                        Text(
                                          'Emergency level',
                                          style: AppTextStyles.bodySmall.copyWith(
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 2.v),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFEF0C7),
                                        border: Border.all(color: const Color(0xFFF79009)),
                                        borderRadius: BorderRadius.circular(1000),
                                      ),
                                      child: Text(
                                        'Level 3',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 10.fSize,
                                          height: 1.6,
                                          color: const Color(0xFFDC6803),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.v),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          ImageConstant.cashIcon,
                                          width: 14.adaptSize,
                                          height: 14.adaptSize,
                                        ),
                                        SizedBox(width: 8.h),
                                        Text(
                                          'Payment',
                                          style: AppTextStyles.bodySmall.copyWith(
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 2.v),
                                      decoration: BoxDecoration(
                                        color: AppColors.surface,
                                        borderRadius: BorderRadius.circular(1000),
                                      ),
                                      child: Text(
                                        'Pending',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 10.fSize,
                                          height: 1.6,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),

          // Location Information
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8.h),
            padding: EdgeInsets.all(16.adaptSize), // Increased padding
            decoration: BoxDecoration(
              color: Colors.white, // White background for container
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFEAECF0)), // Optional: add border for definition
            ),
            child: Column(
              children: [
                // Your Location
                Container(
                  padding: EdgeInsets.all(12.adaptSize), // Increased padding
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F4F7), // Changed to #F2F4F7
                    borderRadius: BorderRadius.circular(56),
                  ),
                  child: Row(
                    children: [
            SvgPicture.asset(
              ImageConstant.locationUser,
              width: 24.adaptSize,
              height: 24.adaptSize,
            ),
                      SizedBox(width: 8.h),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your location',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                fontSize: 12.fSize,
                                height: 1.5,
                                letterSpacing: -0.2,
                                color: const Color(0x80000000), // rgba(0, 0, 0, 0.5)
                              ),
                            ),
                            Text(
                              'Current Location',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                fontSize: 14.fSize,
                                height: 1.4285714285714286,
                                letterSpacing: -0.2,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Dashed line - Positioned at left/start
                Container(
                  margin: EdgeInsets.symmetric(vertical: 12.v),
                  width: double.infinity,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.only(left: 32.h), // Align with the icons
                      width: 1,
                      height: 38.v,
                      child: CustomPaint(
                        painter: DashedLinePainter(),
                      ),
                    ),
                  ),
                ),

                // Patient Location
                Container(
                  padding: EdgeInsets.all(12.adaptSize), // Increased padding
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F4F7), // Changed to #F2F4F7
                    borderRadius: BorderRadius.circular(56),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        ImageConstant.pinLocation,
                        width: 24.adaptSize,
                        height: 24.adaptSize,
                      ),
                      SizedBox(width: 8.h),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Routing to',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                fontSize: 12.fSize,
                                height: 1.5,
                                letterSpacing: -0.2,
                                color: const Color(0x80000000), // rgba(0, 0, 0, 0.5)
                              ),
                            ),
                            Text(
                              'Patient\'s address',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                fontSize: 14.fSize,
                                height: 1.4285714285714286,
                                letterSpacing: -0.2,
                                color: AppColors.textPrimary,
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

          // Time and Distance Info
          Container(
            margin: EdgeInsets.all(8.adaptSize),
            padding: EdgeInsets.all(16.adaptSize), // Increased padding
            decoration: BoxDecoration(
              color: Colors.white, // White background
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFEAECF0)), // Optional: add border for definition
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        '20 Minutes',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          fontSize: 18.fSize,
                          height: 1.5555555555555556,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4.v),
                      Text(
                        'ETA',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          fontSize: 12.fSize,
                          height: 1.5,
                          letterSpacing: -0.2,
                          color: const Color(0xFF667085),
                        ),
                      ),
                    ],
                  ),
                ),
                // Divider
                Container(
                  width: 1,
                  height: 50.v,
                  color: const Color(0xFFEAECF0),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        '20 Km',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          fontSize: 18.fSize,
                          height: 1.5555555555555556,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4.v),
                      Text(
                        'DISTANCE',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          fontSize: 12.fSize,
                          height: 1.5,
                          letterSpacing: -0.2,
                          color: const Color(0xFF667085),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Call and Message buttons - COMMENTED OUT
          /*
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8.h),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8.v),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6F5FF),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          ImageConstant.imgUser,
                          width: 24.adaptSize,
                          height: 24.adaptSize,
                          color: AppColors.primaryBlue,
                        ),
                        SizedBox(height: 4.v),
                        Text(
                          'Call',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            fontSize: 10.fSize,
                            height: 1.6,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 16.h),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8.v),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6F5FF),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          ImageConstant.imgUser,
                          width: 24.adaptSize,
                          height: 24.adaptSize,
                          color: AppColors.primaryBlue,
                        ),
                        SizedBox(height: 4.v),
                        Text(
                          'Message',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            fontSize: 10.fSize,
                            height: 1.6,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          */

          // Action Buttons
          Container(
            padding: EdgeInsets.all(16.adaptSize),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: viewModel.rejectEmergencyRequest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFEF3F2), // Light red background from Figma
                      padding: EdgeInsets.symmetric(vertical: 12.v),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(1000),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Reject',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        fontSize: 14.fSize,
                        height: 1.4285714285714286,
                        letterSpacing: -0.2,
                        color: const Color(0xFFF04438),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.h),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: viewModel.acceptEmergencyRequest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: EdgeInsets.symmetric(vertical: 12.v),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(1000),
                      ),
                    ),
                    child: Text(
                      'Accept',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        fontSize: 14.fSize,
                        height: 1.4285714285714286,
                        letterSpacing: -0.2,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAcceptedRequestBottomSheet(TripsActivityViewModel viewModel) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F7), // #F2F4F7 background
        border: Border.all(color: const Color(0xFFEAECF0)),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(77, 79, 82, 0.2),
            offset: Offset(0, -1.v),
            blurRadius: 20.adaptSize,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Dragger
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.v),
            child: Container(
              width: 80.h,
              height: 4.v,
              decoration: BoxDecoration(
                color: AppColors.gray400,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),

          // Patient's Information Card
          Container(
            margin: EdgeInsets.all(8.adaptSize),
            padding: EdgeInsets.all(16.adaptSize),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFEAECF0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with dropdown - CLICKABLE
                InkWell(
                  onTap: viewModel.togglePatientInfo,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Patient\'s Information',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          fontSize: 14.fSize,
                          height: 1.4285714285714286,
                          letterSpacing: -0.2,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      AnimatedRotation(
                        turns: viewModel.isPatientInfoExpanded ? 0.5 : 0.0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          size: 18.adaptSize,
                          color: AppColors.gray400,
                        ),
                      ),
                    ],
                  ),
                ),

                // Animated patient details
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: viewModel.isPatientInfoExpanded ? null : 0,
                  child: viewModel.isPatientInfoExpanded
                      ? Column(
                          children: [
                            SizedBox(height: 8.v),

                            // Patient Details
                            Column(
                              children: [
                                _buildInfoRow(
                                  ImageConstant.imgUser,
                                  'Gender',
                                  'Female',
                                ),
                                SizedBox(height: 8.v),
                                _buildInfoRow(
                                  ImageConstant.ageGroupIcon,
                                  'Age group',
                                  '20 to 39 years',
                                ),
                                SizedBox(height: 8.v),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          ImageConstant.emergencyLevel,
                                          width: 14.adaptSize,
                                          height: 14.adaptSize,
                                         
                                        ),
                                        SizedBox(width: 8.h),
                                        Text(
                                          'Emergency level',
                                          style: AppTextStyles.bodySmall.copyWith(
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 2.v),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFEF0C7),
                                        border: Border.all(color: const Color(0xFFF79009)),
                                        borderRadius: BorderRadius.circular(1000),
                                      ),
                                      child: Text(
                                        'Level 3',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 10.fSize,
                                          height: 1.6,
                                          color: const Color(0xFFDC6803),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.v),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          ImageConstant.cashIcon,
                                          width: 14.adaptSize,
                                          height: 14.adaptSize,
                                         
                                        ),
                                        SizedBox(width: 8.h),
                                        Text(
                                          'Payment',
                                          style: AppTextStyles.bodySmall.copyWith(
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 2.v),
                                      decoration: BoxDecoration(
                                        color: AppColors.surface,
                                        borderRadius: BorderRadius.circular(1000),
                                      ),
                                      child: Text(
                                        'Pending',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 10.fSize,
                                          height: 1.6,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),

          // Location Information
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8.h),
            padding: EdgeInsets.all(16.adaptSize),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFEAECF0)),
            ),
            child: Column(
              children: [
                // Your Location
                Container(
                  padding: EdgeInsets.all(12.adaptSize),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F4F7),
                    borderRadius: BorderRadius.circular(56),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        ImageConstant.locationUser,
                        width: 24.adaptSize,
                        height: 24.adaptSize,
                       
                      ),
                      SizedBox(width: 8.h),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your location',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                fontSize: 12.fSize,
                                height: 1.5,
                                letterSpacing: -0.2,
                                color: const Color(0x80000000),
                              ),
                            ),
                            Text(
                              'Current Location',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                fontSize: 14.fSize,
                                height: 1.4285714285714286,
                                letterSpacing: -0.2,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Dashed line - Positioned at left/start
                Container(
                  margin: EdgeInsets.symmetric(vertical: 12.v),
                  width: double.infinity,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.only(left: 32.h),
                      width: 1,
                      height: 38.v,
                      child: CustomPaint(
                        painter: DashedLinePainter(),
                      ),
                    ),
                  ),
                ),

                // Patient Location
                Container(
                  padding: EdgeInsets.all(12.adaptSize),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F4F7),
                    borderRadius: BorderRadius.circular(56),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        ImageConstant.pinLocation,
                        width: 24.adaptSize,
                        height: 24.adaptSize,
                      ),
                      SizedBox(width: 8.h),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Routing to',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                fontSize: 12.fSize,
                                height: 1.5,
                                letterSpacing: -0.2,
                                color: const Color(0x80000000),
                              ),
                            ),
                            Text(
                              'Patient\'s address',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                fontSize: 14.fSize,
                                height: 1.4285714285714286,
                                letterSpacing: -0.2,
                                color: AppColors.textPrimary,
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

          // Time and Distance Info with Call/Message Buttons
          Container(
            margin: EdgeInsets.all(8.adaptSize),
            padding: EdgeInsets.all(16.adaptSize),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFEAECF0)),
            ),
            child: Column(
              children: [
               
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // ETA Section
                    Column(
                      children: [
                        Text(
                          '20 Minutes',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            fontSize: 18.fSize,
                            height: 1.5555555555555556,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 4.v),
                        Text(
                          'ETA',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            fontSize: 12.fSize,
                            height: 1.5,
                            letterSpacing: -0.2,
                            color: const Color(0xFF667085),
                          ),
                        ),
                      ],
                    ),
                    
                    // Distance Section
                    Column(
                      children: [
                        Text(
                          '20 Km',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            fontSize: 18.fSize,
                            height: 1.5555555555555556,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 4.v),
                        Text(
                          'DISTANCE',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            fontSize: 12.fSize,
                            height: 1.5,
                            letterSpacing: -0.2,
                            color: const Color(0xFF667085),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 16.v),

                // Call and Message Buttons Row
                Builder(
                  builder: (builderContext) => Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            // TODO: Implement call functionality
                            print('Calling patient');
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12.v),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE6F5FF),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  ImageConstant.call1,
                                  width: 24.adaptSize,
                                  height: 24.adaptSize,
                                ),
                                SizedBox(height: 4.v),
                                Text(
                                  'Call',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10.fSize,
                                    height: 1.6,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16.h),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              builderContext,
                              MaterialPageRoute(
                                builder: (context) => const PatientChatPage(),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12.v),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE6F5FF),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  ImageConstant.messages1,
                                  width: 24.adaptSize,
                                  height: 24.adaptSize,
                                ),
                                SizedBox(height: 4.v),
                                Text(
                                  'Message',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10.fSize,
                                    height: 1.6,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Single "Arrived at Location" Button
          Container(
            padding: EdgeInsets.all(16.adaptSize),
            child: ElevatedButton(
              onPressed: viewModel.arrivedAtLocation,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(vertical: 12.v),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1000),
                ),
                minimumSize: Size(double.infinity, 48.v),
              ),
              child: Text(
                'Arrived at Location',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  fontSize: 14.fSize,
                  height: 1.4285714285714286,
                  letterSpacing: -0.2,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String iconPath, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              iconPath,
              width: 14.adaptSize,
              height: 14.adaptSize,
              color: AppColors.gray400,
            ),
            SizedBox(width: 8.h),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                fontSize: 12.fSize,
                height: 1.5,
                letterSpacing: -0.2,
                color: const Color(0xFF344054),
              ),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            fontSize: 12.fSize,
            height: 1.5,
            letterSpacing: -0.2,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildWaitingToOnboardBottomSheet(TripsActivityViewModel viewModel) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F7), // #F2F4F7 background
        border: Border.all(color: const Color(0xFFEAECF0)),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(77, 79, 82, 0.2),
            offset: Offset(0, -1.v),
            blurRadius: 20.adaptSize,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Dragger
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.v),
            child: Container(
              width: 80.h,
              height: 4.v,
              decoration: BoxDecoration(
                color: AppColors.gray400,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),

          // Patient's Information Card (same as before)
          Container(
            margin: EdgeInsets.all(8.adaptSize),
            padding: EdgeInsets.all(16.adaptSize),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFEAECF0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with dropdown - CLICKABLE
                InkWell(
                  onTap: viewModel.togglePatientInfo,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Patient\'s Information',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          fontSize: 14.fSize,
                          height: 1.4285714285714286,
                          letterSpacing: -0.2,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      AnimatedRotation(
                        turns: viewModel.isPatientInfoExpanded ? 0.5 : 0.0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          size: 18.adaptSize,
                          color: AppColors.gray400,
                        ),
                      ),
                    ],
                  ),
                ),

                // Animated patient details
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: viewModel.isPatientInfoExpanded ? null : 0,
                  child: viewModel.isPatientInfoExpanded
                      ? Column(
                          children: [
                            SizedBox(height: 8.v),

                            // Patient Details
                            Column(
                              children: [
                                _buildInfoRow(
                                  ImageConstant.imgUser,
                                  'Gender',
                                  'Female',
                                ),
                                SizedBox(height: 8.v),
                                _buildInfoRow(
                                  ImageConstant.ageGroupIcon,
                                  'Age group',
                                  '20 to 39 years',
                                ),
                                SizedBox(height: 8.v),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          ImageConstant.emergencyLevel,
                                          width: 14.adaptSize,
                                          height: 14.adaptSize,
                                        ),
                                        SizedBox(width: 8.h),
                                        Text(
                                          'Emergency level',
                                          style: AppTextStyles.bodySmall.copyWith(
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 2.v),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFEF0C7),
                                        border: Border.all(color: const Color(0xFFF79009)),
                                        borderRadius: BorderRadius.circular(1000),
                                      ),
                                      child: Text(
                                        'Level 3',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 10.fSize,
                                          height: 1.6,
                                          color: const Color(0xFFDC6803),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.v),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          ImageConstant.cashIcon,
                                          width: 14.adaptSize,
                                          height: 14.adaptSize,
                                        ),
                                        SizedBox(width: 8.h),
                                        Text(
                                          'Payment',
                                          style: AppTextStyles.bodySmall.copyWith(
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 2.v),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFD1FADF), // Light green background for "Paid"
                                        borderRadius: BorderRadius.circular(1000),
                                      ),
                                      child: Text(
                                        'Paid',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 10.fSize,
                                          height: 1.6,
                                          color: const Color(0xFF027A48), // Green text for "Paid"
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),

          // Waiting to Onboard with Countdown Timer
          Container(
            margin: EdgeInsets.all(8.adaptSize),
            padding: EdgeInsets.all(16.adaptSize),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFEAECF0)),
            ),
            child: Column(
              children: [
                // Waiting to onboard text and countdown
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16.adaptSize,
                          color: AppColors.gray400,
                        ),
                        SizedBox(width: 8.h),
                        Text(
                          'Waiting to onboard',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            fontSize: 12.fSize,
                            height: 1.5,
                            letterSpacing: -0.2,
                            color: const Color(0xFF344054),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      viewModel.onboardCountdown,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        fontSize: 24.fSize,
                        height: 1.33,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16.v),

                // Call and Message Buttons Row
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12.v),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6F5FF),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              ImageConstant.call1,
                              width: 24.adaptSize,
                              height: 24.adaptSize,
                              color: AppColors.primaryBlue,
                            ),
                            SizedBox(height: 4.v),
                            Text(
                              'Call',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                fontSize: 10.fSize,
                                height: 1.6,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 16.h),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12.v),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6F5FF),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              ImageConstant.messages1,
                              width: 24.adaptSize,
                              height: 24.adaptSize,
                              color: AppColors.primaryBlue,
                            ),
                            SizedBox(height: 4.v),
                            Text(
                              'Message',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                fontSize: 10.fSize,
                                height: 1.6,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Passenger Onboarded Button
          Container(
            padding: EdgeInsets.all(16.adaptSize),
            child: ElevatedButton(
              onPressed: viewModel.passengerOnboarded,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B1D29), // Dark navy blue from image
                padding: EdgeInsets.symmetric(vertical: 12.v),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1000),
                ),
                minimumSize: Size(double.infinity, 48.v),
              ),
              child: Text(
                'Passenger Onboarded',
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
        ],
      ),
    );
  }

  Widget _buildHospitalRouteBottomSheet(TripsActivityViewModel viewModel) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F7), // #F2F4F7 background
        border: Border.all(color: const Color(0xFFEAECF0)),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(77, 79, 82, 0.2),
            offset: Offset(0, -1.v),
            blurRadius: 20.adaptSize,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Dragger
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.v),
            child: Container(
              width: 80.h,
              height: 4.v,
              decoration: BoxDecoration(
                color: AppColors.gray400,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),

          // Patient's Information Card - COLLAPSIBLE
          Container(
            margin: EdgeInsets.all(8.adaptSize),
            padding: EdgeInsets.all(16.adaptSize),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFEAECF0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with dropdown - CLICKABLE
                InkWell(
                  onTap: viewModel.togglePatientInfo,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Patient\'s Information',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          fontSize: 14.fSize,
                          height: 1.4285714285714286,
                          letterSpacing: -0.2,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      AnimatedRotation(
                        turns: viewModel.isPatientInfoExpanded ? 0.5 : 0.0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          size: 18.adaptSize,
                          color: AppColors.gray400,
                        ),
                      ),
                    ],
                  ),
                ),

                // Animated patient details
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: viewModel.isPatientInfoExpanded ? null : 0,
                  child: viewModel.isPatientInfoExpanded
                      ? Column(
                          children: [
                            SizedBox(height: 8.v),

                            // Patient Details
                            Column(
                              children: [
                                _buildInfoRow(
                                  ImageConstant.imgUser,
                                  'Gender',
                                  'Female',
                                ),
                                SizedBox(height: 8.v),
                                _buildInfoRow(
                                  ImageConstant.ageGroupIcon,
                                  'Age group',
                                  '20 to 39 years',
                                ),
                                SizedBox(height: 8.v),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          ImageConstant.emergencyLevel,
                                          width: 14.adaptSize,
                                          height: 14.adaptSize,
                                          // color: AppColors.gray400,
                                        ),
                                        SizedBox(width: 8.h),
                                        Text(
                                          'Emergency level',
                                          style: AppTextStyles.bodySmall.copyWith(
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 2.v),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFEF0C7),
                                        border: Border.all(color: const Color(0xFFF79009)),
                                        borderRadius: BorderRadius.circular(1000),
                                      ),
                                      child: Text(
                                        'Level 3',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 10.fSize,
                                          height: 1.6,
                                          color: const Color(0xFFDC6803),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.v),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          ImageConstant.cashIcon,
                                          width: 14.adaptSize,
                                          height: 14.adaptSize,
                                          // color: AppColors.gray400,
                                        ),
                                        SizedBox(width: 8.h),
                                        Text(
                                          'Payment',
                                          style: AppTextStyles.bodySmall.copyWith(
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 2.v),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFD1FADF), // Light green background for "Paid"
                                        borderRadius: BorderRadius.circular(1000),
                                      ),
                                      child: Text(
                                        'Paid',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 10.fSize,
                                          height: 1.6,
                                          color: const Color(0xFF027A48), // Green text for "Paid"
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),

          // Hospital's Information Card - NEW & COLLAPSIBLE
          Container(
            margin: EdgeInsets.all(8.adaptSize),
            padding: EdgeInsets.all(16.adaptSize),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFEAECF0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with dropdown - CLICKABLE
                InkWell(
                  onTap: viewModel.toggleHospitalInfo,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Hospital\'s Information',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          fontSize: 14.fSize,
                          height: 1.4285714285714286,
                          letterSpacing: -0.2,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      AnimatedRotation(
                        turns: viewModel.isHospitalInfoExpanded ? 0.5 : 0.0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          size: 18.adaptSize,
                          color: AppColors.gray400,
                        ),
                      ),
                    ],
                  ),
                ),

                // Animated hospital details
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: viewModel.isHospitalInfoExpanded ? null : 0,
                  child: viewModel.isHospitalInfoExpanded
                      ? Column(
                          children: [
                            SizedBox(height: 8.v),

                            // Hospital Details
                            Column(
                              children: [
                                _buildInfoRow(
                                  ImageConstant.hospital02,
                                  'Name',
                                  'Happy Luis Hospital',
                                ),
                                SizedBox(height: 8.v),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          ImageConstant.briefCase01,
                                          width: 14.adaptSize,
                                          height: 14.adaptSize,
                                        ),
                                        SizedBox(width: 8.h),
                                        Text(
                                          'Organization',
                                          style: AppTextStyles.bodySmall.copyWith(
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 2.v),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF2F4F7),
                                        border: Border.all(color: const Color(0xFFD0D5DD)),
                                        borderRadius: BorderRadius.circular(1000),
                                      ),
                                      child: Text(
                                        'Private',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 10.fSize,
                                          height: 1.6,
                                          color: const Color(0xFF344054),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),

          // Location Information
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8.h),
            padding: EdgeInsets.all(16.adaptSize), // Increased padding
            decoration: BoxDecoration(
              color: Colors.white, // White background for container
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFEAECF0)), // Optional: add border for definition
            ),
            child: Column(
              children: [
                // Your Location
                Container(
                  padding: EdgeInsets.all(12.adaptSize), // Increased padding
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F4F7), // Changed to #F2F4F7
                    borderRadius: BorderRadius.circular(56),
                  ),
                  child: Row(
                    children: [
            SvgPicture.asset(
              ImageConstant.locationUser,
              width: 24.adaptSize,
              height: 24.adaptSize,
            ),
                      SizedBox(width: 8.h),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your location',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                fontSize: 12.fSize,
                                height: 1.5,
                                letterSpacing: -0.2,
                                color: const Color(0x80000000), // rgba(0, 0, 0, 0.5)
                              ),
                            ),
                            Text(
                              'Current Location',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                fontSize: 14.fSize,
                                height: 1.4285714285714286,
                                letterSpacing: -0.2,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Dashed line - Positioned at left/start
                Container(
                  margin: EdgeInsets.symmetric(vertical: 12.v),
                  width: double.infinity,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.only(left: 32.h), // Align with the icons
                      width: 1,
                      height: 38.v,
                      child: CustomPaint(
                        painter: DashedLinePainter(),
                      ),
                    ),
                  ),
                ),

                // Hospital Location
                Container(
                  padding: EdgeInsets.all(12.adaptSize),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F4F7),
                    borderRadius: BorderRadius.circular(56),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        ImageConstant.pinLocation,
                        width: 24.adaptSize,
                        height: 24.adaptSize,
                      ),
                      SizedBox(width: 8.h),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Routing to',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                fontSize: 12.fSize,
                                height: 1.5,
                                letterSpacing: -0.2,
                                color: const Color(0x80000000),
                              ),
                            ),
                            Text(
                              'Hospital\'s address',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                fontSize: 14.fSize,
                                height: 1.4285714285714286,
                                letterSpacing: -0.2,
                                color: AppColors.textPrimary,
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

          // ETA and Distance with Call/Message buttons
          Container(
            margin: EdgeInsets.all(8.adaptSize),
            padding: EdgeInsets.all(16.adaptSize),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFEAECF0)),
            ),
            child: Column(
              children: [
                // ETA and Distance Row
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '24 Minutes',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              fontSize: 24.fSize,
                              height: 1.33,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'ETA',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              fontSize: 12.fSize,
                              height: 1.5,
                              letterSpacing: -0.2,
                              color: const Color(0xFF667085),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '37 Km',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              fontSize: 24.fSize,
                              height: 1.33,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'DISTANCE',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              fontSize: 12.fSize,
                              height: 1.5,
                              letterSpacing: -0.2,
                              color: const Color(0xFF667085),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16.v),

                // Call hospital and Message hospital Buttons Row
                Builder(
                  builder: (builderContext) => Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            print('Calling hospital');
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12.v),
                            decoration: BoxDecoration(
                              color: const Color(0x1A1D9C7D), // Changed to #1D9C7D1A
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  ImageConstant.call2,
                                  width: 24.adaptSize,
                                  height: 24.adaptSize,
                                ),
                                SizedBox(height: 4.v),
                                Text(
                                  'Call hospital',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10.fSize,
                                    height: 1.6,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16.h),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              builderContext,
                              MaterialPageRoute(
                                builder: (context) => const HospitalChatPage(),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12.v),
                            decoration: BoxDecoration(
                              color: const Color(0x1A1D9C7D), // Changed to #1D9C7D1A
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  ImageConstant.messages2,
                                  width: 24.adaptSize,
                                  height: 24.adaptSize,
                                ),
                                SizedBox(height: 4.v),
                                Text(
                                  'Message hospital',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10.fSize,
                                    height: 1.6,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Arrived at Hospital Button
          Container(
            padding: EdgeInsets.all(16.adaptSize),
            child: ElevatedButton(
              onPressed: viewModel.arrivedAtHospital,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B1D29), // Dark navy blue
                padding: EdgeInsets.symmetric(vertical: 12.v),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1000),
                ),
                minimumSize: Size(double.infinity, 48.v),
              ),
              child: Text(
                'Arrived at Hospital',
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
        ],
      ),
    );
  }

  @override
  TripsActivityViewModel viewModelBuilder(BuildContext context) => 
      TripsActivityViewModel();

  @override
  void onViewModelReady(TripsActivityViewModel viewModel) {
    // Pass the dashboard location data to the viewmodel
    viewModel.setLocationFromDashboard(currentPosition, hasLocationPermission);
    super.onViewModelReady(viewModel);
  }
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryBlue
      ..strokeWidth = 1.0;

    const dashHeight = 2.0;
    const dashSpace = 2.0;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
