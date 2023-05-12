import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travel_app/Models-and-Functions/packag_meodel.dart';
import 'package:travel_app/screens/home/widget/popup_package_screen.dart';
import '../../../Models-and-Functions/user_model.dart';
import '../../../main.dart';

class AllPackages extends StatelessWidget {
  final String package;
  const AllPackages({required this.package, super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 10),
        child: StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection("packages").snapshots(),
            builder: (context, snapshot) {
              return (snapshot.connectionState == ConnectionState.waiting)
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemBuilder: (context, index) {
                        var data = snapshot.data!.docs[index].data();
                        if (package.isEmpty) {
                          return Column(
                            children: [
                              Card(
                                  shape: BeveledRectangleBorder(
                                      borderRadius: BorderRadius.circular(7.0)),
                                  child: Column(children: [
                                    Container(
                                        // ignore: sort_child_properties_last

                                        margin: const EdgeInsets.only(
                                            left: 5, right: 5),
                                        height: 150,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    data['imageOfPlace']),
                                                fit: BoxFit.cover))),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    ListTile(
                                      title: Text(data["packageName"],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      subtitle: Text(data["agencyName"],
                                          style: const TextStyle(
                                              color: Colors.black)),
                                      trailing: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Column(
                                              children: [
                                                Text(" ₹ ${data["cost"]}",
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                const Text("1 Person")
                                              ],),]),
                                      onTap: () async {
                                        UserModel user =
                                            await ctrl.getUserModelById(
                                                ctrl.auth.currentUser!.uid);
                                        showModalBottomSheet(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),),
                                            context: context,
                                            builder: (builder) {
                                              return PopUpPackage(
                                                user: user,
                                                package:
                                                    PackageModel.fromMap(data),);});},)])),
                              const SizedBox(height: 15)]);}
                        if (data['packageName']
                                .toString()
                                .toLowerCase()
                                .contains(package) ||
                            data['packageName'].toString().contains(package)) {
                          return Column(
                            children: [
                              Card(
                                  shape: BeveledRectangleBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                  ),
                                  child: Column(children: [
                                    Container(
                                      // ignore: sort_child_properties_last

                                      margin: const EdgeInsets.only(
                                          left: 5, right: 5),
                                      height: 150,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                data['imageOfPlace']),
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    ListTile(
                                      title: Text(
                                        data["packageName"],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(
                                        data["agencyName"],
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                      trailing: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  " ₹ ${data["cost"]}",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),),
                                                const Text("1 Person")])]),
                                      onTap: () {},
                                    )
                                  ])),
                              const SizedBox( height: 15)],); }
                        return Container(
                            margin: const EdgeInsets.only(top: 50),
                            child: Center(
                                child: Text(
                              "No Data Found",
                              style: TextStyle(
                                  fontFamily: GoogleFonts.dmSans().fontFamily,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500))));},
                      itemCount: snapshot.data!.docs.length); }));
  }
}
