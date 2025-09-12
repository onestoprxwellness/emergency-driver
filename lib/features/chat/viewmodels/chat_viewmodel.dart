import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

enum ChatType { patient, hospital }

class ChatViewModel extends BaseViewModel {
  final ChatType chatType;
  
  // Navigation callback
  VoidCallback? onNavigateBack;
  
  // Text controller for message input
  final TextEditingController messageController = TextEditingController();
  
  // List to store chat messages
  List<ChatMessage> messages = [];
  
  ChatViewModel({required this.chatType});
  
  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }
  
  /// Go back to previous screen
  void goBack() {
    onNavigateBack?.call();
  }
  
  /// Make a phone call
  void makeCall() {
    // TODO: Implement phone call functionality
    // This would typically open the phone dialer
    print('Making call to ${chatType == ChatType.patient ? 'patient' : 'hospital'}');
  }
  
  /// Send a message
  void sendMessage() {
    final messageText = messageController.text.trim();
    if (messageText.isNotEmpty) {
      // Add message to list
      messages.add(ChatMessage(
        text: messageText,
        isFromDriver: true,
        timestamp: DateTime.now(),
      ));
      
      // Clear the input
      messageController.clear();
      
      // Notify listeners to update UI
      notifyListeners();
      
      // TODO: Implement actual message sending to backend
      print('Sending message: $messageText in ${chatType == ChatType.patient ? 'patient' : 'hospital'} chat');
    }
  }
}

class ChatMessage {
  final String text;
  final bool isFromDriver;
  final DateTime timestamp;
  
  ChatMessage({
    required this.text,
    required this.isFromDriver,
    required this.timestamp,
  });
}
