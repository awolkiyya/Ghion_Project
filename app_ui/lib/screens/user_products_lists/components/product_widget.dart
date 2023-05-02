import 'package:app_ui/models/Product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import "package:get/get.dart";

Widget ProductWidget({required List<Product> products, context}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16),
    child: GridView.count(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 0.6,
      crossAxisSpacing: 6.0,
      mainAxisSpacing: 6.0,
      children: products.map((product) {
        return GridTile(
          child: InkWell(
            onTap: () => {},
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Color.fromARGB(179, 243, 241, 241),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl:
                          "http://192.168.141.37:8000/storage/${product.src!.srcModel![0].imagePath}",
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    child: Row(children: [
                      InkWell(
                        splashColor: Colors.amber,
                        child: Icon(
                          Icons.delete_forever_rounded,
                          size: 30,
                          color: Colors.red,
                        ),
                        onTap: () => {
                          Get.snackbar(
                            "Delete",
                            "This Button Is Used To Delete Product",
                            margin: EdgeInsets.all(20.0),
                          ),
                        },
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      InkWell(
                        child: Icon(
                          Icons.update,
                          size: 30,
                          color: Colors.green,
                        ),
                        onTap: () => {
                          Get.snackbar(
                            "Update",
                            "This Button Is Used To Update Product",
                            margin: EdgeInsets.all(20.0),
                          ),
                        },
                      ),
                    ]),
                    top: 250,
                    left: 40,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    ),
  );
}
