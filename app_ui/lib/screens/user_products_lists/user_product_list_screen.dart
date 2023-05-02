import 'dart:convert';

import 'package:app_ui/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import "package:get/get.dart";
import 'package:http/http.dart' as http;
import 'package:app_ui/screens/user_products_lists/components/product_widget.dart';
import 'package:app_ui/models/Product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProductList extends StatefulWidget {
  UserProductList({super.key});

  @override
  State<UserProductList> createState() => _UserProductListState();
}

class _UserProductListState extends State<UserProductList> {
  String present = "";
  String next = "";
  List<Product> productList = [];
  final homeController = Get.put(HomeController());
  bool _isdatafetched = false;
  @override
  void initState() {
    getProducts();
    // TODO: implement initState
    super.initState();
  }

  getProducts() async {
    if (homeController.demoProducts.isNotEmpty) {
      homeController.demoProducts.clear();
      print("Ok Now The IT IS CLEARED");
    }
    // first of all get currunt user id from the prefrence
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var user_id = _prefs.getInt("user_id");
    //  befor starting ttore make it null
    // homeController.demoProducts = [];
    var url = Uri.parse("http://192.168.141.37:8000/api/getProduct/${user_id}");
    var response = await http.get(url);
    // print(response.body);
    if (response.statusCode == 200) {
      var testJson = json.decode(response.body);
      // print(testJson["data"]);
      testJson["data"].forEach((singleproduct) {
        Product productModel = new Product();
        productModel = Product.fromJson(singleproduct);
        productList.add(productModel);
        // print(homeController.demoProducts[0].src!.srcModel![0].imagePath);
      });
      print(productList);
    } else {
      throw Exception('Failed to load Test');
    }
    setState(() {
      _isdatafetched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 30,
          ),
          onPressed: () => {
            Get.back(),
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          " Your Products List",
          style: TextStyle(color: Color.fromARGB(255, 36, 154, 130)),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              _isdatafetched
                  ? ProductWidget(products: productList, context: context)
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 2,
                      child: Center(
                        child: Image.asset(
                            "assets/images/ImpracticalNextFossa-size_restricted.gif"),
                      ),
                    ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: next != ""
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () async => {},
                            icon: Icon(Icons.arrow_forward_ios),
                          ),
                        ],
                      )
                    : SizedBox(
                        height: 10,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
