import 'dart:developer' show log;
import 'package:evital/app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class LoginController extends GetxController {
  final mobileController = TextEditingController();
  final passwordController = TextEditingController();
  var isLoading = false.obs;
  final String correctMobile = '9033006262';
  final String correctPassword = 'eVital@12';
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void onClose() {
    super.onClose();
    log('Text Editing Controllers disposed');
    mobileController.dispose();
    passwordController.dispose();
    _audioPlayer.dispose();
  }

  Future<void> playErrorSound() async {
    try {
      await _audioPlayer.setAsset(AssetsPath.errorSound);
      _audioPlayer.play();
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }

  playSuccessSound() async {
    try {
      await _audioPlayer.setAsset(AssetsPath.successSound);
      _audioPlayer.play();
    } catch (e) {
      log("Error loading audio source: $e");
    }
  }

  void login(String mobile, String password) async {
    isLoading.value = true;

    // To show like a network request
    await Future.delayed(const Duration(seconds: 2));

    // Navigate to home screen on successful login
    if (mobile == correctMobile && password == correctPassword) {
      playSuccessSound();
      Get.offAllNamed('/home');
    } else {
      playErrorSound();
      Get.snackbar('Error', 'Invalid mobile number or password',
          snackPosition: SnackPosition.BOTTOM);
    }

    isLoading.value = false;
  }

  String? validateMobile(String value) {
    if (value.isEmpty) {
      playErrorSound();
      return 'Mobile number is required';
    } else if (value.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(value)) {
      playErrorSound();
      return 'Enter a valid 10-digit mobile number';
    }
    return null;
  }

  String? validatePassword(String value) {
    if (value.isEmpty) {
      playErrorSound();
      return 'Password is required';
    } else if (value.length < 8) {
      playErrorSound();
      return 'Password must be at least 8 characters long';
    }
    return null;
  }
}
