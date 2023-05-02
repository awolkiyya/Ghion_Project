import 'dart:convert';
import 'dart:io';
import 'package:app_ui/models/Product.dart';
import 'package:app_ui/provider/uploade_provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_ui/models/User.dart' as model;
import 'package:flutter/material.dart';

class HomeController extends GetxController {
  // now here create the userModel instances to fetch the user data
  // the method fetch user data by user id
  late model.User user;
  List<Product> demoProducts = [];
  final List<File?> compressedImageList = [];
  var barrierDismissible = false.obs;
  void getUserinfo() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var userId = _prefs.getInt('user_id');
    // now perform the get operation using the user id
    print(userId);
    var res = await http.get(
      Uri.parse("http://192.168.141.37:8000/api/getUser/${userId}"),
    );
    var body = json.decode(res.body);
    if (body['status'] == 200) {
      Get.snackbar('Success', body['message']);
      // then here store the data to User model
      user = model.User.fromJson(body['data']);
    }
  }

  Future<void> compress(data, List<File?> _imageFiles) async {
    if (compressedImageList.isNotEmpty) {
      compressedImageList.clear();
    }
    final dir = await Directory.systemTemp;
    final targetpath = dir.absolute.path + "/compressed.jpg";
    for (var imageFile in _imageFiles) {
      var result = await FlutterImageCompress.compressAndGetFile(
        imageFile!.path,
        targetpath,
        quality: 66,
      );
      compressedImageList.add(result);
    }
    // let chack the size of the image
    print(((File(_imageFiles[0]!.path)).lengthSync() / 1024 / 1024)
            .toStringAsFixed(2) +
        "Mb");

    print(((File(compressedImageList[0]!.path)).lengthSync() / 1024 / 1024)
            .toStringAsFixed(2) +
        "Mb");
    storeUserData(data, compressedImageList, 'storeProduct');
  }

  // now start store the data to the server
  Future storeUserData(data, files, apiUrl) async {
    if (files.length > 0) {
      Service()
          .addImage(data, files)
          .then(
            (res) => {
              if (res == "success")
                {Get.snackbar("success", "your strength are amazing")},
            },
          )
          .onError((error, stackTrace) => {});
    }
    // //  now perform besic operation neded
    // Map<String, String> headers = {
    //   'Content-Type': 'multipart/form-data',
    // };
    // // Get.dialog(
    // //   Center(
    // //     child: CircularProgressIndicator(),
    // //   ),
    // //   barrierDismissible: barrierDismissible.value,
    // // );
    // //    for (var i = 0; i < _image.length; i++) {
    // //   print(_image.length);
    // //   var request =
    // //       http.MultipartRequest('POST', Uri.parse(url + _scanQrCode));
    // //   print(Uri.parse(url + _scanQrCode));
    // //   request.files.add(http.MultipartFile.fromBytes(
    // //     'picture',
    // //     File(_image[i].path).readAsBytesSync(),
    // //     filename: _image[i].path.split("/").last
    // //   ));
    // //   var res = await request.send();
    // //     var responseData = await res.stream.toBytes();
    // //     var result = String.fromCharCodes(responseData);
    // //     print(_image[i].path);
    // // }
    // var request = http.MultipartRequest(
    //     'POST', Uri.parse("http://192.168.141.37:8000/api/" + apiUrl))
    //   ..fields.addAll(data)
    //   ..headers.addAll(headers);

    // List<http.MultipartFile> newList = [];
    // for (int i = 0; i < files.length; i++) {
    //   // var path = await FlutterAbsolutePath.getAbsolutePath(files[i].identifier);

    //   File imageFile = File(files[i].path);

    //   var stream = http.ByteStream(imageFile.openRead());
    //   var length = await imageFile.length();

    //   var multipartFile = new http.MultipartFile("images", stream, length,
    //       filename: imageFile.path);
    //   newList.add(multipartFile);
    // }
    // print(newList.length);
    // request.files.addAll(newList);
    // var response = await request.send();
    // print(response.reasonPhrase);
    // // if (response.statusCode == 200) {
    // //   Get.back();
    // //   barrierDismissible.value = true;
    // //   Get.snackbar(
    // //     "Success",
    // //     "User Created Successfully",
    // //     margin: EdgeInsets.all(20.0),
    // //   );
    // //   // Get.to(LoginSuccessScreen());
    // //   // then performe the navigation
    // // } else {
    // //   Get.back();
    // //   barrierDismissible.value = true;
    // //   print(response.statusCode);
    // //   Get.snackbar("Errors", "Validation Error Check Your Input Field",
    // //       margin: EdgeInsets.all(20.0),
    // //       icon: Icon(
    // //         Icons.warning_amber_rounded,
    // //         color: Colors.red,
    // //         size: 40.0,
    // //       ));
    // // }
  }

  void createProduct(var data, List<File?> imageList) async {
    print(data);
    compress(data, imageList);
  }
}
