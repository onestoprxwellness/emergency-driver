import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';
import '../../../util/image_constant.dart';
import '../../../util/size_utils.dart';
import '../viewmodels/trips_activity_viewmodel.dart';

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

          // Status bar
          // Positioned(
          //   top: 0,
          //   left: 0,
          //   right: 0,
          //   child: Container(
          //     height: 52.v,
          //     color: Colors.transparent,
          //     child: SafeArea(
          //       child: Container(
          //         padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 8.v),
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             // Time
          //             Text(
          //               '12:30',
          //               style: TextStyle(
          //                 fontSize: 14.fSize,
          //                 fontWeight: FontWeight.w500,
          //                 color: const Color(0xFF101828),
          //                 fontFamily: 'Roboto',
          //               ),
          //             ),
                      
          //             // Status icons
          //             Row(
          //               children: [
          //                 // WiFi icon
          //                 Icon(
          //                   Icons.wifi,
          //                   size: 16.adaptSize,
          //                   color: const Color(0xFF1D2939),
          //                 ),
          //                 SizedBox(width: 4.h),
                          
          //                 // Network icon
          //                 Icon(
          //                   Icons.signal_cellular_4_bar,
          //                   size: 16.adaptSize,
          //                   color: const Color(0xFF1D2939),
          //                 ),
          //                 SizedBox(width: 4.h),
                          
          //                 // Battery icon
          //                 Icon(
          //                   Icons.battery_full,
          //                   size: 16.adaptSize,
          //                   color: const Color(0xFF1D2939),
          //                 ),
          //               ],
          //             ),
          //           ],
          //         ),
          //       ),
          //     ),
          //   ),
          // ),



          // No overlay indicator; ambulance will be shown as the map marker icon

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
            bottom: 240.v, // Positioned closer to emergency banner
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

          // Bottom sheet with emergency banner
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
