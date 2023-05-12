import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travel_app/Models-and-Functions/user_model.dart';
import 'package:travel_app/main.dart';
import 'package:travel_app/screens/Messege/chat_screen.dart';
import 'package:travel_app/screens/login-register/login_screen.dart';
import 'package:travel_app/screens/profiles/edit_profile.dart';

import '../../Models-and-Functions/chat_room_model.dart';

class UserProfile extends StatefulWidget {
  final UserModel thisUser;

  const UserProfile({super.key, required this.thisUser});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TravelHub"),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.only(top: 50),
          child: ListView(
            children: [
              CupertinoButton(
                child: CircleAvatar(
                  radius: 65,
                  backgroundImage: widget.thisUser.profilePic.toString() ==
                          "noImage"
                      ? const NetworkImage(
                          "https://cdn-icons-png.flaticon.com/512/149/149071.png")
                      : NetworkImage(widget.thisUser.profilePic.toString()),
                  child: widget.thisUser.profilePic == null
                      ? const Icon(size: 50, Icons.person)
                      : null,
                ),
                onPressed: () {},
              ),
              const SizedBox(height: 30),
              Center(
                child: widget.thisUser.type == "user"
                    ? Text(
                        widget.thisUser.username!,
                        style: _textFormat(FontWeight.bold, 18),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.thisUser.username!,
                            style: _textFormat(FontWeight.w300, 18),
                          ),
                          const SizedBox(width: 5),
                          const Icon(Icons.verified, color: Colors.blue)
                        ],
                      ),
              ),
              const SizedBox(
                height: 5,
              ),
              Center(
                child: Text(
                  widget.thisUser.email!,
                  style: _textFormat(FontWeight.w300, 15),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  widget.thisUser.bio.toString() == "noBio"
                      ? ""
                      : widget.thisUser.bio.toString(),
                  style: TextStyle(
                    fontSize: 15.5,
                    fontFamily: GoogleFonts.roboto().fontFamily,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              widget.thisUser.id == ctrl.auth.currentUser!.uid
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                                    builder: (ctx) => EditProfile(
                                          thisUser: widget.thisUser,
                                        )));
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(100, 35),
                            maximumSize: const Size(100, 35),
                          ),
                          child: const Text("Edit"),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await ctrl.signOut(context);
                            // ignore: use_build_context_synchronously
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (ctx) => const LoginPage()));
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(100, 35),
                            maximumSize: const Size(100, 35),
                          ),
                          child: const Text("LogOut"),
                        )
                      ],
                    )
                  : const Text(""),
              const SizedBox(
                width: 15,
              ),
              widget.thisUser.id != ctrl.auth.currentUser!.uid
                  ? ElevatedButton(
                      onPressed: () async {
                        UserModel currentUser = await ctrl
                            .getUserModelById(ctrl.auth.currentUser!.uid);
                        ChatRoomModel chatRoomModel = await ctrl
                            .getChartRoomMoel(widget.thisUser, currentUser);
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: ((context) => Chatpage(
                                  chatroom: chatRoomModel,
                                  targetUser: widget.thisUser,
                                  userModel: currentUser,
                                  firebaseuser: ctrl.auth.currentUser!,
                                )),
                          ),
                        );
                      },
                      child: const Text("Message"),
                    )
                  : const Text(""),
              widget.thisUser.id == ctrl.auth.currentUser!.uid
                  ? StreamBuilder(
                      stream: ctrl.db
                          .collection("Bookings")
                          .where("userId", isEqualTo: widget.thisUser.id)
                          .snapshots(),
                      builder: (context, snapshot) {
                        return StreamBuilder(builder: ((context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.active) {
                            if (!snapshot.hasData) {
                              return const Center(
                                child: Text("No Booked Package Available"),
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text(snapshot.error.toString()),
                              );
                            } else {
                              return ListView(
                                
                              );
                            }
                          } else {
                            return const Center(
                              child: Text(""),
                            );
                          }
                        }));
                      },
                    )
                  : Text(""),
            ],
          ),
        ),
      ),
    );
  }
}

_textFormat(FontWeight fontWeight, double size) {
  return TextStyle(
    fontFamily: GoogleFonts.notoSans().fontFamily,
    fontWeight: fontWeight,
    fontSize: size,
  );
}
