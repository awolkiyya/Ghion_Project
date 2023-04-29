import 'dart:convert';
import 'package:app_ui/models/user.dart';
import 'package:get/get.dart';
import 'package:http/http.dart'
    as http; // this is used to connect with the laravel api it useds
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  // define here the api url
  late Rx<User?> user;
  late RxBool isLoading = false.obs;
  // this is the place every
  Future login(data, apiUrl) async {
    return await http.post(
      Uri.parse("http://192.168.141.37:8000/api/" + apiUrl),
      body: jsonEncode(data),
      headers: _setHeader(),
    );
  }

  _setHeader() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
  Future register(email, password) async {}
  bool loading() {
    if (isLoading.value == false) {
      return false;
    } else {
      return true;
    }
  }

  Future forgetPasswordEmail(data, apiUrl) async {
    return await http.post(
      Uri.parse("http://192.168.141.37:8000/api/" + apiUrl),
      body: jsonEncode(data),
      headers: _setHeader(),
    );
  }
}
