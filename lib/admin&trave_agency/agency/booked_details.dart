import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travel_app/Models-and-Functions/booking_model.dart';
import 'package:travel_app/Models-and-Functions/chat_room_model.dart';
import 'package:travel_app/Models-and-Functions/packag_meodel.dart';
import 'package:travel_app/main.dart';
import 'package:travel_app/screens/Messege/chat_screen.dart';
import 'package:travel_app/screens/home/main_home.dart';

import '../../Models-and-Functions/user_model.dart';

TextStyle styling() {
  return TextStyle(fontSize: 18, fontFamily: GoogleFonts.dmSans().fontFamily);
}

class BookedPage extends StatelessWidget {
  final PackageModel package;
  final UserModel user;
  final BookingModel book;
  const BookedPage(
      {super.key,
      required this.package,
      required this.user,
      required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Details")),
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name : ${user.username}", style: styling()),
            const SizedBox(height: 10),
            Text("Package Booked :", style: styling()),
            Package(
              pModel: package,
            ),
            const SizedBox(height: 10),
            Text(
              "No of Persons :  ${book.personCount}",
              style: styling(),
            ),
            const SizedBox(height: 10),
            Text(
              "Booking Date : ${book.bookingdate}",
              style: styling(),
            ),
            const SizedBox(height: 15),
            Center(
              child: CupertinoButton(
                  color: Theme.of(context).colorScheme.secondary,
                  child: Text("Contact With ${user.username}"),
                  onPressed: () async {
                    UserModel thisUser =
                        await ctrl.getUserModelById(ctrl.auth.currentUser!.uid);
                    ChatRoomModel chatRoomModel =
                        await ctrl.getChartRoomMoel(user, thisUser);
                    // ignore: use_build_context_synchronously
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (ctx) {
                      return Chatpage(
                        chatroom: chatRoomModel,
                        targetUser: user,
                        userModel: thisUser,
                        firebaseuser: ctrl.auth.currentUser!,
                      );
                    }));
                  }),
            )
          ],
        ),
      )),
    );
  }
}
