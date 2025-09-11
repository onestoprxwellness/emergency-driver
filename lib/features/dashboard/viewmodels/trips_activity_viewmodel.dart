import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';
import '../../../util/image_constant.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../util/size_utils.dart';

class TripsActivityViewModel extends BaseViewModel {
  
  GoogleMapController? _mapController;
  Position? _currentPosition;
  bool _hasLocationPermission = false;
  Set<Marker> _mapMarkers = {};
  int _distance = 10; // Default distance in km
  bool _showWaitingPanel = true; // Controls the initial waiting sheet
  bool _isDisposed = false;
  bool _emergencyFlowStarted = false;
  
  // Getters
  GoogleMapController? get mapController => _mapController;
  Position? get currentPosition => _currentPosition;
  bool get hasLocationPermission => _hasLocationPermission;
  Set<Marker> get mapMarkers => _mapMarkers;
  int get distance => _distance;
  bool get showWaitingPanel => _showWaitingPanel;
  
  // Default camera position (Lagos, Nigeria)
  CameraPosition get initialCameraPosition => const CameraPosition(
    target: LatLng(6.5244, 3.3792),
    zoom: 14.0,
  );

  /// Initialize location services
  Future<void> initializeLocation() async {
    setBusy(true);
    try {
      await _checkLocationPermission();
      if (_hasLocationPermission) {
        await _getCurrentLocation();
        await _createDriverMarker();
      }
    } catch (e) {
      debugPrint('Error initializing location: $e');
    } finally {
      setBusy(false);
    }
  }

  /// Check and request location permissions
  Future<void> _checkLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _hasLocationPermission = false;
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _hasLocationPermission = false;
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _hasLocationPermission = false;
      return;
    }

    _hasLocationPermission = true;
  }

  /// Get current user location
  Future<void> _getCurrentLocation() async {
    try {
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      notifyListeners();
    } catch (e) {
      debugPrint('Error getting current location: $e');
    }
  }

  /// Create driver marker on map
  Future<void> _createDriverMarker() async {
    if (_currentPosition == null) return;
    try {
      // Create a custom ambulance marker icon from assets
      final BitmapDescriptor ambulanceIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(64, 64)),
        ImageConstant.ambulance,
      );

      final marker = Marker(
        markerId: const MarkerId('driver_location'),
        position: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        infoWindow: const InfoWindow(title: 'Your Location'),
        icon: ambulanceIcon,
        anchor: const Offset(0.5, 0.5),
      );

      // Keep only the ambulance marker
      _mapMarkers = {marker};
      notifyListeners();
    } catch (e) {
      debugPrint('Error creating ambulance marker: $e');
    }
  }

  /// Handle map creation
  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    
    // Move camera to current location if available
    if (_currentPosition != null) {
      _moveCameraToCurrentLocation();
    }
  }

  /// Move camera to current location
  Future<void> _moveCameraToCurrentLocation() async {
    if (_mapController == null || _currentPosition == null) return;

    await _mapController!.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
      ),
    );
  }

  /// Center map on current location
  void centerMapOnLocation() {
    if (_hasLocationPermission && _currentPosition != null) {
      _moveCameraToCurrentLocation();
    } else {
      // Show message about location not available
      debugPrint('Location not available');
    }
  }

  /// Schedule showing the Emergency Found sheet after 5 seconds.
  Future<void> scheduleEmergencyFound(BuildContext context) async {
    // Delay to simulate finding an emergency
    await Future.delayed(const Duration(seconds: 5));
    if (_isDisposed) return;

    // Hide the waiting panel and notify UI
    _showWaitingPanel = false;
    notifyListeners();

    if (_isDisposed) return;
    // Present the modal bottom sheet
    // ignore: use_build_context_synchronously
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: _EmergencyFoundSheet(),
        );
      },
    );
  }

  /// Idempotent starter to be called from the view's build with a valid context
  void startEmergencyFlowIfNeeded(BuildContext context) {
    if (_emergencyFlowStarted) return;
    _emergencyFlowStarted = true;
    scheduleEmergencyFound(context);
  }

  /// Increase distance
  void increaseDistance() {
    if (_distance < 50) { // Max 50km
      _distance++;
      notifyListeners();
    }
  }

  /// Decrease distance
  void decreaseDistance() {
    if (_distance > 1) { // Min 1km
      _distance--;
      notifyListeners();
    }
  }

  /// Set location data from dashboard
  void setLocationFromDashboard(Position? position, bool hasPermission) {
    _currentPosition = position;
    _hasLocationPermission = hasPermission;
    
    if (_currentPosition != null && _hasLocationPermission) {
      _updateCameraPosition();
      // Update the ambulance marker based on the provided location
      _createDriverMarker();
    }
    notifyListeners();
  }



  /// Update camera position to current location
  void _updateCameraPosition() {
    if (_mapController != null && _currentPosition != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        ),
      );
    }
  }

  /// Go offline and return to dashboard
  Future<void> goOffline(BuildContext context) async {
    // Show confirmation dialog
    bool? shouldGoOffline = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Go Offline'),
        content: const Text('Are you sure you want to go offline?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Go Offline'),
          ),
        ],
      ),
    );

    if (shouldGoOffline == true) {
      // Navigate back to dashboard and set offline
      Navigator.of(context).pop({'status': 'offline'});
    }
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _isDisposed = true;
    super.dispose();
  }
}

/// Emergency Found Bottom Sheet UI
class _EmergencyFoundSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.v),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 48.h,
                  height: 5.v,
                  margin: EdgeInsets.only(bottom: 12.v, top: 4.v),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(1000),
                  ),
                ),
              ),

              // Header row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Patient’s Information",
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: cs.onSurface,
                      fontSize: 18.fSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "Female",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: cs.onSurface.withOpacity(0.6),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12.v),

              // Info card
              _InfoCard(),

              SizedBox(height: 12.v),

              // Route card (Current location -> Patient address)
              _RouteCard(),

              SizedBox(height: 16.v),

              // ETA and Distance row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _StatBlock(title: '20 Minutes', subtitle: 'ETA'),
                  _StatBlock(title: '20 Km', subtitle: 'DISTANCE'),
                ],
              ),

              SizedBox(height: 16.v),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      style: TextButton.styleFrom(
                        foregroundColor: cs.error,
                        padding: EdgeInsets.symmetric(vertical: 14.v),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(1000),
                        ),
                      ),
                      child: Text(
                        'Reject',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: cs.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.h),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14.v),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(1000),
                        ),
                      ),
                      child: Text(
                        'Accept',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16.v),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final border = Border.all(color: Colors.black.withOpacity(0.06));

    Widget row(String label, String value, {Widget? trailingWidget}) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 10.v),
        child: Row(
          children: [
            // Placeholder icon
            Container(
              width: 28.adaptSize,
              height: 28.adaptSize,
              decoration: BoxDecoration(
                color: cs.surface,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  ImageConstant.imgUser,
                  width: 16.adaptSize,
                  height: 16.adaptSize,
                  colorFilter: ColorFilter.mode(cs.onSurface.withOpacity(0.7), BlendMode.srcIn),
                ),
              ),
            ),
            SizedBox(width: 12.h),
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurface.withOpacity(0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (trailingWidget != null)
              trailingWidget
            else
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: cs.background,
        borderRadius: BorderRadius.circular(16),
        border: border,
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.v),
      child: Column(
        children: [
          row('Gender', 'Female'),
          Divider(height: 1.v),
          row('Age group', '20 to 39 years'),
          Divider(height: 1.v),
          row(
            'Emergency level',
            'Level 3',
            trailingWidget: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 4.v),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(1000),
              ),
              child: Text(
                'Level 3',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: const Color(0xFFF79009),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Divider(height: 1.v),
          row('Payment', 'Pending'),
        ],
      ),
    );
  }
}

class _RouteCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final bg = cs.surface;
    final textMuted = cs.onSurface.withOpacity(0.5);

    Widget item(String title, String subtitle) {
      return Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black.withOpacity(0.06)),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 14.v),
        child: Row(
          children: [
            Container(
              width: 28.adaptSize,
              height: 28.adaptSize,
              decoration: BoxDecoration(
                color: cs.background,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  ImageConstant.imgUser,
                  width: 16.adaptSize,
                  height: 16.adaptSize,
                  colorFilter: ColorFilter.mode(cs.onSurface.withOpacity(0.7), BlendMode.srcIn),
                ),
              ),
            ),
            SizedBox(width: 12.h),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: textMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4.v),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: cs.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        item('Your location', 'Current Location'),
        SizedBox(height: 8.v),
        item('Routing to', "Patient’s address"),
      ],
    );
  }
}

class _StatBlock extends StatelessWidget {
  final String title;
  final String subtitle;
  const _StatBlock({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.v),
        decoration: BoxDecoration(
          color: cs.background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black.withOpacity(0.06)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: cs.onSurface,
                fontSize: 20.fSize,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 4.v),
            Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurface.withOpacity(0.6),
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
