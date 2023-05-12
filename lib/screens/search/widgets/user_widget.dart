import 'package:flutter/material.dart';
import 'package:travel_app/Models-and-Functions/user_model.dart';
import 'package:travel_app/main.dart';
import 'package:travel_app/screens/profiles/user_profile.dart';
class AllUsers extends StatelessWidget {
  final String user;
  const AllUsers({required this.user, super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 5),
        child: StreamBuilder(
            stream: ctrl.db
                .collection("Users")
                .where("id", isNotEqualTo: ctrl.auth.currentUser!.uid)
                .snapshots(),
            builder: ((context, snapshot) {
              return (snapshot.connectionState == ConnectionState.active)
                  ? ListView.builder(
                      itemBuilder: (context, index) {
                        var data = snapshot.data!.docs[index].data();
                        if (user.isEmpty) {
                          return ListTile(
                              title: data['type'] == "user"
                                  ? Text(data['username'])
                                  : Row(children: [
                                      Text(data['username']),
                                      const SizedBox(width: 5),
                                      const Icon(Icons.verified,
                                          color: Colors.blue, size: 20)]),
                              subtitle: Text(data['email']),
                              leading: CircleAvatar(
                                  backgroundImage: data['profilePic'] ==
                                          "noImage"
                                      ? const NetworkImage(
                                          "https://cdn-icons-png.flaticon.com/512/149/149071.png")
                                      : NetworkImage(data['profilePic'])),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (ctx) => UserProfile(
                                        thisUser: UserModel.fromMap(data)))); });}
                        if (data['username']
                                .toString()
                                .toLowerCase()
                                .contains(user) ||
                            data['username'].toString().contains(user)) {
                          return ListTile(
                              title: data['type'] == "user"
                                  ? Text(data['username'])
                                  : Row(children: [
                                      Text(data['username']),
                                      const SizedBox(width: 5),
                                      const Icon(Icons.verified,
                                          color: Colors.blue, size: 20) ]),
                              subtitle: Text(data['email']),
                              leading: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(data['profilePic']))); } else {
                          return Container();
                        }},
                      itemCount: snapshot.data!.docs.length,)
                  : const Center(
                      child: CircularProgressIndicator(),);})));
  }
}
