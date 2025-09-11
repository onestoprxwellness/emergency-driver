import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';
import '../../../util/image_constant.dart';

class TripsActivityViewModel extends BaseViewModel {
  
  GoogleMapController? _mapController;
  Position? _currentPosition;
  bool _hasLocationPermission = false;
  Set<Marker> _mapMarkers = {};
  int _distance = 10; // Default distance in km
  
  // Getters
  GoogleMapController? get mapController => _mapController;
  Position? get currentPosition => _currentPosition;
  bool get hasLocationPermission => _hasLocationPermission;
  Set<Marker> get mapMarkers => _mapMarkers;
  int get distance => _distance;
  
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
    super.dispose();
  }
}
