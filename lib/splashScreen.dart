import 'package:flutter/material.dart';
import 'package:onestoprx_driver/util/image_constant.dart';
import 'package:onestoprx_driver/util/image_util.dart';
import 'package:onestoprx_driver/util/size_utils.dart';
import 'package:onestoprx_driver/widgets/custom_image_view.dart';


class SplashScreen extends StatefulWidget {
  
  
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Widget page = MainScreen();
  late AnimationController _animController;
  bool copAnimated = false;
  bool animateOnestopRx = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this);
    _animController.addListener(() {
      if (_animController.value > 0.7) {
        _animController.stop();
        copAnimated = true;
        setState(() {});
        Future.delayed(const Duration(seconds: 1), () {
          animateOnestopRx = true;
          setState(() {});
        });
      }
    });

    // Instead of directly navigating in initState
    // Use a post-frame callback to navigate after the build is complete
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   // Your navigation logic here
    //   Future.delayed(const Duration(milliseconds: 1000), () {
    //     AppLinksService().processPendingLinks();
    //   });
    //   final authController = context.read<AuthController>();
    //   if (await authController.getAuthData() == null) {
    //     NavigationService.goTo(IntroScreen.route);
    //   } else {
    //     NavigationService.pushReplacement(WelcomeBack.route);
    //     if (context.mounted) OneSignalService.logIn();
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        //  backgroundColor: ColorUtils.PRIMARY_COLOR,
        body: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: 40.h),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ImageConstant.show_splash_screen),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 5.v),
              CustomImageView(
                imagePath: ImageUtils.single_logo,
                height: 58.v,
                width: 220.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
