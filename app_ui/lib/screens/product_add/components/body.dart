import 'package:flutter/material.dart';
import 'package:app_ui/components/socal_card.dart';
import 'package:app_ui/constants.dart';
import 'package:app_ui/size_config.dart';
import 'product_add_form.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.04), // 4%
                Text("Create Your Product", style: headingStyle),
                Text(
                  "Complate Your Full Fields To Create\n Product",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
                ProductFrom(),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
