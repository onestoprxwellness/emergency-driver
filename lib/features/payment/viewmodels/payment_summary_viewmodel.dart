import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class PaymentSummaryViewModel extends BaseViewModel {
  String? _selectedPaymentMethod = 'platform'; // Default to platform payment

  // Getters
  String? get selectedPaymentMethod => _selectedPaymentMethod;
  
  bool get canConfirmPayment => _selectedPaymentMethod != null;

  // Navigation callbacks
  VoidCallback? onNavigateBack;
  VoidCallback? onNavigateToConfirmation;

  /// Select a payment method
  void selectPaymentMethod(String method) {
    _selectedPaymentMethod = method;
    notifyListeners();
  }

  /// Confirm payment and complete the process
  void confirmPayment() {
    if (!canConfirmPayment) return;
    
    // Here you would typically:
    // 1. Process the payment
    // 2. Update the trip status
    // 3. Navigate to completion screen
    
    setBusy(true);
    
    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      setBusy(false);
      
      // Navigate to confirmation page
      onNavigateToConfirmation?.call();
    });
  }

  /// Go back to previous screen
  void goBack() {
    onNavigateBack?.call();
  }
}
