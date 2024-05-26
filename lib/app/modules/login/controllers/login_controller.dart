import 'package:get/get.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;
  final String correctMobile = '9033006262';
  final String correctPassword = 'eVital@12';

  void login(String mobile, String password) async {
    isLoading.value = true;

    await Future.delayed(Duration(seconds: 2)); // Simulate a network request

    if (mobile == correctMobile && password == correctPassword) {
      Get.offAllNamed('/home'); // Navigate to home screen on successful login
    } else {
      Get.snackbar('Error', 'Invalid mobile number or password',
          snackPosition: SnackPosition.BOTTOM);
    }

    isLoading.value = false;
  }

  String? validateMobile(String value) {
    if (value.isEmpty) {
      return 'Mobile number is required';
    } else if (value.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Enter a valid 10-digit mobile number';
    }
    return null;
  }

  String? validatePassword(String value) {
    if (value.isEmpty) {
      return 'Password is required';
    } else if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    return null;
  }
}
