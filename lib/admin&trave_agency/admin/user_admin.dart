import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/Models-and-Functions/user_model.dart';

class UserAdmin extends StatefulWidget {
  const UserAdmin({super.key});

  @override
  State<UserAdmin> createState() => _UserAdminState();
}

class _UserAdminState extends State<UserAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SafeArea(
            child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("Users")
                .where("type", isEqualTo: "user")
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
                  UserModel user =
                      UserModel.fromMap(doc.data() as Map<String, dynamic>);
                  return Card(
                    child: ListTile(
                      title: Text(user.username!),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        )));
  }
}
