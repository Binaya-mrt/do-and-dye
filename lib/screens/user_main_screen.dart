import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_and_dye/main.dart';
import 'package:do_and_dye/screens/user_booking_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserHome extends StatelessWidget {
  final String uuid;
  final String name;
  const UserHome({
    required this.uuid,
    required this.name,
  });
  final Color color = const Color(0xffaf3557);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: const Image(
          height: 150,
          image: AssetImage("assets/images/dondye.png"),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xffaf3557),
              ),
              accountName: Text(name),
              accountEmail: Text(uuid),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  name[0],
                  style: const TextStyle(fontSize: 40.0),
                ),
              ),
            ),
            ListTile(
              title: const Text("Change Password"),
              onTap: () async {},
            ),
            ListTile(
              title: const Text("Change Location"),
              onTap: () async {},
            ),
            ListTile(
              title: const Text("Logout"),
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();

                prefs.clear();
                Get.offAll(() => const LoginPage());
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: StreamBuilder<Object>(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Hair Salons",
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: color),
                            ),
                          ),
                          ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount:
                                  (snapshot.data as QuerySnapshot).docs.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    color: index % 2 == 0
                                        ? const Color(0xffFFF0EC)
                                        : const Color(0xffEBF5FF),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0,
                                                        vertical: 5),
                                                child: Text(
                                                  (snapshot.data as dynamic)
                                                      .docs[index]
                                                      .data()["shopname"],
                                                  style: TextStyle(
                                                      fontSize: 22,
                                                      color: color,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              detailsText(
                                                  (snapshot.data as dynamic)
                                                      .docs[index]
                                                      .data()["name"]),
                                              detailsText(
                                                  (snapshot.data as dynamic)
                                                      .docs[index]
                                                      .data()["shopaddress"]),
                                            ],
                                          ),
                                        ),
                                        // Container(
                                        //   color: Colors.white,
                                        //   height: 200,
                                        //   child: Image.asset(
                                        //     // (snapshot.data as dynamic)
                                        //     //     .docs[index]
                                        //     //     .data()["image"],

                                        //     "assets/images/bg.png",
                                        //     fit: BoxFit.cover,
                                        //   ),
                                        // ),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              detailsText(
                                                  "Counter: ${(snapshot.data as dynamic).docs[index].data()["noofcounter"]}"),
                                              detailsText(
                                                  (snapshot.data as dynamic)
                                                      .docs[index]
                                                      .data()["phone"]),
                                              GestureDetector(
                                                onTap: (() =>
                                                    Get.to(() => UserBooking(
                                                          snap: (snapshot.data
                                                                  as dynamic)
                                                              .docs[index]
                                                              .data(),
                                                          name: name,
                                                        ))),
                                                child: Container(
                                                    margin:
                                                        const EdgeInsets.all(
                                                            15),
                                                    decoration: BoxDecoration(
                                                        color: color,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30)),
                                                    child: const Padding(
                                                      padding:
                                                          EdgeInsets.all(7.0),
                                                      child: Text(
                                                        "Book now",
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ],
                      );
                    }
                  }),
            ),
          ],
        ),
      )),
    );
  }

  Padding detailsText(
    String title,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
      ),
    );
  }
}
//  ListTile(
//   title: Text(
//       "Salon name: ${(snapshot.data as dynamic).docs[index].data()["shopname"]}"),
//   subtitle: Column(
//     crossAxisAlignment:
//         CrossAxisAlignment.start,
//     children: [
//       Text(
//           "Address: ${(snapshot.data as dynamic).docs[index].data()["shopaddress"]}"),
//       Text(
//           "Owner: ${(snapshot.data as dynamic).docs[index].data()["name"]}"),
//     ],
//   ),
//   trailing: Text(
//       "No.of Seat: ${(snapshot.data as dynamic).docs[index].data()["noofcounter"]}"),
// ),
