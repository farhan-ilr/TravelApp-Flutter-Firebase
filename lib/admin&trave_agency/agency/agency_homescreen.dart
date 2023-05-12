import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/Models-and-Functions/packag_meodel.dart';
import 'package:travel_app/Models-and-Functions/user_model.dart';
import 'package:travel_app/admin&trave_agency/agency/edit_package.dart';
import 'package:travel_app/main.dart';

class AgencyHome extends StatefulWidget {
  final UserModel thisAgency;
  const AgencyHome({super.key, required this.thisAgency});

  @override
  State<AgencyHome> createState() => _AgencyHomeState();
}

class _AgencyHomeState extends State<AgencyHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(Icons.card_travel_sharp)),
            title: const Text("packages")),
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(25),
            child: StreamBuilder<QuerySnapshot>(
                stream: ctrl.db
                    .collection("packages")
                    .where("agencyId", isEqualTo: widget.thisAgency.id)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: Text("No Packages Available"));
                  } else {
                    return ListView(
                      children: snapshot.data!.docs.map((doc) {
                        PackageModel cuPackage = PackageModel.fromMap(
                            doc.data() as Map<String, dynamic>);
                        return Column(children: [
                          Card(
                            shape: BeveledRectangleBorder(
                                borderRadius: BorderRadius.circular(7.0)),
                            child: Column(
                              children: [
                                Container(
                                  // ignore: sort_child_properties_last

                                  margin:
                                      const EdgeInsets.only(left: 5, right: 5),
                                  height: 150,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              cuPackage.imageOfPlace!),
                                          fit: BoxFit.cover)),
                                ),
                                const SizedBox(height: 5),
                                ListTile(
                                  title: Text(cuPackage.packageName!,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  subtitle: Text(cuPackage.agencyName!,
                                      style:
                                          const TextStyle(color: Colors.black)),
                                  trailing: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Column(children: [
                                          Text(
                                            " ₹ ${cuPackage.cost!}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const Text("1 Person")
                                        ]),
                                      ]),
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) {
                                        return EditPackages(
                                            thisAgency: widget.thisAgency,
                                            pmodel: cuPackage);
                                      },
                                    ));
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15)
                        ]);
                      }).toList(),
                    );
                  }
                }),
              
          ),
          
        ));
  }
}
