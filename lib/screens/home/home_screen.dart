import 'dart:io';

import 'package:back_pressed/back_pressed.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inventaris/screens/dashboard/dashboard_screen.dart';
import 'package:inventaris/shared/translate_app.dart';
import 'package:inventaris/utils/my_alert.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  final pageController = PageController();

  bool isFirstAccess = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OnBackPressed(
      perform: () {
        MyAlert.confirm(
            title: TranslateApp(context).text("alert_attention"),
            text: TranslateApp(context).text("msg_confirm_exit_app"),
            context: context,
            onConfirmBtnTap: () {
              if (Platform.isAndroid) {
                SystemNavigator.pop();
              } else if (Platform.isIOS) {
                exit(0);
              }
            });
      },
      child: Scaffold(
        body:
        PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          children: [
            DashoardTab(),
            // ClientTab(),
            Container(color: Colors.green),
            Container(color: Colors.pink),
            Container(color: Colors.red),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
              pageController.jumpToPage(index);
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Theme.of(context).colorScheme.primary,
          items: [
            BottomNavigationBarItem(
              icon: currentIndex == 0
                  ? Icon(Icons.dashboard)
                  : Icon(Icons.dashboard_outlined),
              label: TranslateApp(context).text("dashboard"),
            ),
            BottomNavigationBarItem(
              icon: currentIndex == 1
                  ? Icon(Icons.group_add)
                  : Icon(Icons.group_add_outlined),
              label: TranslateApp(context).text("clients"),
            ),
            // BottomNavigationBarItem(
            //   icon: currentIndex == 2
            //       ? Icon(Icons.account_circle)
            //       : Icon(Icons.account_circle_outlined),
            //   label: TranslateApp(context).text("loans"),
            // ),
            // BottomNavigationBarItem(
            //   icon: currentIndex == 3
            //       ? Icon(Icons.person)
            //       : Icon(Icons.person_outlined),
            //   label: TranslateApp(context).text("profile"),
            // ),
          ],
        ),
      ),
    );
  }
}