import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_and_dye/controllers/barber_customer_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class UserBooking extends StatelessWidget {
  final snap;
  final String name;
  UserBooking({required this.snap, required this.name});
  String hourMinuteConvert(int n) {
    if (n > 60) {
      String hour = 0.toString();
      while (n > 60) {
        n = n - 60;
        hour = (int.parse(hour) + 1).toString();
      }
      String time = (n / 60).toString();
      // String hour = time.split('.')[0];
      String minutes = n.toString();
      return hour + " hours " + minutes + " minutes";
    } else
      return n.toString() + "minutes";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Do and Dye")),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //rounded rectangle container
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(
                        "https://images.unsplash.com/photo-1600948836101-f9ffda59d250?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8c2Fsb258ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60"),
                  ),
                ),
              ),
              Center(
                child: Text(
                  snap["shopname"],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 23,
                  ),
                ),
              ),
              Center(
                child: Text(
                  snap["shopaddress"],
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text(
                  snap["name"],
                ),
              ),
              ListTile(
                leading: Icon(Icons.phone),
                title: Text(
                  snap["phone"],
                ),
              ),
              ListTile(
                leading: Icon(Icons.countertops),
                title: Text(
                  "${snap["noofcounter"]} Counters",
                ),
              ),
              StreamBuilder<Object>(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(snap["uid"])
                      .collection("appointments")
                      .doc(snap["uid"])
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      return Column(children: [
                        ListTile(
                            title: Text("Current Queue"),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                (snapshot.data! as dynamic)
                                            .data()['queue']
                                            .length ==
                                        0
                                    ? Text("No one in queue")
                                    : Text(
                                        (snapshot.data! as dynamic)
                                            .data()['queue']
                                            .length
                                            .toString(),
                                      ),
                                (snapshot.data! as dynamic)
                                            .data()['system']
                                            .length <
                                        snap["noofcounter"]
                                    ? Text(
                                        "${snap["noofcounter"] - (snapshot.data! as dynamic).data()['system'].length} counter is free",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey[600],
                                        ),
                                      )
                                    : SizedBox()
                              ],
                            )),
                        ElevatedButton(
                          onPressed: () {
                            ((snapshot.data! as dynamic).data()['queue'])
                                    .contains(name)
                                ? showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text("Already in queue"),
                                        content: Text(
                                            "You are already in queue. Please wait for your turn."),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text("Ok")),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);

                                                BarberUpdate()
                                                    .cancelAppointment(
                                                        snap["uid"], name);
                                              },
                                              child: Text("Cancel Appointment"))
                                        ],
                                      );
                                    })
                                : BarberUpdate().addtoQueue(name, snap['uid']);
                          },
                          child: Text(
                            ((snapshot.data! as dynamic).data()['queue'])
                                    .contains(name)
                                ? "Already in queue\n Want to cancel?"
                                : "Reserve Queue",
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                        ((snapshot.data! as dynamic).data()['queue'])
                                .contains(name)
                            ? Column(
                                children: [
                                  Text(
                                      "Your are at ${((snapshot.data! as dynamic).data()['queue']).indexOf(name) + 1} position in queue."),
                                  Text(
                                      "Reach to salon at ${hourMinuteConvert(((snapshot.data! as dynamic).data()['queue']).indexOf(name) * 35)} "),
                                ],
                              )
                            : SizedBox(),
                      ]);
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
