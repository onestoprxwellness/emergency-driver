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
  bool _showWaitingPanel = true; // Controls the initial waiting sheet
  bool _isDisposed = false;
  bool _showEmergencyRequest = false; // Controls the emergency request bottom sheet
  bool _showAcceptedRequest = false; // Controls the accepted request sheet (NEW STATE)
  bool _showWaitingToOnboard = false; // Controls waiting to onboard sheet (NEWEST STATE)
  bool _isPatientInfoExpanded = true; // Controls Patient Information dropdown (starts expanded)
  Timer? _emergencyTimer;
  Timer? _onboardTimer; // Timer for onboard countdown
  int _onboardMinutes = 9; // Countdown minutes
  int _onboardSeconds = 32; // Countdown seconds
  
  // Hospital route state
  bool _showHospitalRoute = false;
  bool _isHospitalInfoExpanded = true; // Controls Hospital Information dropdown (starts expanded)
  
  // Getters
  GoogleMapController? get mapController => _mapController;
  Position? get currentPosition => _currentPosition;
  bool get hasLocationPermission => _hasLocationPermission;
  Set<Marker> get mapMarkers => _mapMarkers;
  int get distance => _distance;
  bool get showWaitingPanel => _showWaitingPanel;
  bool get showEmergencyRequest => _showEmergencyRequest;
  bool get showAcceptedRequest => _showAcceptedRequest; // Getter for new state
  bool get showWaitingToOnboard => _showWaitingToOnboard; // Getter for onboard state
  bool get showHospitalRoute => _showHospitalRoute; // Getter for hospital route state
  bool get isPatientInfoExpanded => _isPatientInfoExpanded; // Getter for dropdown state
  bool get isHospitalInfoExpanded => _isHospitalInfoExpanded; // Getter for hospital dropdown state
  String get onboardCountdown => '${_onboardMinutes.toString().padLeft(2, '0')}:${_onboardSeconds.toString().padLeft(2, '0')}';
  
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
        // Start emergency simulation timer after 5 seconds
        _startEmergencySimulation();
      }
    } catch (e) {
      debugPrint('Error initializing location: $e');
    } finally {
      setBusy(false);
    }
  }

  /// Start emergency simulation after 5 seconds
  void _startEmergencySimulation() {
    debugPrint('🚨 Emergency simulation timer started - 5 seconds countdown...');
    _emergencyTimer = Timer(const Duration(seconds: 5), () {
      if (!_isDisposed && _showWaitingPanel) {
        debugPrint('🚨 Emergency found! Showing emergency request bottom sheet...');
        _showWaitingPanel = false;
        _showEmergencyRequest = true;
        notifyListeners();
      }
    });
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
    debugPrint('📍 Setting location data from dashboard...');
    _currentPosition = position;
    _hasLocationPermission = hasPermission;
    
    if (_currentPosition != null && _hasLocationPermission) {
      _updateCameraPosition();
      // Update the ambulance marker based on the provided location
      _createDriverMarker();
    }
    
    // Start emergency simulation timer regardless of location
    _startEmergencySimulation();
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
      Navigator.of(context).pop({'status': 'offline'});
    }
  }

  void acceptEmergencyRequest() {
    debugPrint('✅ Emergency request accepted! Transitioning to accepted state...');
    _showEmergencyRequest = false;
    _showAcceptedRequest = true; // Show the accepted request sheet
    notifyListeners();
  }

  void rejectEmergencyRequest() {
    debugPrint('❌ Emergency request rejected! Starting new simulation...');
    _showEmergencyRequest = false;
    _showWaitingPanel = true;
    notifyListeners();
    _startEmergencySimulation();
  }

  void arrivedAtLocation() {
    debugPrint('🎯 Driver has arrived at location! Starting onboard countdown...');
    _showAcceptedRequest = false;
    _showWaitingToOnboard = true;
    _startOnboardCountdown();
    notifyListeners();
  }

  void _startOnboardCountdown() {
    _onboardTimer?.cancel();
    _onboardMinutes = 9;
    _onboardSeconds = 32;
    
    _onboardTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isDisposed) {
        timer.cancel();
        return;
      }
      
      if (_onboardSeconds > 0) {
        _onboardSeconds--;
      } else if (_onboardMinutes > 0) {
        _onboardMinutes--;
        _onboardSeconds = 59;
      } else {
        // Timer finished
        timer.cancel();
        debugPrint('⏰ Onboard countdown finished!');
      }
      notifyListeners();
    });
  }

  void passengerOnboarded() {
    print('🏥 Passenger onboarded, transitioning to hospital route');
    _onboardTimer?.cancel();
    _showWaitingToOnboard = false;
    _showHospitalRoute = true;
    notifyListeners();
  }

  void togglePatientInfo() {
    _isPatientInfoExpanded = !_isPatientInfoExpanded;
    notifyListeners();
  }

  void toggleHospitalInfo() {
    _isHospitalInfoExpanded = !_isHospitalInfoExpanded;
    notifyListeners();
  }

  void arrivedAtHospital() {
    print('🏥 Arrived at hospital, completing journey');
    _showHospitalRoute = false;
    _showWaitingPanel = true;
    notifyListeners();
    // Start new simulation cycle
    _startEmergencySimulation();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _emergencyTimer?.cancel();
    _onboardTimer?.cancel();
    _isDisposed = true;
    super.dispose();
  }
}

