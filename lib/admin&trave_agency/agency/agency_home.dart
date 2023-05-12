import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:travel_app/admin&trave_agency/agency/agency_homescreen.dart';
import 'package:travel_app/admin&trave_agency/agency/add_packages.dart';
import 'package:travel_app/admin&trave_agency/agency/bookings_details.dart';
import 'package:travel_app/main.dart';

import '../../Models-and-Functions/user_model.dart';
import '../../screens/Messege/message_screen.dart';
import '../../screens/profiles/user_profile.dart';

class Agencymainpage extends StatelessWidget {
  final UserModel thisAgency;
  const Agencymainpage({super.key, required this.thisAgency});

  static ValueNotifier<int> selectedAgencyHomeNavigation = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const AgencyBottomNavigation(),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: selectedAgencyHomeNavigation,
          builder: (context, value, child) {
            if (value == 0) {
              return AgencyHome(
                thisAgency: thisAgency,
              );
            } else if (value == 1) {
              return AddPackages(
                thisAgency: thisAgency,
                firebaseAgency: ctrl.auth.currentUser!,
              );
            } else if (value == 2) {
              return const BookingDetails();
            } else if (value == 3) {
              return MessageScreen(
                  thisUuserModel: thisAgency,
                  currentUser: ctrl.auth.currentUser!);
            } else {
              return UserProfile(
                thisUser: thisAgency,
              );
            }
          },
        ),
      ),
    );
  }
}

class AgencyBottomNavigation extends StatelessWidget {
  const AgencyBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Agencymainpage.selectedAgencyHomeNavigation,
      builder: (ctx, updateIndex, _) {
        return SalomonBottomBar(
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          currentIndex: Agencymainpage.selectedAgencyHomeNavigation.value,
          onTap: (index) =>
              Agencymainpage.selectedAgencyHomeNavigation.value = index,
          items: [
            SalomonBottomBarItem(
              icon: const Icon(Icons.home),
              title: const Text('Home'),
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.card_travel),
              title: const Text('Add Pkg'),
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.book_online),
              title: const Text('Bookings'),
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.messenger),
              title: const Text('Messege'),
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.person),
              title: const Text('Profile'),
            ),
          ],
        );
      },
    );
  }
}
