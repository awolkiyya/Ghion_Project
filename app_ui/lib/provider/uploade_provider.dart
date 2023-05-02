import 'dart:io';
// import 'dart:js_util';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';

class Service extends GetConnect {
  Future<String> addImage(Map<String, String> data, List<File?> files) async {
    try {
      final form = FormData(data);

      for (File? file in files) {
        form.files.add(
          MapEntry(
            "file[]",
            MultipartFile(File(file!.path),
                filename:
                    "${DateTime.now().microsecondsSinceEpoch}.${file.path.split('.').last}"),
          ),
        );
      }
      // form.add(data);
      final response = await post(
        "http://192.168.141.37:8000/api/storeProduct",
        form,
      );
      print(response.body);
      if (response.status.hasError) {
        return Future.error(response.body);
      } else {
        return response.body(["message"]);
      }
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
