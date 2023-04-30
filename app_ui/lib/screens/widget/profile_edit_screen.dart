import 'package:flutter/material.dart';
import 'dart:io';

class ProfileEditScreen extends StatefulWidget {
  File? imageUrl;
  ProfileEditScreen({super.key, required this.imageUrl});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // color: Colors.amber,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            color: Colors.amber,
            image: DecorationImage(
                image: FileImage(widget.imageUrl!), fit: BoxFit.cover)),
      ),
    );
  }
}
