import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:travel_app/Models-and-Functions/booking_model.dart';
import 'package:travel_app/Models-and-Functions/packag_meodel.dart';
import 'package:travel_app/admin&trave_agency/agency/booked_details.dart';
import 'package:travel_app/main.dart';

import '../../Models-and-Functions/user_model.dart';

class BookingDetails extends StatelessWidget {
  const BookingDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: AppBar(
            leading: const Icon(Icons.book_online),
            title: const Text("Bookings"),
            // leading: Icon(Icons.book_online),
          ),
        ),
        body: SafeArea(
            child: Container(
                padding: const EdgeInsets.all(10.0),
                child: StreamBuilder(
                    stream: ctrl.db
                        .collection("Bookings")
                        .where("agencyId",
                            isEqualTo: ctrl.auth.currentUser!.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: Text("No Bookings"),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text(snapshot.error.toString()),
                          );
                        } else {
                          return ListView(
                            children: snapshot.data!.docs.map((doc) {
                              BookingModel booking =
                                  BookingModel.fromMap(doc.data());
                              return Card(
                                child: ListTile(
                                  onTap: () async {
                                    UserModel user = await ctrl
                                        .getUserModelById(booking.userId!);
                                    final snapshot = await FirebaseFirestore
                                        .instance
                                        .collection("packages")
                                        .doc(booking.packageId)
                                        .get();

                                    PackageModel package = PackageModel.fromMap(
                                        snapshot.data()
                                            as Map<String, dynamic>);
                                    // ignore: use_build_context_synchronously
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(builder: (ctx) {
                                      return BookedPage(
                                          book: booking,
                                          package: package,
                                          user: user);
                                    }));
                                  },
                                  title: Text(booking.userName!),
                                  subtitle: Text(booking.packageName!),
                                  trailing: Text(
                                    booking.bookingdate.toString(),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        }
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }))));
  }
}
