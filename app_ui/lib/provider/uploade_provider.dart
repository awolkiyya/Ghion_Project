import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';

class Service {
  Future<bool> addImage(Map<String, String> data, String filepath) async {
    String addimageUrl = 'http://192.168.141.37:8000/api/register';
    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
    };
    var request = http.MultipartRequest('POST', Uri.parse(addimageUrl))
      ..fields.addAll(data)
      ..headers.addAll(headers)
      ..files.add(await http.MultipartFile.fromPath('image', filepath));
    var response = await request.send();
    // var body = json.decode(response.body);
    print(response.statusCode);
    // if (response.statusCode == 201) {
    //   return true;
    // } else {
    //   return false;
    // }
    return true;
  }
}
