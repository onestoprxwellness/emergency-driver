import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';
import '../../../util/image_constant.dart';
import '../../../util/size_utils.dart';
import '../../../widgets/custom_image_view.dart';
import '../viewmodels/dashboard_home_viewmodel.dart';

class DashboardHome extends StackedView<DashboardHomeViewModel> {
  const DashboardHome({super.key});

  @override
  Widget builder(
    BuildContext context,
    DashboardHomeViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Main content area
          SingleChildScrollView(
            child: Column(
              children: [
                // Status bar spacing
                SizedBox(height: 52.v),
                
                // Custom Header with Logo and Notification
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.v),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Logo
                      CustomImageView(
                        imagePath: ImageConstant.newLogo,
                        height: 24.v,
                        fit: BoxFit.contain,
                      ),
                      
                      // Notification Icon
                      Container(
                        width: 24.h,
                        height: 24.v,
                        child: CustomImageView(
                          imagePath: ImageConstant.notification,
                          height: 24.v,
                          width: 24.h,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Main Content
                Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text Section
                      Container(
                        padding: EdgeInsets.fromLTRB(16.h, 8.v, 16.h, 16.v),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Welcome Text
                            SizedBox(
                              width: 213.h,
                              child: Text(
                                'Ready to save lives? Michael! 👏🏼',
                                style: TextStyle(
                                  fontSize: 24.fSize,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF101828),
                                  fontFamily: 'Plus Jakarta Sans',
                                  letterSpacing: -1.0,
                                  height: 1.33,
                                ),
                              ),
                            ),
                            SizedBox(height: 8.v),
                            
                            // Current Location Text
                            Text(
                              'Your current location',
                              style: TextStyle(
                                fontSize: 12.fSize,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF475467),
                                fontFamily: 'Inter',
                                letterSpacing: -0.2,
                                height: 1.5,
                              ),
                            ),
                            SizedBox(height: 8.v),
                            
                            // Map Widget
                            Container(
                              height: 100.v,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: const Color(0xFF101828),
                                borderRadius: BorderRadius.circular(16.adaptSize),
                                border: Border.all(
                                  color: const Color(0xFFEAECF0),
                                  width: 1.h,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16.adaptSize),
                                child: Stack(
                                  children: [
                                    // Google Map
                                    GoogleMap(
                                      initialCameraPosition: viewModel.initialCameraPosition,
                                      onMapCreated: viewModel.onMapCreated,
                                      markers: viewModel.mapMarkers,
                                      myLocationEnabled: false,
                                      myLocationButtonEnabled: false,
                                      zoomControlsEnabled: false,
                                      mapToolbarEnabled: false,
                                      compassEnabled: false,
                                      tiltGesturesEnabled: false,
                                      rotateGesturesEnabled: false,
                                      scrollGesturesEnabled: false,
                                      zoomGesturesEnabled: false,
                                    ),
                                    
                                    // Driver location indicator (only show if location available)
                                    if (viewModel.hasLocationPermission && viewModel.currentPosition != null)
                                      Positioned(
                                        left: 74.h,
                                        top: 32.v,
                                        child: Container(
                                          width: 32.adaptSize,
                                          height: 32.adaptSize,
                                          padding: EdgeInsets.all(4.adaptSize),
                                          decoration: BoxDecoration(
                                            color: const Color.fromRGBO(29, 156, 125, 0.24),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: const Color.fromRGBO(29, 156, 125, 0.1),
                                              width: 10.adaptSize,
                                            ),
                                          ),
                                          child: Center(
                                            child: CustomImageView(
                                              imagePath: ImageConstant.ambulance,
                                              height: 14.adaptSize,
                                              width: 14.adaptSize,
                                              color: const Color(0xFF1D9C7D),
                                            ),
                                          ),
                                        ),
                                      ),
                                    
                                    // Loading indicator
                                    if (viewModel.isLoadingLocation)
                                      const Center(
                                        child: CircularProgressIndicator(
                                          color: Color(0xFF077BF8),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 8.v),
                            
                            // Location Badge (show address or error message)
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 4.v),
                              decoration: BoxDecoration(
                                color: viewModel.hasLocationPermission 
                                    ? const Color.fromRGBO(29, 156, 125, 0.1)
                                    : const Color.fromRGBO(239, 68, 68, 0.1),
                                borderRadius: BorderRadius.circular(100.adaptSize),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomImageView(
                                    imagePath: ImageConstant.imgLocation,
                                    height: 14.adaptSize,
                                    width: 14.adaptSize,
                                    color: viewModel.hasLocationPermission 
                                        ? const Color(0xFF1D9C7D)
                                        : const Color(0xFFEF4444),
                                  ),
                                  SizedBox(width: 4.h),
                                  Flexible(
                                    child: Text(
                                      viewModel.currentAddress,
                                      style: TextStyle(
                                        fontSize: 10.fSize,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xFF101828),
                                        fontFamily: 'Inter',
                                        height: 1.6,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  // Refresh button for location
                                  if (!viewModel.hasLocationPermission)
                                    GestureDetector(
                                      onTap: () => viewModel.refreshLocation(),
                                      child: Container(
                                        margin: EdgeInsets.only(left: 8.h),
                                        padding: EdgeInsets.all(2.adaptSize),
                                        child: Icon(
                                          Icons.refresh,
                                          size: 12.adaptSize,
                                          color: const Color(0xFFEF4444),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Stats Cards Section
                      Container(
                        padding: EdgeInsets.all(16.adaptSize),
                        child: Column(
                          children: [
                            // Earnings Card
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(12.adaptSize),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF2F4F7),
                                borderRadius: BorderRadius.circular(8.adaptSize),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF101828).withOpacity(0.05),
                                    offset: Offset(0, 1.v),
                                    blurRadius: 2.adaptSize,
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'YOUR EARNINGS',
                                    style: TextStyle(
                                      fontSize: 10.fSize,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF101828),
                                      fontFamily: 'Inter',
                                      height: 1.6,
                                    ),
                                  ),
                                  SizedBox(height: 4.v),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '₦248,000.00',
                                        style: TextStyle(
                                          fontSize: 24.fSize,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF000407),
                                          fontFamily: 'Plus Jakarta Sans',
                                          letterSpacing: -1.0,
                                          height: 1.33,
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: 18.adaptSize,
                                        color: const Color(0xFF98A2B3),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 12.v),
                            
                            // Row of two cards
                            Row(
                              children: [
                                // Acceptance Rate Card
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(12.adaptSize),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF2F4F7),
                                      borderRadius: BorderRadius.circular(8.adaptSize),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF101828).withOpacity(0.05),
                                          offset: Offset(0, 1.v),
                                          blurRadius: 2.adaptSize,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'ACCEPTANCE RATE',
                                          style: TextStyle(
                                            fontSize: 10.fSize,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFF101828),
                                            fontFamily: 'Inter',
                                            height: 1.6,
                                          ),
                                        ),
                                        SizedBox(height: 4.v),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              '90%',
                                              style: TextStyle(
                                                fontSize: 24.fSize,
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xFF000407),
                                                fontFamily: 'Plus Jakarta Sans',
                                                letterSpacing: -1.0,
                                                height: 1.33,
                                              ),
                                            ),
                                            Icon(
                                              Icons.arrow_forward_ios,
                                              size: 18.adaptSize,
                                              color: const Color(0xFF98A2B3),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.h),
                                
                                // Driver Score Card
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(12.adaptSize),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF2F4F7),
                                      borderRadius: BorderRadius.circular(8.adaptSize),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF101828).withOpacity(0.05),
                                          offset: Offset(0, 1.v),
                                          blurRadius: 2.adaptSize,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'DRIVER SCORE',
                                          style: TextStyle(
                                            fontSize: 10.fSize,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFF101828),
                                            fontFamily: 'Inter',
                                            height: 1.6,
                                          ),
                                        ),
                                        SizedBox(height: 4.v),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              '100',
                                              style: TextStyle(
                                                fontSize: 24.fSize,
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xFF000407),
                                                fontFamily: 'Plus Jakarta Sans',
                                                letterSpacing: -1.0,
                                                height: 1.33,
                                              ),
                                            ),
                                            Icon(
                                              Icons.arrow_forward_ios,
                                              size: 18.adaptSize,
                                              color: const Color(0xFF98A2B3),
                                            ),
                                          ],
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
                      
                      // Ads Banner Section
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.h),
                        margin: EdgeInsets.only(top: 10.v),
                        child: Container(
                          width: double.infinity,
                          height: 100.v,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.adaptSize),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF101828).withOpacity(0.05),
                                offset: Offset(0, 1.v),
                                blurRadius: 2.adaptSize,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: 
                            SvgPicture.asset(
                              ImageConstant.headerCard,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      
                      // Recent Trips Section
                      Container(
                        padding: EdgeInsets.all(16.adaptSize),
                        margin: EdgeInsets.only(top: 16.v),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Section Title
                            Text(
                              'Recent trips',
                              style: TextStyle(
                                fontSize: 16.fSize,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF101828),
                                fontFamily: 'Inter',
                                height: 1.5,
                              ),
                            ),
                            SizedBox(height: 12.v),
                            
                            // No Trips State
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 40.v),
                              child: Column(
                                children: [
                                  // No Trip Image
                                  CustomImageView(
                                    imagePath: ImageConstant.noTrip,
                                    height: 160.adaptSize,
                                    width: 160.adaptSize,
                                    fit: BoxFit.contain,
                                  ),
                                  SizedBox(height: 16.v),
                                  
                                  // No trips yet text
                                  Text(
                                    'No trips yet',
                                    style: TextStyle(
                                      fontSize: 24.fSize,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF191919),
                                      fontFamily: 'Onest',
                                      letterSpacing: -0.36,
                                      height: 1.4,
                                    ),
                                  ),
                                  SizedBox(height: 8.v),
                                  
                                  // Subtitle text
                                  Container(
                                    width: 320.h,
                                    child: Text(
                                      'Go online to start accepting trip requests',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 12.fSize,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xFF777A88),
                                        fontFamily: 'Onest',
                                        letterSpacing: -0.24,
                                        height: 1.48,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Extra spacing for bottom sheet
                      SizedBox(height: 200.v),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Modal Bottom Sheet positioned above bottom nav
          Positioned(
            bottom: 50.v, // Position directly above the bottom navigation
            left: 0,
            right: 0,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 0.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18.adaptSize),
                  topRight: Radius.circular(18.adaptSize),
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
                  // Distance controls row
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.v),
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
                              color: const Color(0xFF1D2939),
                              size: 18.adaptSize,
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
                              color: const Color(0xFF1D2939),
                              size: 18.adaptSize,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Slider section
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final sliderWidth = constraints.maxWidth;
                        final maxSlideDistance = sliderWidth - 52; // 52 is the slider button width
                        
                        return Container(
                          width: double.infinity,
                          height: 52,
                          decoration: BoxDecoration(
                            color: viewModel.isOnline ? const Color(0xFF077BF8) : const Color(0xFF000A14),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Stack(
                            children: [
                              // Center content (text and arrows)
                              Center(
                                child: AnimatedOpacity(
                                  opacity: viewModel.sliderPosition < 0.3 ? 1.0 : 0.0,
                                  duration: const Duration(milliseconds: 200),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.keyboard_double_arrow_right,
                                        color: viewModel.isOnline 
                                            ? Colors.white.withOpacity(0.8)
                                            : const Color.fromRGBO(255, 255, 255, 0.24),
                                        size: 20.adaptSize,
                                      ),
                                      SizedBox(width: 32.h),
                                      Text(
                                        viewModel.isOnline ? 'You are online!' : 'Drag to go online',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.fSize,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Roboto',
                                        ),
                                      ),
                                      SizedBox(width: 32.h),
                                      Icon(
                                        Icons.keyboard_double_arrow_right,
                                        color: viewModel.isOnline 
                                            ? Colors.white.withOpacity(0.8)
                                            : const Color.fromRGBO(255, 255, 255, 0.24),
                                        size: 20.adaptSize,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Draggable car icon
                              AnimatedPositioned(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOut,
                                left: 4 + (viewModel.sliderPosition * maxSlideDistance),
                                top: 4,
                                child: GestureDetector(
                                  onPanUpdate: (details) => viewModel.onSliderDragUpdate(details.delta.dx, sliderWidth),
                                  onPanEnd: (details) async {
                                    await viewModel.onSliderDragEnd(context);
                                  },
                                  child: Container(
                                    width: 44.adaptSize,
                                    height: 44.adaptSize,
                                    decoration: BoxDecoration(
                                      color: viewModel.isOnline ? Colors.white : const Color(0xFF077BF8),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 4.adaptSize,
                                          offset: Offset(0, 2.v),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: CustomImageView(
                                        imagePath: ImageConstant.ambulance,
                                        height: 24.adaptSize,
                                        width: 24.adaptSize,
                                        color: viewModel.isOnline ? const Color(0xFF077BF8) : Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  // Bottom navigation area spacer
                  SizedBox(height: 8.v),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  DashboardHomeViewModel viewModelBuilder(BuildContext context) => 
      DashboardHomeViewModel();

  @override
  void onViewModelReady(DashboardHomeViewModel viewModel) {
    viewModel.initializeLocation();
    super.onViewModelReady(viewModel);
  }
}
