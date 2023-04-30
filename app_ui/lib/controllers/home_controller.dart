import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_ui/models/User.dart' as model;

class HomeController extends GetxController {
  // now here create the userModel instances to fetch the user data
  // the method fetch user data by user id
  late model.User user;

  void getUserinfo() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var userId = _prefs.getInt('user_id');
    // now perform the get operation using the user id
    print(userId);
    var res = await http.get(
      Uri.parse("http://192.168.141.37:8000/api/getUser/${userId}"),
    );
    var body = json.decode(res.body);
    print(body['data']);
    if (body['status'] == 200) {
      Get.snackbar('Success', body['message']);
      // then here store the data to User model
      user = model.User.fromJson(body['data']);
      print(user.email);
    }
  }
}
