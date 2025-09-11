import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:geocoding/geocoding.dart';
import '../pages/trips_activity.dart';

class DashboardHomeViewModel extends BaseViewModel {
  // Private fields
  int _distance = 2;
  double _sliderPosition = 0.0;
  bool _isOnline = false;
  Position? _currentPosition;
  String _currentAddress = 'Location not detected';
  bool _hasLocationPermission = false;
  bool _isLoadingLocation = false;
  GoogleMapController? _mapController;

  // Getters
  int get distance => _distance;
  double get sliderPosition => _sliderPosition;
  bool get isOnline => _isOnline;
  Position? get currentPosition => _currentPosition;
  String get currentAddress => _currentAddress;
  bool get hasLocationPermission => _hasLocationPermission;
  bool get isLoadingLocation => _isLoadingLocation;
  GoogleMapController? get mapController => _mapController;
  
  // Camera position for Google Maps
  CameraPosition get initialCameraPosition {
    if (_currentPosition != null) {
      return CameraPosition(
        target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        zoom: 15.0,
      );
    }
    // Default to Lagos if no location
    return const CameraPosition(
      target: LatLng(6.5244, 3.3792),
      zoom: 15.0,
    );
  }

  // Get markers for the map
  Set<Marker> get mapMarkers {
    if (_currentPosition != null && _hasLocationPermission) {
      return {
        Marker(
          markerId: const MarkerId('driver_location'),
          position: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          infoWindow: const InfoWindow(title: 'Your Location'),
        ),
      };
    }
    return {};
  }

  // Initialize location services
  Future<void> initializeLocation() async {
    _isLoadingLocation = true;
    notifyListeners();

    try {
      // Check and request location permission
      await _checkLocationPermission();
      
      if (_hasLocationPermission) {
        // Get current position
        await _getCurrentLocation();
        
        // Get address from coordinates
        if (_currentPosition != null) {
          await _getAddressFromCoordinates();
        }
      }
    } catch (e) {
      print('Error initializing location: $e');
      _currentAddress = 'Location not detected';
      _hasLocationPermission = false;
    } finally {
      _isLoadingLocation = false;
      notifyListeners();
    }
  }

  // Check location permission
  Future<void> _checkLocationPermission() async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _hasLocationPermission = false;
      _currentAddress = 'Location services disabled';
      return;
    }

    // Check location permission
    LocationPermission permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _hasLocationPermission = false;
        _currentAddress = 'Location permission denied';
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _hasLocationPermission = false;
      _currentAddress = 'Location permission permanently denied';
      return;
    }

    _hasLocationPermission = true;
  }

  // Get current location
  Future<void> _getCurrentLocation() async {
    try {
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      notifyListeners();
    } catch (e) {
      print('Error getting current location: $e');
      _currentAddress = 'Unable to get current location';
    }
  }

  // Get address from coordinates
  Future<void> _getAddressFromCoordinates() async {
    if (_currentPosition == null) return;

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        _currentAddress = '${place.street}, ${place.locality}, ${place.administrativeArea}';
      } else {
        _currentAddress = 'Address not found';
      }
    } catch (e) {
      print('Error getting address: $e');
      _currentAddress = '${_currentPosition!.latitude.toStringAsFixed(4)}, ${_currentPosition!.longitude.toStringAsFixed(4)}';
    }
  }

  // Map controller callback
  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    notifyListeners();
  }

  // Distance controls
  void increaseDistance() {
    _distance++;
    notifyListeners();
  }

  void decreaseDistance() {
    if (_distance > 1) {
      _distance--;
      notifyListeners();
    }
  }

  // Slider controls
  void onSliderDragUpdate(double deltaX, double sliderWidth) {
    _sliderPosition += deltaX / (sliderWidth - 52);
    _sliderPosition = _sliderPosition.clamp(0.0, 1.0);
    _isOnline = _sliderPosition > 0.8;
    notifyListeners();
  }

  Future<void> onSliderDragEnd(BuildContext context) async {
    if (_isOnline) {
      _sliderPosition = 1.0;
      notifyListeners();
      
      // Navigate to TripsActivity with current location data
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TripsActivity(
            currentPosition: _currentPosition,
            hasLocationPermission: _hasLocationPermission,
          ),
        ),
      );
      
      // Handle return from TripsActivity
      if (result != null && result['status'] == 'offline') {
        _isOnline = false;
        _sliderPosition = 0.0;
        notifyListeners();
      }
    } else {
      _sliderPosition = 0.0;
      notifyListeners();
    }
  }

  // Toggle online status
  Future<void> toggleOnlineStatus(BuildContext context) async {
    _isOnline = !_isOnline;
    _sliderPosition = _isOnline ? 1.0 : 0.0;
    notifyListeners();
    
    if (_isOnline) {
      // Navigate to TripsActivity when going online with current location data
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TripsActivity(
            currentPosition: _currentPosition,
            hasLocationPermission: _hasLocationPermission,
          ),
        ),
      );
      
      // Handle return from TripsActivity
      if (result != null && result['status'] == 'offline') {
        _isOnline = false;
        _sliderPosition = 0.0;
        notifyListeners();
      }
    }
  }

  // Refresh location
  Future<void> refreshLocation() async {
    await initializeLocation();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
