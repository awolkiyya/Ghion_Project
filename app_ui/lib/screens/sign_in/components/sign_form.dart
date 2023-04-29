import 'dart:convert';

import 'package:app_ui/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:app_ui/components/custom_surfix_icon.dart';
import 'package:app_ui/components/form_error.dart';
import 'package:app_ui/helper/keyboard.dart';
import 'package:app_ui/screens/forgot_password/forgot_password_screen.dart';
import 'package:app_ui/screens/login_success/login_success_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import 'package:get/get.dart';

class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String? email;
  String? password;
  bool? remember = false;
  bool _isLoading = false;
  // now here the dependecy inject is needed
  final loginController = Get.put(LoginController());
  _login() async {
    var data = {
      'email': email,
      'password': password,
    };
    var res = await loginController.login(data, 'login');
    var body = json.decode(res.body);
    if (body['status'] == 200) {
      Get.snackbar(
        "Success",
        body['message'],
        icon: Icon(Icons.handshake_rounded),
        margin: EdgeInsets.all(20.0),
      );
      if (remember != false) {
        print("i am going to store preference");
        SharedPreferences.getInstance().then(
          (prefs) {
            prefs.setBool("remember_me", remember!);
            prefs.setString('email', email!);
            prefs.setString('password', password!);
          },
        );
      } else {
        SharedPreferences _prefs = await SharedPreferences.getInstance();
        _prefs.remove("remember_me");
        _prefs.remove("email");
        _prefs.remove("password");
      }
      Navigator.pushNamed(context, LoginSuccessScreen.routeName);
    } else {
      Get.snackbar(
        "Error",
        body['message'],
        margin: EdgeInsets.all(15.0),
        padding: EdgeInsets.all(15.0),
        icon: Icon(
          Icons.warning_amber_rounded,
          color: Colors.red,
          size: 40.0,
        ),
        colorText: Color.fromARGB(255, 6, 6, 6),
      );
      if (remember == false) {
        SharedPreferences _prefs = await SharedPreferences.getInstance();
        _prefs.remove("remember_me");
        _prefs.remove("email");
        _prefs.remove("password");
      }
    }
    loginController.isLoading.value = false;
  }

  //load email and password
  void _loadUserEmailPassword() async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      var _email = _prefs.getString("email") ?? "";
      var _password = _prefs.getString("password") ?? "";
      var _remeberMe = _prefs.getBool("remember_me") ?? false;
      print(_remeberMe);
      print(_email);
      print(_password);
      if (_remeberMe) {
        setState(() {
          remember = true;
        });
        _emailController.text = _email ?? "";
        _passwordController.text = _password ?? "";
      }
    } catch (e) {
      print(e);
    }
  }

  final List<String?> errors = [];

  void addError({String? error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String? error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  void initState() {
    _loadUserEmailPassword();
    print("i am here to load");

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Form(
        key: _formKey,
        child: Column(
          children: [
            buildEmailFormField(),
            SizedBox(height: getProportionateScreenHeight(30)),
            buildPasswordFormField(),
            SizedBox(height: getProportionateScreenHeight(30)),
            Row(
              children: [
                Checkbox(
                  value: remember,
                  activeColor: kPrimaryColor,
                  onChanged: (value) {
                    setState(() {
                      remember = value;
                    });
                  },
                ),
                Text("Remember me"),
                Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(
                      context, ForgotPasswordScreen.routeName),
                  child: Text(
                    "Forgot Password",
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                )
              ],
            ),
            FormError(errors: errors),
            SizedBox(height: getProportionateScreenHeight(20)),
            loginController.loading()
                ? const CircularProgressIndicator()
                : DefaultButton(
                    text: "Continue",
                    press: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        // if all are valid then go to success screen
                        KeyboardUtil.hideKeyboard(context);
                        _login();
                        loginController.isLoading.value = true;
                        // Navigator.pushNamed(context, LoginSuccessScreen.routeName);
                      }
                    },
                  ),
          ],
        ),
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      controller: _passwordController,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 8) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Enter your password",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: _emailController,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "Enter your email",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }
}
