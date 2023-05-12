import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/screens/Messege/message_screen.dart';
import 'package:travel_app/screens/home/main_home.dart';
import 'package:travel_app/screens/home/widget/bottom_navigation_widget.dart';
import 'package:travel_app/screens/profiles/user_profile.dart';
import 'package:travel_app/screens/search/search_screen.dart';

import '../../Models-and-Functions/user_model.dart';

class HomeScreen extends StatelessWidget {
  final UserModel thisUserModel;
  final User currentUser;

  const HomeScreen({
    super.key,
    required this.thisUserModel,
    required this.currentUser,
  });

  static ValueNotifier<int> selectedBottomSwitch = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ValueListenableBuilder(
        valueListenable: selectedBottomSwitch,
        builder: (context, value, child) {
          if (value == 0) {
            return const HomeMain();
          } else if (value == 1) {
            return const SearchScreen();
          } else if (value == 2) {
            return MessageScreen(
                thisUuserModel: thisUserModel, currentUser: currentUser);
          } else {
            // var thisUserModel1 = ctrl.getUserModelById(thisUserModel.id);
            return UserProfile(
              thisUser: thisUserModel,
            );
          }
        },
      )),
      bottomNavigationBar: const BottomNavigation(),
    );
  }
}
