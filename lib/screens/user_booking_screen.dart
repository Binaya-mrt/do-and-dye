import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_and_dye/controllers/barber_customer_list.dart';
import 'package:flutter/material.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';

class UserBooking extends StatelessWidget {
  final snap;
  final String name;
  const UserBooking({required this.snap, required this.name});
  final Color color = const Color(0xffaf3557);

  String hourMinuteConvert(int n) {
    if (n >= 60) {
      String hour = 0.toString();
      while (n >= 60) {
        n = n - 60;
        hour = (int.parse(hour) + 1).toString();
      }
      String time = (n / 60).toString();
      // String hour = time.split('.')[0];

      String minutes = n.toString();
      return n != 0 ? "$hour hours $minutes minutes" : "$hour hours ";
    } else {
      return "$n minutes";
    }
  }

  final String imageLink =
      "https://images.unsplash.com/photo-1600948836101-f9ffda59d250?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8c2Fsb258ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60";

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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FullScreenWidget(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            height: 150,
                            width: 150,
                            child: snap["shopImage"] == null
                                ? Image.network(
                                    imageLink,
                                    fit: BoxFit.cover,
                                  )
                                : Image.network(
                                    snap["shopImage"],
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            snap["shopname"],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 23,
                              color: color,
                            ),
                          ),
                          detailsText(snap["name"]),
                          detailsText(snap["shopaddress"]),
                          detailsText("Counter: ${snap["noofcounter"]} "),
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    "Service List",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 23,
                      color: color,
                    ),
                  ),
                ),
                const ServiceListCard(
                    price: "100", service: "Men's Haircut", time: "45 mins"),
                const ServiceListCard(
                    price: "50", service: "Baby's Haircut", time: "30 mins"),
                const ServiceListCard(
                    price: "70", service: "Men's Shaving", time: "25 mins"),
                const ServiceListCard(
                    price: "200", service: "Men's Hair color", time: "45 mins"),
                const ServiceListCard(
                    price: "100", service: "Men's Haircut", time: "45 mins"),
                StreamBuilder<Object>(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .doc(snap["uid"])
                        .collection("appointments")
                        .doc(snap["uid"])
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(children: [
                            ListTile(
                              title: Text(
                                "Current Queue",
                                style: TextStyle(color: color, fontSize: 20),
                              ),
                              subtitle: (snapshot.data! as dynamic)
                                          .data()['queue']
                                          .length ==
                                      0
                                  ? const Text("No one in queue")
                                  : Text(
                                      "${(snapshot.data! as dynamic).data()['queue'].length} people in queue",
                                      style: const TextStyle(fontSize: 18),
                                    ),
                              trailing: (snapshot.data! as dynamic)
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
                                  : const SizedBox(),
                            ),
                            ListTile(
                              title: Text("Your Turn",
                                  style: TextStyle(color: color, fontSize: 20)),
                              subtitle: (snapshot.data! as dynamic)
                                              .data()['queue']
                                              .length ==
                                          0 ||
                                      (((snapshot.data! as dynamic)
                                                  .data()['queue'])
                                              .indexOf(name)) ==
                                          0
                                  ? const Text(
                                      "Your are at first!\n Reach salon to get your turn")
                                  : ((snapshot.data! as dynamic)
                                              .data()['queue'])
                                          .contains(name)
                                      ? Text(
                                          // (((snapshot.data! as dynamic)
                                          //               .data()['queue'])
                                          //           .indexOf(name) -
                                          //       1)
                                          //   .toString())
                                          "Reach salon in ${hourMinuteConvert((((snapshot.data! as dynamic).data()['queue']).indexOf(name) - 1) * 30)} ")
                                      : Text(
                                          "Est waiting : ${hourMinuteConvert((((snapshot.data! as dynamic).data()['queue']).length - 1) * 30)}"),
                            ),
                            GestureDetector(
                              onTap: () {
                                ((snapshot.data! as dynamic).data()['queue'])
                                        .contains(name)
                                    ? showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title:
                                                const Text("Already in queue"),
                                            content: const Text(
                                                "You are already in queue. Please wait for your turn."),
                                            actions: [
                                              TextButton(
                                                  style: TextButton.styleFrom(
                                                      foregroundColor: color),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text("Ok")),
                                              TextButton(
                                                  style: TextButton.styleFrom(
                                                      foregroundColor: color),
                                                  onPressed: () {
                                                    Navigator.pop(context);

                                                    BarberUpdate()
                                                        .cancelAppointment(
                                                            snap["uid"],
                                                            name,
                                                            context);
                                                  },
                                                  child: const Text(
                                                      "Cancel Appointment"))
                                            ],
                                          );
                                        })
                                    : BarberUpdate()
                                        .addtoQueue(name, snap['uid'], context);
                              },
                              child: Container(
                                  margin: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                      color: color,
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(7.0),
                                    child: Text(
                                      ((snapshot.data! as dynamic)
                                                  .data()['queue'])
                                              .contains(name)
                                          ? "Already in queue\n Want to cancel?"
                                          : "Reserve Queue",
                                      style: const TextStyle(
                                          fontSize: 18, color: Colors.white),
                                    ),
                                  )),
                            ),
                          ]),
                        );
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
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

class ServiceListCard extends StatelessWidget {
  const ServiceListCard({
    Key? key,
    required this.service,
    required this.time,
    required this.price,
  }) : super(key: key);
  final String service;
  final String time;
  final String price;
  final Color color = const Color(0xffaf3557);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          service,
          style: TextStyle(
            // fontWeight: FontWeight.bold,
            fontSize: 20,
            color: color,
          ),
        ),
        subtitle: Text(
          time,
        ),
        trailing: Text(
          "Rs. $price",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: color,
          ),
        ),
      ),
    );
  }
}

// stl
class ExpandedImageScreen extends StatelessWidget {
  const ExpandedImageScreen({super.key, required this.image});

  final String image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
                top: 0,
                left: 20,
                child: IconButton(
                    onPressed: () {
                      // Get.off(() => const UserBooking());
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                    ))),
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Image.network(
                image,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
