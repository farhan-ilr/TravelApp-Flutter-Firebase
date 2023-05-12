import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/admin&trave_agency/admin/agencies_admin.dart';
import 'package:travel_app/admin&trave_agency/admin/agency_places.dart';
import 'package:travel_app/admin&trave_agency/admin/user_admin.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CupertinoButton(
                      color: Theme.of(context).colorScheme.secondary,
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => const UserAdmin()));
                      },
                      child: const Text("Users      "),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CupertinoButton(
                      color: Theme.of(context).colorScheme.secondary,
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => const AgencyAdmin()));
                      },
                      child: const Text("Agencies"),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CupertinoButton(
                      color: Theme.of(context).colorScheme.secondary,
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => const PlaceCreation()));
                      },
                      child: const Text("Places    "),
                    ),
                  ]),
            )),
      ),
    );
  }
}
