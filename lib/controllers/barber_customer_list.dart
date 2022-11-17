import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

/// This class contains the method and function required to update the lis of customers in the barber's list by barber
class BarberUpdate {
// Name should be unique
//1. Add to queue ( physically aauni lai add garna)
  Future<void> addtoQueuePhysically(
    String barberUuid,
  ) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String uuid = prefs.getString('uuid')!;

    var randomID = Uuid().v1();
    final now = DateTime.now();
    String name = "physically visited!";
    FirebaseFirestore.instance
        .collection("users")
        .doc(barberUuid)
        .collection("appointments")
        .doc(barberUuid)
        .update({
      "queue": FieldValue.arrayUnion(
          ["${now.hour}:" + "${now.minute}" + ":${now.second}\n" + name])
    });
  }

  Future<void> addtoQueue(
    String name,
    String barberUuid,
  ) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String uuid = prefs.getString('uuid')!;

    FirebaseFirestore.instance
        .collection("users")
        .doc(barberUuid)
        .collection("appointments")
        .doc(barberUuid)
        .update({
      "queue": FieldValue.arrayUnion([name])
    });
  }

// 2. Add to system ( palo aayepaxi kapal katni bela ma add garna)
// remove from queue
  Future<void> addtoSystem(int index, snap) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uuid = prefs.getString('uuid')!;

    FirebaseFirestore.instance
        .collection("users")
        .doc(uuid)
        .collection("appointments")
        .doc(uuid)
        .update({
      "system": FieldValue.arrayUnion([snap["queue"][index]])
    });
    FirebaseFirestore.instance
        .collection("users")
        .doc(uuid)
        .collection("appointments")
        .doc(uuid)
        .update({
      "queue": FieldValue.arrayRemove([snap["queue"][index]])
    });
  }
  // user cancel appointment

  Future<void> cancelAppointment(uuid, name) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String uuid = prefs.getString('uuid')!;
    log(name);
    FirebaseFirestore.instance
        .collection("users")
        .doc(uuid)
        .collection("appointments")
        .doc(uuid)
        .update({
      "queue": FieldValue.arrayRemove([name])
    });
  }
//3. remove from system( kapal katye paxi system bata out garauna lai (ALSO should increment todays total) )

  Future<void> removeFromSystem(int index, snap) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uuid = prefs.getString('uuid')!;

    FirebaseFirestore.instance
        .collection("users")
        .doc(uuid)
        .collection("appointments")
        .doc(uuid)
        .update({
      "system": FieldValue.arrayRemove([snap["system"][index]])
    });
    FirebaseFirestore.instance
        .collection("users")
        .doc(uuid)
        .collection("appointments")
        .doc(uuid)
        .update({"todaysTotal": FieldValue.increment(1)});
  }

//5. Make the counter zero (used for next day purpose)
  Future<void> makeCounterZero() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uuid = prefs.getString('uuid')!;

    FirebaseFirestore.instance
        .collection("users")
        .doc(uuid)
        .collection("appointments")
        .doc(uuid)
        .update({"todaysTotal": 0});
  }
}
