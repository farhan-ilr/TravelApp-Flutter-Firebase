import 'package:flutter/material.dart';
import 'package:travel_app/screens/home/main_home.dart';
import '../../../main.dart';
class AllPlaces extends StatelessWidget {
 const AllPlaces({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: StreamBuilder(
        stream: ctrl.db.collection("places").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (!snapshot.hasData) {
              return Text("No data");
            }
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              return ListView.separated(
                itemBuilder: (ctx, index) {
                  var data = snapshot.data!.docs[index].data();
                  return PhotoCard(
                      url: data["image"],
                      placeName: data["placeName"],
                      index: index,
                      cardHeight: 220,
                      cardWidth: 350);},
                separatorBuilder: (ctx, index) {
                  return const SizedBox(
                    height: 10,);},
                itemCount: snapshot.data!.docs.length,);
            }
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
