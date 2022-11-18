import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_and_dye/controllers/barber_customer_list.dart';
import 'package:do_and_dye/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BarberHome extends StatefulWidget {
  final String uuid;
  const BarberHome({required this.uuid, Key? key}) : super(key: key);

  @override
  State<BarberHome> createState() => _BarberHomeState();
}

// final BarberListController _list = Get.put(BarberListController());

class _BarberHomeState extends State<BarberHome> {
  // @override

  // void initState() {
  //   super.initState();
  //   print('hello world');
  //   _list.getAppointmentList();

  // }

// String uuid= prefs.getString('uuid')!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Do and dye"),
        actions: [
          IconButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.clear();
                Get.offAll(() => const LoginPage());
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("pressed");
          BarberUpdate().addtoQueuePhysically(widget.uuid, context);
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: StreamBuilder<Object>(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(widget.uuid)
                  .collection("appointments")
                  .doc(widget.uuid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return Column(
                    children: [
                      GestureDetector(
                        onLongPress: () {
                          BarberUpdate().makeCounterZero(context);
                        },
                        child: Text(
                          "Today's total: ${(snapshot.data! as dynamic).data()['todaysTotal']}",
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "On process",
                        style: TextStyle(fontSize: 22),
                      ),
                      (snapshot.data! as dynamic).data()['system'].length == 0
                          ? const SizedBox(
                              height: 50,
                              child: Text(
                                "No one is currently cutting hair",
                                style: TextStyle(fontSize: 22),
                              ),
                            )
                          : ListView.builder(
                              itemCount: (snapshot.data! as dynamic)
                                  .data()['system']
                                  .length,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onDoubleTap: () {
                                    BarberUpdate().removeFromSystem(
                                        index,
                                        (snapshot.data! as dynamic).data(),
                                        context);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0, horizontal: 8),
                                    child: ListTile(
                                      tileColor: Colors.green.withOpacity(0.8),
                                      title: Text((snapshot.data! as dynamic)
                                          .data()['system'][index]),
                                      //(snapshot.data! as dynamic).data()['system'][1]
                                      //
                                      leading: Text((index + 1).toString()),
                                    ),
                                  ),
                                );
                              },
                            ),
                      const Text(
                        "Queue",
                        style: TextStyle(fontSize: 22),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      (snapshot.data! as dynamic).data()['queue'].length == 0
                          ? const SizedBox(
                              height: 50,
                              child: Text(
                                "No one is in the queue!",
                                style: TextStyle(fontSize: 22),
                              ),
                            )
                          : ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onDoubleTap: () {
                                    BarberUpdate().addtoSystem(
                                        index,
                                        (snapshot.data! as dynamic).data(),
                                        context);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0, horizontal: 8),
                                    child: ListTile(
                                      tileColor: Colors.red.withOpacity(0.3),
                                      title: Text((snapshot.data! as dynamic)
                                          .data()['queue'][index]),
                                      leading: Text((index + 1).toString()),
                                    ),
                                  ),
                                );
                              },
                              itemCount: (snapshot.data! as dynamic)
                                  .data()['queue']
                                  .length,
                            ),
                    ],
                  );
                }
              }),
        ),
      ),
    );
  }
}
