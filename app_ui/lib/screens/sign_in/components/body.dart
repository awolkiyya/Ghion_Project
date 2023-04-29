import 'package:app_ui/api/google_sign_api.dart';
import 'package:flutter/material.dart';
import 'package:app_ui/components/no_account_text.dart';
import 'package:app_ui/components/socal_card.dart';
import '../../../size_config.dart';
import 'sign_form.dart';
import 'package:get/get.dart';

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
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                Text(
                  "Welcome Back",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(28),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Sign in with your email and password  \nor continue with social media",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
                SignForm(),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 50,
                      child: SocalCard(
                        icon: "assets/icons/google-icon.svg",
                        press: signIn,
                      ),
                    ),
                    // SocalCard(
                    //   icon: "assets/icons/facebook-icon.svg",
                    //   press: signOut,
                    // ),
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                NoAccountText(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future signIn() async {
    final user = await GoogleSignInApi.login();
    Get.snackbar(
      "",
      "" + user!.email,
      margin: EdgeInsets.all(20.0),
    );
  }

  Future signOut() async {
    await GoogleSignInApi.logout();
    Get.snackbar(
      "message",
      "user sign out successfully",
      margin: EdgeInsets.all(20.0),
    );
  }
}
