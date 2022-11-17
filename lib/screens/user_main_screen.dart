import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_and_dye/main.dart';
import 'package:do_and_dye/screens/user_booking_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/route_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserHome extends StatelessWidget {
  final String uuid;
  final String name;
  UserHome({
    required this.uuid,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Do and Dye",
        ),
        actions: [
          IconButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();

                prefs.clear();
                Get.offAll(() => LoginPage());
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: StreamBuilder<Object>(
            stream: FirebaseFirestore.instance.collection("users").snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                return Column(
                  //Text(((snapshot.data as QuerySnapshot)
                  // .docs[index]
                  // .data() as Map)["name"]),
                  children: [
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: (snapshot.data as QuerySnapshot).docs.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: (() => Get.to(() => UserBooking(
                                  snap: (snapshot.data as dynamic)
                                      .docs[index]
                                      .data(),
                                  name: name,
                                ))),
                            child: Card(
                              child: ListTile(
                                title: Text(
                                    "Salon name: ${(snapshot.data as dynamic).docs[index].data()["shopname"]}"),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "Address: ${(snapshot.data as dynamic).docs[index].data()["shopaddress"]}"),
                                    Text(
                                        "Owner: ${(snapshot.data as dynamic).docs[index].data()["name"]}"),
                                  ],
                                ),
                                trailing: Text(
                                    "No.of Seat: ${(snapshot.data as dynamic).docs[index].data()["noofcounter"]}"),
                              ),
                            ),
                          );
                        })
                  ],
                );
              }
            }),
      )),
    );
  }
}
