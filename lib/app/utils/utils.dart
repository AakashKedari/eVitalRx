import 'package:get/get.dart';

class Utils {
  static showSnackBar(String message){
    return Get.showSnackbar( GetSnackBar(message: message,duration: const Duration(seconds: 2),));
  }
}

class AssetsPath {
  static const String profilePic = 'assets/images/arrow.png';
  static const String appLogo = 'assets/images/evitalRx.webp';
  static const String successSound = 'assets/sounds/success.mp3';
  static const String errorSound = 'assets/sounds/error.mp3';
}