import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../util/size_utils.dart';
import '../../../util/image_constant.dart';
import '../viewmodels/chat_viewmodel.dart';
import 'package:stacked/stacked.dart';

class HospitalChatPage extends StatelessWidget {
  const HospitalChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChatViewModel>.reactive(
      viewModelBuilder: () => ChatViewModel(chatType: ChatType.hospital),
      onViewModelReady: (viewModel) {
        viewModel.onNavigateBack = () {
          Navigator.pop(context);
        };
      },
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFF6FBFA), // Light green background
          body: SafeArea(
            child: Column(
              children: [
                // Header with back button, title, and call button
                _buildHeader(viewModel),
                
                // Chat content
                Expanded(
                  child: _buildChatContent(viewModel),
                ),
                
                // Message input
                _buildMessageInput(viewModel),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(ChatViewModel viewModel) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.v),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFEAECF0)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          InkWell(
            onTap: viewModel.goBack,
            child: Container(
              padding: EdgeInsets.all(8.adaptSize),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFD0D5DD)),
                borderRadius: BorderRadius.circular(1000),
              ),
              child: Icon(
                Icons.keyboard_arrow_left,
                size: 20.adaptSize,
                color: const Color(0xFF1D2939),
              ),
            ),
          ),
          
          // Title
          Text(
            'Chat with hospital',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              fontSize: 14.fSize,
              color: const Color(0xFF101828),
            ),
          ),
          
          // Call button
          InkWell(
            onTap: viewModel.makeCall,
            child: Container(
              padding: EdgeInsets.all(8.adaptSize),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFEAECF0)),
                borderRadius: BorderRadius.circular(1000),
              ),
              child: SvgPicture.asset(
                ImageConstant.call2,
                width: 20.adaptSize,
                height: 20.adaptSize,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatContent(ChatViewModel viewModel) {
    return Container(
      padding: EdgeInsets.all(16.h),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: viewModel.messages.length,
              itemBuilder: (context, index) {
                final message = viewModel.messages[index];
                final timeString = _formatTime(message.timestamp);
                
                if (message.isFromDriver) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 8.v),
                    child: _buildDriverMessage(message.text, timeString, 'Delivered'),
                  );
                } else {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 8.v),
                    child: _buildHospitalMessage(message.text, timeString),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
  
  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour == 0 ? 12 : (dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour);
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'pm' : 'am';
    return '$hour:$minute $period';
  }

  Widget _buildDriverMessage(String message, String time, String status) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 280.h,
          minWidth: 80.h, // Minimum width for small messages
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 8.v),
        decoration: const BoxDecoration(
          color: Color(0x291D9C7D), // Green with alpha (rgba(29, 156, 125, 0.16))
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(14),
            topRight: Radius.circular(2),
            bottomLeft: Radius.circular(14),
            bottomRight: Radius.circular(14),
          ),
        ),
        child: IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                child: Text(
                  message,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 12.fSize,
                    height: 1.5,
                    color: const Color(0xFF101828),
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 2.v),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    time,
                    style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 10.fSize,
                    height: 1.6,
                    color: const Color(0xFF667085),
                  ),
                ),
                SizedBox(width: 4.h),
                Container(
                  width: 2.adaptSize,
                  height: 2.adaptSize,
                  decoration: const BoxDecoration(
                    color: Color(0xFF98A2B3),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 4.h),
                Text(
                  status,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 10.fSize,
                    height: 1.6,
                    color: const Color(0xFF667085),
                  ),
                ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
   
  }

  Widget _buildHospitalMessage(String message, String time) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 280.h,
          minWidth: 80.h, // Minimum width for small messages
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 8.v),
        decoration: const BoxDecoration(
          color: Color(0x1A082F2E), // Dark green with alpha (rgba(8, 47, 46, 0.1))
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(14),
            topRight: Radius.circular(14),
            bottomLeft: Radius.circular(2),
            bottomRight: Radius.circular(14),
          ),
        ),
        child: IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                child: Text(
                  message,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 12.fSize,
                    height: 1.5,
                    color: const Color(0xFF101828),
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 4.v),
              Text(
                time,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: 10.fSize,
                  height: 1.6,
                  color: const Color(0xFF667085),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }  Widget _buildMessageInput(ChatViewModel viewModel) {
    return Container(
      padding: EdgeInsets.all(16.h),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFEAECF0)),
                borderRadius: BorderRadius.circular(100),
              ),
              child: TextFormField(
                controller: viewModel.messageController,
                decoration: InputDecoration(
                  hintText: 'Write a message...',
                  hintStyle: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: 12.fSize,
                    height: 1.5,
                    color: const Color(0xFF475467),
                  ),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 12.v),
                ),
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  fontSize: 12.fSize,
                  height: 1.5,
                  color: const Color(0xFF101828),
                ),
                onFieldSubmitted: (value) => viewModel.sendMessage(),
              ),
            ),
          ),
          SizedBox(width: 8.h),
          InkWell(
            onTap: viewModel.sendMessage,
            child: Center(
              child: SvgPicture.asset(
                ImageConstant.send2,
                width: 44.adaptSize,
                height: 44.adaptSize,
                // color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
