import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:app_ui/models/Product.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class ProductDescription extends StatelessWidget {
  const ProductDescription({
    Key? key,
    required this.product,
    this.pressOnSeeMore,
  }) : super(key: key);

  final Product product;
  final GestureTapCallback? pressOnSeeMore;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20)),
            child: Text(
              "${product.title}",
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          SizedBox(height: 10.0),
          Padding(
            padding: EdgeInsets.only(
              left: getProportionateScreenWidth(20),
              right: getProportionateScreenWidth(64),
            ),
            child: Text(
              "${product.description}",
            ),
          ),
          // Const
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(20),
              vertical: 10,
            ),
            child: GestureDetector(
              onTap: () {},
              child: Row(
                children: [
                  Text(
                    "price ${product.price} Birr",
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: kPrimaryColor),
                  ),
                  SizedBox(width: 5),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(20),
              vertical: 5,
            ),
            child: GestureDetector(
              onTap: () {},
              child: Row(
                children: [
                  Text(
                    "Updated Date ${product.updateDate}",
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: kPrimaryColor),
                  ),
                  SizedBox(width: 5),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
