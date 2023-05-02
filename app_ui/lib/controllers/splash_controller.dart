import 'package:app_ui/screens/home/home_screen.dart';
import 'package:app_ui/screens/login_success/login_success_screen.dart';
import 'package:app_ui/screens/sign_in/sign_in_screen.dart';
import 'package:app_ui/screens/sign_up/sign_up_screen.dart';
import 'package:app_ui/screens/splash/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController {
  @override
  void onInit() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.remove('token');
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    if (_prefs.getInt("token") != null) {
      Get.offAllNamed(HomeScreen.routeName);
    } else {
      Get.offAllNamed(SplashScreen.routeName);
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
