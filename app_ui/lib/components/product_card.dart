import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:app_ui/models/Product.dart';
import 'package:app_ui/screens/details/details_screen.dart';

import '../constants.dart';
import '../size_config.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key? key,
    this.width = 140,
    this.aspectRetio = 1.02,
    required this.product,
  }) : super(key: key);

  final double width, aspectRetio;
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(5)),
      child: SizedBox(
        width: getProportionateScreenWidth(width),
        child: GestureDetector(
          onTap: () => Navigator.pushNamed(
            context,
            DetailsScreen.routeName,
            arguments: ProductDetailsArguments(product: product),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1.02,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Hero(
                    tag: product.id.toString(),
                    child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  "http://192.168.141.37:8000/storage/${product.src!.srcModel![0].imagePath}"))),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                product.title!,
                style: TextStyle(color: Colors.black),
                maxLines: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${product.price} Birr",
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(18),
                      fontWeight: FontWeight.w600,
                      color: kPrimaryColor,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
