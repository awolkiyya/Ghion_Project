import 'components/body.dart';
import 'package:flutter/material.dart';

class AddProductScreen extends StatelessWidget {
  static String routeName = "/add_product";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Product Add Screen",
        ),
      ),
      body: Body(),
    );
  }
}
