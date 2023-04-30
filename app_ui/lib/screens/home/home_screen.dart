import 'package:app_ui/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:app_ui/components/coustom_bottom_nav_bar.dart';
import 'package:app_ui/enums.dart';

import 'components/body.dart';
import 'package:get/get.dart';

// class HomeScreen extends StatelessWidget {
//   static String routeName = "/home";
//   final homeController = Get.put(HomeController());
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Body(),
//       bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
//     );
//   }
// }
class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});
  static String routeName = "/home";
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final homeController = Get.put(HomeController());
  @override
  void initState() {
    homeController.getUserinfo();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
    );
  }
}
