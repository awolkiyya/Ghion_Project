import 'dart:convert';

import 'package:app_ui/controllers/login_controller.dart';
import 'package:app_ui/helper/keyboard.dart';
import 'package:flutter/material.dart';
import 'package:app_ui/components/custom_surfix_icon.dart';
import 'package:app_ui/components/default_button.dart';
import 'package:app_ui/components/form_error.dart';
import 'package:app_ui/components/no_account_text.dart';
import 'package:app_ui/size_config.dart';

import '../../../constants.dart';
import 'package:get/get.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.04),
              Text(
                "Forgot Password",
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(28),
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Please enter your email and we will send \nyou a link to return to your account",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.1),
              ForgotPassForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class ForgotPassForm extends StatefulWidget {
  @override
  _ForgotPassFormState createState() => _ForgotPassFormState();
}

class _ForgotPassFormState extends State<ForgotPassForm> {
  final _formKey = GlobalKey<FormState>();
  List<String> errors = [];
  String? email;
  final loginController = Get.put(LoginController());
  forgetPassword() async {
    var data = {
      'email': email,
    };
    var res =
        await loginController.forgetPasswordEmail(data, 'forget-password');
    print(res.body);
    var body = json.decode(res.body);
    // print(body);
    if (body['message'] != null) {
      Get.snackbar(
        "Error",
        "Failed to authenticate \t\t" + email! + "\t\t\t on SMTP server ",
        icon: Icon(
          Icons.warning_amber_rounded,
          color: Colors.red,
          size: 40.0,
        ),
        margin: EdgeInsets.all(20.0),
      );
    }
    loginController.isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                onSaved: (newValue) => email = newValue,
                onChanged: (value) {
                  if (value.isNotEmpty && errors.contains(kEmailNullError)) {
                    setState(() {
                      errors.remove(kEmailNullError);
                    });
                  } else if (emailValidatorRegExp.hasMatch(value) &&
                      errors.contains(kInvalidEmailError)) {
                    setState(() {
                      errors.remove(kInvalidEmailError);
                    });
                  }
                  return null;
                },
                validator: (value) {
                  if (value!.isEmpty && !errors.contains(kEmailNullError)) {
                    setState(() {
                      errors.add(kEmailNullError);
                    });
                  } else if (!emailValidatorRegExp.hasMatch(value) &&
                      !errors.contains(kInvalidEmailError)) {
                    setState(() {
                      errors.add(kInvalidEmailError);
                    });
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: "Email",
                  hintText: "Enter your email",
                  // If  you are using latest version of flutter then lable text and hint text shown like this
                  // if you r using flutter less then 1.20.* then maybe this is not working properly
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon:
                      CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(30)),
              FormError(errors: errors),
              SizedBox(height: SizeConfig.screenHeight * 0.1),
              loginController.loading()
                  ? const CircularProgressIndicator()
                  : DefaultButton(
                      text: "Continue",
                      press: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          // if all are valid then go to success screen
                          KeyboardUtil.hideKeyboard(context);
                          // Do what you want to do
                          forgetPassword();
                          loginController.isLoading.value = true;
                        }
                      },
                    ),
              SizedBox(height: SizeConfig.screenHeight * 0.1),
              NoAccountText(),
            ],
          ),
        ));
  }
}
