import 'package:app_ui/screens/product_add/add_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:app_ui/screens/cart/cart_screen.dart';
import 'package:get/get.dart';

import '../../../size_config.dart';
import 'icon_btn_with_counter.dart';
import 'search_field.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SearchField(),
          IconBtnWithCounter(
            svgSrc: "assets/icons/Search Icon.svg",
            press: () => {
              Get.snackbar(
                "Search",
                "This button used to search product by there catagores",
                margin: EdgeInsets.all(10.0),
              ),
            },
          ),
          IconBtnWithCounter(
            svgSrc: "assets/icons/Plus Icon.svg",
            press: () {
              Get.to(AddProductScreen());
            },
          ),
        ],
      ),
    );
  }
}
