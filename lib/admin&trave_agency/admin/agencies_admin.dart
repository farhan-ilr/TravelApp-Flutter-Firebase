import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/Models-and-Functions/user_model.dart';
import 'package:travel_app/main.dart';

class AgencyAdmin extends StatelessWidget {
  const AgencyAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Column(
            children: [
              TextField(
                controller: ctrl.agencyName,
                decoration: const InputDecoration(
                  hintText: "Agency name",
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: ctrl.agencyEmail,
                decoration: const InputDecoration(
                  hintText: "E-mail ",
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: ctrl.agencyPass,
                decoration: const InputDecoration(
                  hintText: "Password",
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              CupertinoButton(
                color: Theme.of(context).colorScheme.secondary,
                onPressed: () async {
                  await ctrl.addAgency(context);
                  ctrl.agencyEmail.clear();
                  ctrl.agencyName.clear();
                  ctrl.agencyPass.clear();
                },
                child: const Text("Add Agency"),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("Users")
                      .where("type", isEqualTo: "agency")
                      .snapshots(),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }
                    return ListView(
                      children: snapshot.data!.docs.map((DocumentSnapshot doc) {
                        UserModel user = UserModel.fromMap(
                            doc.data() as Map<String, dynamic>);
                        return Card(
                          child: ListTile(
                            title: Text(user.username!),
                            leading: const CircleAvatar(
                              backgroundImage: NetworkImage(
                                  "https://www.alhind.com/images/logo/logo.png"),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
