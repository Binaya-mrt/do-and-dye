import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_and_dye/controllers/barber_customer_list.dart';
import 'package:do_and_dye/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BarberHome extends StatefulWidget {
  final String uuid;
  final String name;
  const BarberHome({required this.uuid, required this.name, Key? key})
      : super(key: key);

  @override
  State<BarberHome> createState() => _BarberHomeState();
}

const Color color = Color(0xffaf3557);

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
        centerTitle: true,
        backgroundColor: Colors.black,
        title: const Image(
          height: 150,
          image: AssetImage("assets/images/dondye.png"),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xffaf3557),
              ),
              accountName: Text(widget.name),
              accountEmail: Text(widget.uuid),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  widget.name[0],
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: color,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onLongPress: () {
                          BarberUpdate().makeCounterZero(context);
                        },
                        child: Card(
                          child: ListTile(
                            title: const Text(
                              "Today's total:",
                              style: TextStyle(fontSize: 20),
                            ),
                            trailing: Text(
                              " ${(snapshot.data! as dynamic).data()['todaysTotal']}",
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "On process",
                          style: TextStyle(fontSize: 24, color: color),
                        ),
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
                                      tileColor: const Color(0xffEBF5FF),
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
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Queue",
                          style: TextStyle(fontSize: 24, color: color),
                        ),
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
                                      tileColor: const Color(0xffFFF0EC),
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
