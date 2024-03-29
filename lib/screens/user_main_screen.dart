import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_and_dye/main.dart';
import 'package:do_and_dye/screens/user_booking_screen.dart';
import 'package:flutter/material.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';
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
                                        ? Colors.black
                                        : Colors.white,
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
                                                      .data()["name"],
                                                  index),
                                              detailsText(
                                                  (snapshot.data as dynamic)
                                                      .docs[index]
                                                      .data()["shopaddress"],
                                                  index),
                                              detailsText(
                                                  "Counter: ${(snapshot.data as dynamic).docs[index].data()["noofcounter"]}",
                                                  index),
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
                                                            10),
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
                                        FullScreenWidget(
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            child: SizedBox(
                                                height: 150,
                                                width: 200,
                                                child: (snapshot
                                                            .connectionState ==
                                                        ConnectionState.waiting)
                                                    ? const Center(
                                                        child:
                                                            CircularProgressIndicator())
                                                    : (snapshot.data as dynamic)
                                                                    .docs[index]
                                                                    .data()[
                                                                "profileImage"] ==
                                                            null
                                                        ? Image.network(
                                                            "https://images.unsplash.com/photo-1600948836101-f9ffda59d250?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8c2Fsb258ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60",
                                                            fit: BoxFit.fill,
                                                          )
                                                        : Image.network(
                                                            (snapshot.data
                                                                        as dynamic)
                                                                    .docs[index]
                                                                    .data()[
                                                                "profileImage"],
                                                            fit: BoxFit.fill,
                                                          )),
                                          ),
                                        ),
                                        // ClipRRect(
                                        //   borderRadius:
                                        //       BorderRadius.circular(10),
                                        //   child: Container(
                                        //     padding: const EdgeInsets.symmetric(
                                        //         vertical: 4.0),
                                        //     height: 200,
                                        //     width: 200,
                                        //     decoration: const BoxDecoration(
                                        //       // rounded border
                                        //       borderRadius: BorderRadius.only(
                                        //           topRight: Radius.circular(20),
                                        //           bottomRight:
                                        //               Radius.circular(20)),
                                        //       image: DecorationImage(
                                        //           image: NetworkImage(
                                        //         "https://images.unsplash.com/photo-1600948836101-f9ffda59d250?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8c2Fsb258ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60",
                                        //       )),
                                        //     ),
                                        //   ),
                                        // ),
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
    int index,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          color: index % 2 == 0 ? Colors.white : Colors.black,
        ),
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
