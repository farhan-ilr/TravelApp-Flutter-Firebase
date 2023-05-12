import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travel_app/Models-and-Functions/packag_meodel.dart';
import 'package:travel_app/Models-and-Functions/user_model.dart';
import 'package:travel_app/data/datas.dart';
import 'package:travel_app/screens/home/widget/popup_package_screen.dart';
import '../../main.dart';

_textFormat(
  double size,
) {
  return TextStyle(
    fontSize: size,
    fontWeight: FontWeight.w600,
    fontFamily: GoogleFonts.itim().fontFamily,
  );
}

class HomeMain extends StatelessWidget {
  const HomeMain({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 43, left: 25, right: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Explore The World ', style: _textFormat(26)),
              const SizedBox(
                height: 3,
              ),
              Text('With TravelHub', style: _textFormat(26)),
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          Row(
            children: [Text('Popular Places...', style: _textFormat(17))],
          ),
          const SizedBox(
            height: 8,
          ),
          StreamBuilder(
            stream: ctrl.db.collection("places").snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: Text("No Data"),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else {
                  return SizedBox(
                    height: 220,
                    child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          var data = snapshot.data!.docs[index].data();
                          return PhotoCard(
                            url: data["image"],
                            des: data["description"],
                            index: index,
                            cardHeight: 220,
                            cardWidth: 250,
                            placeName: data["placeName"],
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox(
                              width: 10,
                            ),
                        itemCount: snapshot.data!.docs.length),
                  );
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          const SizedBox(
            height: 10,
          ),
          Text('Popular Packages...', style: _textFormat(17)),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: ctrl.db.collection("packages").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (!snapshot.hasData) {
                  return const Center(
                    child: Text("No Packages Available"),
                  );
                } else {
                  return ListView(
                      children: snapshot.data!.docs.map((doc) {
                    PackageModel model = PackageModel.fromMap(
                        doc.data() as Map<String, dynamic>);
                    return Package(pModel: model);
                  }).toList());
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class Package extends StatelessWidget {
  Package({this.he = 250, super.key, required this.pModel});
  final PackageModel pModel;
  double he;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: he,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color.fromARGB(255, 255, 255, 255),
        ),
        child: Column(
          children: [
            Container(
              height: 160,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(pModel.imageOfPlace.toString()),
                    fit: BoxFit.cover),
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10)),
                color: const Color.fromARGB(255, 168, 54, 54).withOpacity(0.4),
              ),
            ),
            ListTile(
              onTap: () async {
                UserModel user =
                    await ctrl.getUserModelById(ctrl.auth.currentUser!.uid);
                showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    context: context,
                    builder: (builder) {
                      return PopUpPackage(
                        user: user,
                        package: pModel,
                      );
                    });
              },
              title: Text(
                pModel.packageName.toString(),
                style: _textFormat2,
              ),
              subtitle: Text(pModel.agencyName.toString()),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    pModel.cost.toString(),
                    style: _textFormat2,
                  ),
                  const Text("1 Person")
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

final _textFormat2 = TextStyle(
  color: const Color.fromARGB(255, 0, 0, 0),
  fontFamily: GoogleFonts.ptSerif().fontFamily,
  fontWeight: FontWeight.w600,
  fontSize: 18,
);

// ignore: must_be_immutable
class PhotoCard extends StatelessWidget {
  final int index;
  final double cardHeight, cardWidth;
  String placeName;
  String? url;
  String? des;
  PhotoCard(
      {super.key,
      required this.index,
      required this.cardHeight,
      required this.cardWidth,
      required this.placeName,
      this.des,
      this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() async {
        showModalBottomSheet(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            context: context,
            builder: (builder) {
              return Container(
                  padding: const EdgeInsets.all(10),
                  child: ListView(children: [
                    Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                                image: NetworkImage(url.toString()),
                                fit: BoxFit.cover)),
                        height: cardHeight,
                        width: cardWidth,
                        child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(placeName,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: GoogleFonts.roboto().fontFamily,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)))),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      des.toString(),
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: GoogleFonts.dmSans().fontFamily,
                      ),
                    )
                  ]));
            });
      }),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: NetworkImage(url.toString()),
            fit: BoxFit.cover,
          ),
        ),
        height: cardHeight,
        width: cardWidth,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            placeName,
            style: TextStyle(
                color: Colors.black,
                fontFamily: GoogleFonts.roboto().fontFamily,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}


