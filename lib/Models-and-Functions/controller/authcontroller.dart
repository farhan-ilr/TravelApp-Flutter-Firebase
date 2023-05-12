import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel_app/Models-and-Functions/chat_room_model.dart';
import 'package:travel_app/admin&trave_agency/agency/agency_home.dart';
import 'package:travel_app/main.dart';
import 'package:travel_app/screens/home/home_screen.dart';
import 'package:travel_app/Models-and-Functions/user_model.dart';

class AuthController extends GetxController {
  // Step 1 Create Instance
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController loginEmail = TextEditingController();
  TextEditingController loginPassword = TextEditingController();
  TextEditingController agencyName = TextEditingController();
  TextEditingController agencyEmail = TextEditingController();
  TextEditingController agencyPass = TextEditingController();
  var loading = false.obs;

  // Step 2 create functions
// sign Up Method
  signUp(BuildContext context) async {
    try {
      loading.value = true;
      await auth.createUserWithEmailAndPassword(
          email: email.text, password: password.text);
      await adduser();
      await verifyEmail();
      UserModel thisUserModel = await getUserModelById(auth.currentUser!.uid);

      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => HomeScreen(
                thisUserModel: thisUserModel,
                currentUser: auth.currentUser!,
              )));
      loading.value = false;
    } catch (e) {
      final sn = SnackBar(
        content: Text("$e"),
      );
      ScaffoldMessenger.of(context).showSnackBar(sn);
      loading.value = false;
    }
  }

  // adding a new Agency to user collection
  addAgency(BuildContext context) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: agencyEmail.text, password: agencyPass.text);
      UserModel agency = UserModel(
        id: auth.currentUser!.uid,
        username: agencyName.text,
        email: agencyEmail.text,
        type: "agency",
        profilePic: "noImage",
        bio: "noBio",
      );
      await db
          .collection("Users")
          .doc(auth.currentUser!.uid)
          .set(agency.toMap());

      // ignore: use_build_context_synchronously
      await signOut(context);

      const sn = SnackBar(
        content: Text("agency Created Successfully"),
      );
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(sn);
    } catch (e) {
      final sn = SnackBar(
        content: Text("$e"),
      );
      ScaffoldMessenger.of(context).showSnackBar(sn);
    }
  }

  // add user to dataBase
  adduser() async {
    UserModel user = UserModel(
      id: auth.currentUser?.uid,
      username: username.text,
      email: auth.currentUser?.email,
      type: "user",
      profilePic: "noImage",
      bio: "noBio",
    );
    await db.collection("Users").doc(auth.currentUser?.uid).set(user.toMap());
  }

// signOut Method
  signOut(BuildContext context) async {
    try {
      await auth.signOut();
    } catch (e) {
      final sn = SnackBar(
        content: Text("$e"),
      );
      ScaffoldMessenger.of(context).showSnackBar(sn);
    }
  }

// sign In Method
  signIn(BuildContext context) async {
    try {
      await auth.signInWithEmailAndPassword(
          email: loginEmail.text, password: loginPassword.text);
      final UserModel thisUserModel =
          await getUserModelById(auth.currentUser!.uid);
      if (thisUserModel.type == "user") {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (ctx) => HomeScreen(
              thisUserModel: thisUserModel,
              currentUser: auth.currentUser!,
            ),
          ),
        );
      } else {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (ctx) => Agencymainpage(
              thisAgency: thisUserModel,
            ),
          ),
        );
      }
    } catch (e) {
      final sn = SnackBar(
        content: Text("$e"),
      );
      ScaffoldMessenger.of(context).showSnackBar(sn);
    }
  }

// verify email send
  verifyEmail() async {
    await auth.currentUser?.sendEmailVerification();
  }

// get single User By Id
  Future<UserModel> getUserModelById(String? uid) async {
    final snapshot =
        await FirebaseFirestore.instance.collection("Users").doc(uid).get();

    UserModel user = UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
    return user;
  }

// get ChartRoom Model
  Future<ChatRoomModel> getChartRoomMoel(
      UserModel targetUser, UserModel thisuser) async {
    // ignore: prefer_typing_uninitialized_variables
    var chatroomModel;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatroom")
        .where("participants.${thisuser.id}", isEqualTo: true)
        .where("participants.${targetUser.id}", isEqualTo: true)
        .get();
    if (snapshot.docs.isNotEmpty) {
      var docData = snapshot.docs[0].data();
      ChatRoomModel existingChatRoomModel =
          ChatRoomModel.fromMap(docData as Map<String, dynamic>);
      chatroomModel = existingChatRoomModel;
    } else {
      ChatRoomModel newChatRoom = ChatRoomModel(
          chatRoomid: uuid.v1(),
          lastMessage: "",
          participants: {
            thisuser.id.toString(): true,
            targetUser.id.toString(): true
          });

      await FirebaseFirestore.instance
          .collection("chatroom")
          .doc(newChatRoom.chatRoomid)
          .set(newChatRoom.toMap());
      log("New Chat Room Created");

      chatroomModel = newChatRoom;
    }
    return chatroomModel;
  }
}
