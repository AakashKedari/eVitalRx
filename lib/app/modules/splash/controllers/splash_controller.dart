import 'dart:async';
import 'package:evital/app/routes/app_pages.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {

  @override
  void onInit() {
    super.onInit();
    /// As soon as Splash Screen is displayed, we call this function to navigate to Home
    _navigateToHome();
  }

  void _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3));
    Get.offNamed(Routes.LOGIN); // Navigate to login screen
  }

}
