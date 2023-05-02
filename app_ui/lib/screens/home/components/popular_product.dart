import 'package:app_ui/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:app_ui/components/product_card.dart';
import 'package:app_ui/models/Product.dart';

import '../../../size_config.dart';
import 'section_title.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PopularProducts extends StatefulWidget {
  const PopularProducts({super.key});

  @override
  State<PopularProducts> createState() => _PopularProductsState();
}

class _PopularProductsState extends State<PopularProducts> {
  final homeController = Get.put(HomeController());
  //determine if all data has been recieved
  var url = "http://192.168.141.37:8000/api/getProduct";
  getProducts() async {
    // every time this page load chacking the demoProducts list
    if (homeController.demoProducts.isNotEmpty) {
      homeController.demoProducts.clear();
      print("Ok Now The IT IS CLEARED");
    }
    //  befor starting ttore make it null
    // homeController.demoProducts = [];
    var url = Uri.parse("http://192.168.141.37:8000/api/getProduct");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var testJson = json.decode(response.body);
      // print(testJson["data"]);
      testJson["data"].forEach((singleproduct) {
        Product productModel = new Product();
        productModel = Product.fromJson(singleproduct);
        homeController.demoProducts.add(productModel);
        // print(homeController.demoProducts[0].src!.srcModel![0].imagePath);
      });
      print(homeController.demoProducts.length);
    } else {
      throw Exception('Failed to load Test');
    }
  }

  @override
  void initState() {
    homeController.getUserinfo();
    // here get the products
    getProducts();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SectionTitle(title: "All Products List", press: () {}),
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: GridView.count(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 0.6,
                crossAxisSpacing: 6.0,
                mainAxisSpacing: 6.0,
                children: [
                  ...List.generate(
                    homeController.demoProducts.length,
                    (index) {
                      return ProductCard(
                        product: homeController.demoProducts[index],
                      ); // here by default width and height is 0
                    },
                  ),
                  SizedBox(width: getProportionateScreenWidth(20)),
                ]),
          ),
        )
      ],
    );
  }
}
