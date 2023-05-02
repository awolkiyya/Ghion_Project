import 'dart:io';
import 'dart:ui';

import 'package:app_ui/controllers/home_controller.dart';
import 'package:app_ui/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:app_ui/components/custom_surfix_icon.dart';
import 'package:app_ui/components/default_button.dart';
import 'package:app_ui/components/form_error.dart';
import 'package:app_ui/screens/complete_profile/complete_profile_screen.dart';
import 'package:app_ui/screens/widget/profile_edit_screen.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProductFrom extends StatefulWidget {
  @override
  _ProductFromState createState() => _ProductFromState();
}

class _ProductFromState extends State<ProductFrom> {
  File? imageFile = File.fromUri(
    Uri(path: "https://img.freepik.com/free-icon/user_318-563642.jpg"),
  );
  final _formKey = GlobalKey<FormState>();
  String tittle = "";
  String catagory = "";
  String price = "";
  String description = "";
  int count = 0;
  final List<File?> imageFileList = [];
  final List<String?> errors = [];
  final homeController = Get.put(HomeController());
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
      if (imageFileList.isNotEmpty) {
        imageFileList.clear();
        count = 0;
        print(imageFileList);
      }
      final List<XFile>? selectedImage = await ImagePicker().pickMultiImage();
      if (selectedImage!.isNotEmpty) {
        for (var i = 0; i < selectedImage.length; i++) {
          imageFileList.add(File(selectedImage[i].path));
        }
        setState(() {
          count = selectedImage.length;
        });
      }
      // loginController.pickedFilePath.value = image.path;
      // final imageTemp = File(image.path);
      // setState(() => imageFile = imageTemp);
    } on PlatformException catch (e) {
      Get.snackbar("Error", 'Failed to pick image: $e');
    }
  }

  store() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var data = {
      'tittle': tittle,
      'price': price,
      'catagory': catagory,
      'description': description,
      'user_id': _prefs.get("user_id").toString(),
    };
    // now chacking the number of image picked
    if (count >= 1) {
      // go to store or
      homeController.createProduct(data, imageFileList);
    } else {
      Get.snackbar(
          "message", "Please select at least more than two product images");
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
          Column(
            children: [
              buildTittleFormField(),
              SizedBox(height: getProportionateScreenHeight(20)),
              buildCatagoreFormField(),
              SizedBox(height: getProportionateScreenHeight(20)),
              buildPriceFormField(),
              SizedBox(height: getProportionateScreenHeight(20)),
              buildDescriptionFormField(),
              FormError(errors: errors),
              SizedBox(height: getProportionateScreenHeight(20)),
            ],
          ),
          buildImageAvatar(),
          DefaultButton(
            text: "Save Your Data",
            press: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                // now start storing the product info
                store();
              }
            },
          )
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
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Positioned(
                        top: 55,
                        left: 0,
                        child: Column(
                          children: [
                            Text("Select product images ${count}"),
                            IconButton(
                              icon: Icon(
                                Icons.image,
                                color: Color.fromARGB(255, 36, 154, 130),
                                size: 60,
                              ),
                              onPressed: () {
                                pickImage();
                              },
                            ),
                          ],
                        )),
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  TextFormField buildPriceFormField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      onSaved: (newValue) => price = newValue!,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPriceNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Price",
        hintText: "Enter your product price",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildDescriptionFormField() {
    return TextFormField(
      maxLines: 2,
      maxLength: 1000,
      onSaved: (newValue) => description = newValue!,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kdescriptionNullError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kdescriptionNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Description",
        hintText: "Enter your product description",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildCatagoreFormField() {
    return TextFormField(
      onSaved: (newValue) => catagory = newValue!,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kcatagoryNullError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kcatagoryNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Catagory",
        hintText: "Enter your product catagory",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildTittleFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => tittle = newValue!,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kTittleNullError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kTittleNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Tittle",
        hintText: "Enter your product tittle",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}
