import 'dart:io';
import 'dart:ui';

import 'package:app_ui/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:app_ui/components/custom_surfix_icon.dart';
import 'package:app_ui/components/default_button.dart';
import 'package:app_ui/components/form_error.dart';
import 'package:app_ui/screens/complete_profile/complete_profile_screen.dart';
import 'package:app_ui/screens/widget/profile_edit_screen.dart';
import 'package:flutter/services.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  File? imageFile = File.fromUri(
    Uri(path: "https://img.freepik.com/free-icon/user_318-563642.jpg"),
  );
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String? conform_password;
  bool remember = false;
  final List<String?> errors = [];
  final loginController = Get.put(LoginController());
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

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      loginController.pickedFilePath.value = image.path;
      final imageTemp = File(image.path);
      setState(() => imageFile = imageTemp);
    } on PlatformException catch (e) {
      Get.snackbar("Error", 'Failed to pick image: $e');
    }
  }

  Future pickCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      loginController.pickedFilePath.value = image.path;
      final imageTemp = File(image.path);
      setState(() => imageFile = imageTemp);
    } on PlatformException catch (e) {
      Get.snackbar("Error", 'Failed to pick image: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildImageAvatar(),
          Column(
            children: [
              buildEmailFormField(),
              SizedBox(height: getProportionateScreenHeight(30)),
              buildPasswordFormField(),
              SizedBox(height: getProportionateScreenHeight(30)),
              buildConformPassFormField(),
              FormError(errors: errors),
              SizedBox(height: getProportionateScreenHeight(40)),
              DefaultButton(
                text: "Continue",
                press: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // if all are valid then go to success screen
                    // now here perform add data in controller
                    loginController.email.value = email!;
                    loginController.password.value = password!;
                    loginController.imageUrl.value = imageFile!;
                    Navigator.pushNamed(
                        context, CompleteProfileScreen.routeName);
                  }
                },
              )
            ],
          ),
        ],
      ),
    );
  }

  Column buildImageAvatar() {
    return Column(
      children: [
        Positioned(
          top: MediaQuery.of(context).size.height / 2,
          left: MediaQuery.of(context).size.height / 2,
          child: Container(
            // color: Colors.amber,
            width: 200,
            height: 180,
            // color: Color.fromARGB(255, 255, 255, 255),
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 255, 255, 255),
                  radius: 50,
                  backgroundImage: NetworkImage(
                      "https://img.freepik.com/free-icon/user_318-563642.jpg"),

                  child: InkWell(
                    onTap: () => {
                      Get.to(ProfileEditScreen(imageUrl: imageFile),
                          transition: Transition.downToUp),
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: FileImage(imageFile!),
                        ),
                      ),
                    ),
                  ), //Text
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Positioned(
                      top: 55,
                      left: 60,
                      child: IconButton(
                        icon: Icon(
                          Icons.image,
                          color: Color.fromARGB(255, 36, 154, 130),
                          size: 30,
                        ),
                        onPressed: () {
                          pickImage();
                        },
                      ),
                    ),
                    Positioned(
                      top: 55,
                      left: 60,
                      child: IconButton(
                        icon: Icon(
                          Icons.camera_alt,
                          color: Color.fromARGB(255, 36, 154, 130),
                          size: 30,
                        ),
                        onPressed: () {
                          pickCamera();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  TextFormField buildConformPassFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => conform_password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.isNotEmpty && password == conform_password) {
          removeError(error: kMatchPassError);
        }
        conform_password = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if ((password != value)) {
          addError(error: kMatchPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Confirm Password",
        hintText: "Re-enter your password",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => password = newValue!,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        password = value;
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
      onSaved: (newValue) => email = newValue!,
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
