import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_and_dye/controllers/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

/// This class contains the method and function required to update the lis of customers in the barber's list by barber
class BarberUpdate {
// Name should be unique
//1. Add to queue ( physically aauni lai add garna)
  Future<void> addtoQueuePhysically(
      String barberUuid, BuildContext context) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String uuid = prefs.getString('uuid')!;

    var randomID = const Uuid().v1();
    final now = DateTime.now();
    String name = "physically visited!";
    try {
      FirebaseFirestore.instance
          .collection("users")
          .doc(barberUuid)
          .collection("appointments")
          .doc(barberUuid)
          .update({
        "queue": FieldValue.arrayUnion(
            ["${now.hour}:${now.minute}:${now.second}\n$name"])
      });
    } on FirebaseException catch (e) {
      Utils().showSnackBar(context, e.toString());
    } catch (e) {
      Utils().showSnackBar(context, e.toString());
    }
  }

  Future<void> addtoQueue(
    String name,
    String barberUuid,
    BuildContext context,
  ) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String uuid = prefs.getString('uuid')!;
    try {
      FirebaseFirestore.instance
          .collection("users")
          .doc(barberUuid)
          .collection("appointments")
          .doc(barberUuid)
          .update({
        "queue": FieldValue.arrayUnion([name])
      });
    } on FirebaseException catch (e) {
      Utils().showSnackBar(context, e.toString());
    } catch (e) {
      Utils().showSnackBar(context, e.toString());
    }
  }

//   Future<void> addtoSystem(
//     String name,
//     String barberUuid,
//     BuildContext context,
//   ) async {
//     // SharedPreferences prefs = await SharedPreferences.getInstance();
//     // String uuid = prefs.getString('uuid')!;
// }
//   }

// 2. Add to system ( palo aayepaxi kapal katni bela ma add garna)
// remove from queue
  Future<void> addtoSystem(int index, snap, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uuid = prefs.getString('uuid')!;

    try {
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
    } on FirebaseException catch (e) {
      Utils().showSnackBar(context, e.toString());
    } catch (e) {
      Utils().showSnackBar(context, e.toString());
    }
  }
  // user cancel appointment

  Future<void> cancelAppointment(uuid, name, BuildContext context) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String uuid = prefs.getString('uuid')!;
    log(name);
    try {
      FirebaseFirestore.instance
          .collection("users")
          .doc(uuid)
          .collection("appointments")
          .doc(uuid)
          .update({
        "queue": FieldValue.arrayRemove([name])
      });
    } on FirebaseException catch (e) {
      Utils().showSnackBar(context, e.toString());
    } catch (e) {
      Utils().showSnackBar(context, e.toString());
    }
  }
//3. remove from system( kapal katye paxi system bata out garauna lai (ALSO should increment todays total) )

  Future<void> removeFromSystem(int index, snap, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uuid = prefs.getString('uuid')!;

    try {
      await FirebaseFirestore.instance
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
    } on FirebaseException catch (e) {
      Utils().showSnackBar(context, e.toString());
    } catch (e) {
      Utils().showSnackBar(context, e.toString());
    }
  }

//5. Make the counter zero (used for next day purpose)
  Future<void> makeCounterZero(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uuid = prefs.getString('uuid')!;

    try {
      FirebaseFirestore.instance
          .collection("users")
          .doc(uuid)
          .collection("appointments")
          .doc(uuid)
          .update({"todaysTotal": 0});
    } on FirebaseException catch (e) {
      Utils().showSnackBar(context, e.toString());
    } catch (e) {
      Utils().showSnackBar(context, e.toString());
    }
  }
}
