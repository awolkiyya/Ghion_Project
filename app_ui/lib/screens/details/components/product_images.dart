import 'package:flutter/material.dart';
import 'package:app_ui/models/Product.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class ProductImages extends StatefulWidget {
  const ProductImages({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  _ProductImagesState createState() => _ProductImagesState();
}

class _ProductImagesState extends State<ProductImages> {
  int selectedImage = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: getProportionateScreenWidth(238),
          child: AspectRatio(
            aspectRatio: 1,
            child: Hero(
              tag: widget.product.id.toString(),
              child: Container(
                margin: EdgeInsets.only(top: 20.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            "http://192.168.141.37:8000/storage/${widget.product.src!.srcModel![selectedImage].imagePath}"))),
              ),
            ),
          ),
        ),
        // SizedBox(height: getProportionateScreenWidth(20)),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...List.generate(widget.product.src!.srcModel!.length,
                    (index) => buildSmallProductPreview(index)),
              ],
            ),
          ),
        )
      ],
    );
  }

  GestureDetector buildSmallProductPreview(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          print(index);
          selectedImage = index;
        });
      },
      child: AnimatedContainer(
        duration: defaultDuration,
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        height: getProportionateScreenWidth(80),
        width: getProportionateScreenWidth(80),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: kPrimaryColor.withOpacity(selectedImage == index ? 1 : 0)),
        ),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                  "http://192.168.141.37:8000/storage/${widget.product.src!.srcModel![index].imagePath}"),
            ),
          ),
        ),
      ),
    );
  }
}
