import 'package:flutter/material.dart';

class Product {
  int? id;
  String? title, description;
  SrcModelList? src;
  int? price;
  String? updateDate;
  // double rating;

  Product({
    this.id,
    this.src,
    this.title,
    this.price,
    this.description,
    this.updateDate,
  });
  factory Product.fromJson(Map<String, dynamic> json) {
    final images = json["images"];
    return Product(
      src: SrcModelList.fromJson(images),
      id: json['id'],
      title: json['tittle'],
      description: json['discription'],
      price: json['price'],
      updateDate: json['updated_at'],
    );
  }
}

class SrcModelList {
  List<SrcModel>? srcModel;
  SrcModelList({
    this.srcModel,
  });
  factory SrcModelList.fromJson(dynamic parsedJson) {
    List<SrcModel> srcModelList = [];
    if (parsedJson.length > 1) {
      for (var i = 0; i < parsedJson.length; i++) {
        srcModelList.add(SrcModel.fromMap(parsedJson["${i}"]));
      }
    }
    return SrcModelList(
      srcModel: srcModelList,
    );
  }
}

class SrcModel {
  String imagePath;
  String imageSize;
  SrcModel({
    required this.imagePath,
    required this.imageSize,
  });
  factory SrcModel.fromMap(Map<String, dynamic> jsonData) {
    return SrcModel(
      imagePath: jsonData['image_path'],
      imageSize: jsonData['image_size'],
    );
  }
}
// Our demo Products



// Our demo Products

// List<Product> demoProducts = [
//   Product(
//     id: 1,
//     images: [
//       "assets/images/ps4_console_white_1.png",
//       "assets/images/ps4_console_white_2.png",
//       "assets/images/ps4_console_white_3.png",
//       "assets/images/ps4_console_white_4.png",
//       "assets/images/ps4_console_white_1.png",
//       "assets/images/ps4_console_white_2.png",
//       "assets/images/ps4_console_white_3.png",
//       "assets/images/ps4_console_white_4.png",
//     ],
//     title: "Wireless Controller for PS4™",
//     price: 64.99,
//     description: description,
//     rating: 4.8,
//     isPopular: true,
//   ),
//   Product(
//     id: 2,
//     images: [
//       "assets/images/Image Popular Product 2.png",
//     ],
//     title: "Nike Sport White - Man Pant",
//     price: 50.5,
//     description: description,
//     isPopular: true,
//   ),
// ];

// const String description =
//     "Wireless Controller for PS4™ gives you what you want in your gaming from over precision control your games to sharing …";
