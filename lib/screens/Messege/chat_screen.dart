import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/Models-and-Functions/chat_room_model.dart';
import 'package:travel_app/main.dart';
import '../../Models-and-Functions/messege_model.dart';
import '../../Models-and-Functions/user_model.dart';

class Chatpage extends StatefulWidget {
  final UserModel targetUser;
  final ChatRoomModel chatroom;
  final UserModel userModel;
  final User firebaseuser;
  final String? msg;
  const Chatpage(
      {super.key,
      this.msg,
      required this.chatroom,
      required this.targetUser,
      required this.userModel,
      required this.firebaseuser});

  @override
  State<Chatpage> createState() => _ChatpageState();
}

class _ChatpageState extends State<Chatpage> {
  TextEditingController sendMessagectrl = TextEditingController();

  @override
  void initState() {
    if (widget.msg.toString() == "") {
      sendMessagectrl.text = widget.msg.toString();
    } else {
      sendMessagectrl.clear();
    }

    super.initState();
  }

  // Send messege
  void sendMessage() async {
    String msg = sendMessagectrl.text.trim();

    if (msg != "") {
      MessageModel newMessage = MessageModel(
        messageId: uuid.v1(),
        sender: widget.userModel.id,
        createdon: DateTime.now(),
        text: msg,
        seen: false,
      );

      FirebaseFirestore.instance
          .collection("chatroom")
          .doc(widget.chatroom.chatRoomid)
          .collection("messages")
          .doc(newMessage.messageId)
          .set(newMessage.toMap());
    }

    widget.chatroom.lastMessage = msg;
    FirebaseFirestore.instance
        .collection("chatroom")
        .doc(widget.chatroom.chatRoomid)
        .set(widget.chatroom.toMap());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: widget.targetUser.profilePic != "noImage"
                  ? NetworkImage(widget.targetUser.profilePic!)
                  : const NetworkImage(
                      "https://www.iconpacks.net/icons/2/free-user-icon-3296-thumb.png"),
            ),
            const SizedBox(
              width: 20,
            ),
            Text(widget.targetUser.username.toString())
          ],
        ),
      ),
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("chatroom")
                    .doc(widget.chatroom.chatRoomid)
                    .collection("messages")
                    .orderBy("createdon", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      QuerySnapshot dataSnapshot =
                          snapshot.data as QuerySnapshot;

                      return ListView.builder(
                        reverse: true,
                        itemCount: dataSnapshot.docs.length,
                        itemBuilder: (context, index) {
                          MessageModel currentMessageModel =
                              MessageModel.fromMap(dataSnapshot.docs[index]
                                  .data() as Map<String, dynamic>);
                          return Row(
                            mainAxisAlignment: (widget.userModel.id ==
                                    currentMessageModel.sender)
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  vertical: 5,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: (widget.userModel.id ==
                                          currentMessageModel.sender)
                                      ? Colors.blueAccent
                                      : Theme.of(context).colorScheme.secondary,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  currentMessageModel.text.toString(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text("pease Check Your Internet Connection"),
                      );
                    } else {
                      return const Center(
                        child: Text("Say Hi To Travellar"),
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
          Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 5,
            ),
            child: Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: sendMessagectrl,
                    maxLines: null,
                    decoration: const InputDecoration(
                        hintText: "Enter Messege : ", border: InputBorder.none),
                  ),
                ),
                IconButton(
                    onPressed: () async {
                      sendMessage();
                      sendMessagectrl.clear();
                    },
                    icon: const Icon(Icons.send))
              ],
            ),
          )
        ],
      )),
    );
  }
}
