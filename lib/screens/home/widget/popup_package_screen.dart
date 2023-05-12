import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travel_app/Models-and-Functions/booking_model.dart';
import 'package:travel_app/Models-and-Functions/packag_meodel.dart';
import 'package:travel_app/Models-and-Functions/user_model.dart';
import 'package:travel_app/main.dart';
import 'package:travel_app/screens/Messege/chat_screen.dart';

import '../../../Models-and-Functions/chat_room_model.dart';

InputDecoration decorationTextBox({required String label}) {
  return InputDecoration(hintText: label);
}

TextStyle _styleText(FontWeight fd) {
  return TextStyle(
      fontSize: 18, fontFamily: GoogleFonts.monda().fontFamily, fontWeight: fd);
}

class PopUpPackage extends StatefulWidget {
  final PackageModel package;
  final UserModel user;
  const PopUpPackage({required this.package, required this.user, super.key});
  @override
  State<PopUpPackage> createState() => _PopUpPackageState();
}

class _PopUpPackageState extends State<PopUpPackage> {
  bool bookingSuccessfull = false;
  TextEditingController personController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    personController.clear();
    dateController.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 7, right: 7, top: 5, bottom: 3),
        child: ListView(children: [
          Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                      image: NetworkImage(widget.package.imageOfPlace!),
                      fit: BoxFit.cover))),
          Container(
              padding: const EdgeInsets.only(left: 10, top: 3),
              child: Text(widget.package.packageName!,
                  style: _styleText(FontWeight.bold))),
          Container(
              padding: const EdgeInsets.only(left: 10, top: 3),
              child: Text("Agency : ${widget.package.agencyName!}",
                  style: _styleText(FontWeight.w400))),
          Container(
              padding: const EdgeInsets.only(left: 10, top: 8),
              child: Text(widget.package.description!,
                  style: _styleText(FontWeight.w200))),
          Container(
              padding: const EdgeInsets.only(left: 10, top: 3),
              child: Text("Duration : ${widget.package.days}",
                  style: _styleText(FontWeight.w200))),
          Container(
              padding: const EdgeInsets.only(left: 10, top: 3),
              child: Text("Cost : ${widget.package.cost}  /1 Person",
                  style: _styleText(FontWeight.w200))),
          const SizedBox(height: 10),
          CupertinoButton(
              color: Colors.black,
              child: const Text("Contact Us",
                  style: TextStyle(color: Colors.white)),
              onPressed: () async {
                UserModel targetUser =
                    await ctrl.getUserModelById(widget.package.agencyId);
                UserModel userModel =
                    await ctrl.getUserModelById(ctrl.auth.currentUser!.uid);
                ChatRoomModel chatRoomModel =
                    await ctrl.getChartRoomMoel(targetUser, userModel);
                // ignore: use_build_context_synchronously
                Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                  return Chatpage(
                    msg:
                        "Hi Iam ${userModel.username} \n I see Your Travel package Named as ${widget.package.packageName} \n and i like to get More details about the package !",
                    chatroom: chatRoomModel,
                    targetUser: targetUser,
                    userModel: userModel,
                    firebaseuser: ctrl.auth.currentUser!,
                  );
                }));
              }),
          const SizedBox(height: 10),
          CupertinoButton(
              color: Colors.black,
              child:
                  const Text("Book Now", style: TextStyle(color: Colors.white)),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (ctx) {
                      return AlertDialog(
                        content: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                  controller: personController,
                                  decoration: decorationTextBox(
                                      label: "How much persons")),
                              const SizedBox(height: 10),
                              TextFormField(
                                  controller: dateController,
                                  decoration: decorationTextBox(
                                      label:
                                          "Click Date Button to Set Starting Date")),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                  onPressed: () async {
                                    DateTime? date = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.utc(2050));

                                    if (date != null) {
                                      String day = date.day.toString();
                                      String month = date.month.toString();
                                      String year = date.year.toString();
                                      setState(() {
                                        dateController.text =
                                            "$day - $month - $year";
                                      });
                                    }
                                  },
                                  child: const Text("Date")),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                        onPressed: () async {
                                          String id = uuid.v1();
                                          BookingModel book = BookingModel(
                                              bookId: id,
                                              agencyId: widget.package.agencyId,
                                              packageId:
                                                  widget.package.packageId,
                                              userId: widget.user.id,
                                              agencyName:
                                                  widget.package.agencyName,
                                              packageName:
                                                  widget.package.packageName,
                                              userName: widget.user.username,
                                              personCount:
                                                  personController.text.trim(),
                                              bookingdate: dateController.text,
                                              bookedDate:
                                                  DateTime.now().toString());

                                          try {
                                            await ctrl.db
                                                .collection("Bookings")
                                                .doc(id)
                                                .set(book.toMap());

                                            setState(() {
                                              bookingSuccessfull = true;
                                            });
                                          } catch (e) {
                                            final sn = SnackBar(
                                              content: Text("$e"),
                                            );
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(sn);
                                          }

                                          bookingSuccessfull == true
                                              ? showDialog(
                                                  context: ctx,
                                                  builder: (ctx) {
                                                    return AlertDialog(
                                                      actions: [
                                                        ElevatedButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  ctx);
                                                              Navigator.pop(
                                                                  context);
                                                              bookingSuccessfull =
                                                                  false;
                                                            },
                                                            child: const Text(
                                                                "Got it!"))
                                                      ],
                                                      content: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          const Icon(Icons
                                                              .check_rounded),
                                                          Text(
                                                              "Your Booking is successfull \n The ${widget.package.agencyName} will contact You")
                                                        ],),);})
                                              : const Text("");
                                          // ignore: use_build_context_synchronously
                                        },
                                        child: const Text("Book")),
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);},
                                        child: const Text("Cancel")),])
                            ]),);}); }),
          const SizedBox(height: 10),]));}
}
