import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:travel_app/Models-and-Functions/controller/authcontroller.dart';
import 'package:travel_app/Models-and-Functions/chat_room_model.dart';
import 'package:travel_app/Models-and-Functions/user_model.dart';
import 'package:travel_app/main.dart';

import 'chat_screen.dart';

class MessageScreen extends StatefulWidget {
  final UserModel thisUuserModel;
  final User currentUser;
  const MessageScreen(
      {super.key, required this.thisUuserModel, required this.currentUser});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.message_sharp),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("chatroom")
                  .where("participants.${widget.thisUuserModel.id}",
                      isEqualTo: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.data!.docs.isNotEmpty) {
                    return ListView(
                      children: snapshot.data!.docs.map((doc) {
                        ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
                            doc.data() as Map<String, dynamic>);
                        Map<String, dynamic> participantsMap =
                            chatRoomModel.participants!;
                        List<String> participantsKey =
                            participantsMap.keys.toList();
                        participantsKey.remove(widget.thisUuserModel.id);

                        return FutureBuilder<UserModel>(
                          future: AuthController()
                              .getUserModelById(participantsKey[0]),
                          builder: (context, userData) {
                            if (userData.connectionState ==
                                ConnectionState.done) {
                              if (userData.data != null) {
                                UserModel targetUser =
                                    userData.data as UserModel;
                                return Card(
                                  child: ListTile(
                                    leading: CircleAvatar(
                                        backgroundImage: targetUser
                                                    .profilePic !=
                                                "noImage"
                                            ? NetworkImage(
                                                targetUser.profilePic!)
                                            : const NetworkImage(
                                                "https://www.iconpacks.net/icons/2/free-user-icon-3296-thumb.png")),
                                    title: targetUser.type == "user"
                                        ? Text(
                                            targetUser.username.toString(),
                                          )
                                        : Row(
                                            children: [
                                              Text(
                                                targetUser.username.toString(),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              const Icon(
                                                Icons.verified,
                                                color: Colors.blue,
                                              )
                                            ],
                                          ),
                                    subtitle: Text(
                                      chatRoomModel.lastMessage.toString(),
                                    ),
                                    onTap: () async {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (ctx) => Chatpage(
                                            chatroom: chatRoomModel,
                                            targetUser: targetUser,
                                            userModel: widget.thisUuserModel,
                                            firebaseuser:
                                                ctrl.auth.currentUser!,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            } else {
                              return const Center();
                            }
                          },
                        );
                      }).toList(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  } else {
                    return const Center(
                      child: Text("No Chat Available"),
                    );
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
