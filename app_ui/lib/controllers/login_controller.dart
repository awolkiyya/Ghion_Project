import 'dart:convert';
import 'dart:io';
import 'package:app_ui/models/user.dart';
import 'package:app_ui/screens/login_success/login_success_screen.dart';
import 'package:app_ui/screens/sign_in/sign_in_screen.dart';
import 'package:get/get.dart';
import 'package:http/http.dart'
    as http; // this is used to connect with the laravel api it useds
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  // create the state here to manage app
  late Rx<File?> imageUrl = File.fromUri(
    Uri(path: "https://img.freepik.com/free-icon/user_318-563642.jpg"),
  ).obs;
  late RxString email = "".obs;
  late RxString password = "".obs;
  // define here the api url
  late Rx<User?> user;
  late RxBool isLoading = false.obs;
  var compreddImagePath = ''.obs;
  var compreddImageSize = ''.obs;
  var pickedFilePath = ''.obs;
  var barrierDismissible = false.obs;

  // this is the function compressed the picked image before uploaded
  Future compressImage(data) async {
    final dir = await Directory.systemTemp;
    final targetpath = dir.absolute.path + "/temp.jpg";
    // now let start comprassion
    var compressedFile = await FlutterImageCompress.compressAndGetFile(
      pickedFilePath.value,
      targetpath,
      quality: 100,
    );
    // compreddImagePath = compressedFile.path;
    print(((File(pickedFilePath.value)).lengthSync() / 1024 / 1024)
            .toStringAsFixed(2) +
        "Mb");

    print(((File(compressedFile!.path)).lengthSync() / 1024 / 1024)
            .toStringAsFixed(2) +
        "Mb");
    storeUserData(data, compressedFile, 'register');

    // return null;
  }

  Future storeUserData(data, file, apiUrl) async {
    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
    };
    Get.dialog(
      Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: barrierDismissible.value,
    );
    var request = http.MultipartRequest(
        'POST', Uri.parse("http://192.168.141.37:8000/api/register"))
      ..fields.addAll(data)
      ..headers.addAll(headers)
      ..files.add(await http.MultipartFile.fromPath('image', file.path));
    var response = await request.send();
    print(response);
    if (response.statusCode == 200) {
      Get.back();
      barrierDismissible.value = true;
      Get.snackbar(
        "Success",
        "User Created Successfully",
        margin: EdgeInsets.all(20.0),
      );
      Get.to(LoginSuccessScreen());
      // then performe the navigation
    } else {
      Get.back();
      barrierDismissible.value = true;
      print(response.statusCode);
      Get.snackbar("Errors", "Validation Error Check Your Input Field",
          margin: EdgeInsets.all(20.0),
          icon: Icon(
            Icons.warning_amber_rounded,
            color: Colors.red,
            size: 40.0,
          ));
    }
  }

  // this is the login place
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
  // this is registration place
  Future register(data) async {
    await compressImage(data);
  }

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

  //this is the logout place
  void logout() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.remove("token");
    _prefs.remove("user_id");
    Get.snackbar(
      "Success",
      "User Logout Successfully",
      margin: EdgeInsets.all(20.0),
    );
    Get.offAllNamed(SignInScreen.routeName);
  }
}
