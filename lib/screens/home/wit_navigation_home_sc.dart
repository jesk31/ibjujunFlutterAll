import 'package:flutter/material.dart';
import 'package:witibju_1/screens/home/wit_check_list.dart';
import 'package:witibju_1/screens/home/wit_drawer_user_controller.dart';
import 'package:witibju_1/screens/home/wit_home_drawer.dart';
import 'package:witibju_1/screens/home/wit_home_sc.dart';
import 'package:witibju_1/screens/home/wit_home_theme.dart';

class NavigationHomeScreen extends StatefulWidget {
  const NavigationHomeScreen({super.key});

  @override
  State<NavigationHomeScreen> createState() => _NavigationHomeScreenState();
}

class _NavigationHomeScreenState extends State<NavigationHomeScreen> {
  Widget? screenView;
  DrawerIndex? drawerIndex;

  @override
  void initState() {

    screenView = const HomeScreen();
    drawerIndex = DrawerIndex.HOME;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: WitHomeTheme.white,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: WitHomeTheme.nearlyWhite,
          body: DrawerUserController(
            screenIndex: drawerIndex,
            drawerWidth: MediaQuery.of(context).size.width * 0.75,
            onDrawerCall: (DrawerIndex drawerIndexdata) {
              changeIndex(drawerIndexdata);
              //callback from drawer for replace screen as user need with passing DrawerIndex(Enum index)
            },
            screenView: screenView,
            //we replace screen view as we need on navigate starting screens like MyHomePage, HelpScreen, FeedbackScreen, etc...
          ),
        ),
      ),
    );
  }

  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      switch (drawerIndex) {
        case DrawerIndex.HOME:
          setState(() {
            screenView = const MyHomePage();
          });
          break;
        case DrawerIndex.Help:
          setState(() {
            screenView = HelpScreen();
          });
          break;
        case DrawerIndex.FeedBack:
          setState(() {
            screenView = FeedbackScreen();
          });
          break;
        case DrawerIndex.Invite:
          setState(() {
            screenView = InviteFriend();
          });
          break;
        default:
          break;
      }
    }
  }
}