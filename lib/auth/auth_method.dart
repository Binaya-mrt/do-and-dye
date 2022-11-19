import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_and_dye/auth/storage_method.dart';
import 'package:do_and_dye/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthMethod {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  // Signup with email and password
  Future<String> signUpUser(
      {required String name,
      required String email,
      required String password,
      String? shopname,
      required String address,
      int? noofcounter,
      String? pannumber,
      required String phone,
      required bool isBarber,
      Uint8List? profileImage,
      Uint8List? shopImage}) async {
    String res = "Some error occured";

    try {
      // this will only signup a user
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      // We also need to store bio and username in firestore
      // (_fireStrore.collection("users").doc(cred.user!.uid));
      if (isBarber) {
        String profileUrl = await StorageMethod().uploadImageToStorage(
            childName: "barberProfile", image: profileImage!);
        String shopImageUrl = await StorageMethod().uploadImageToStorage(
            childName: "barberProfile", image: shopImage!);
        await _fireStore
            .collection(
              "users",
            )
            .doc(cred.user!.uid)
            .set({
          "email": email,
          "name": name,
          "shopname": shopname,
          "shopaddress": address,
          "noofcounter": noofcounter,
          "pannumber": pannumber,
          "phone": phone,
          "uid": cred.user!.uid,
          "isBarber": isBarber,
          "profileImage": profileUrl,
          "shopImage": shopImageUrl,
        });

        await _fireStore
            .collection("users")
            .doc(cred.user!.uid)
            .collection("appointments")
            .doc(cred.user!.uid)
            .set({
          "queue": [],
          "system": [],
          "todaysTotal": 0,
        });
      } else {
        await _fireStore
            .collection(
              "customers",
            )
            .doc(cred.user!.uid)
            .set({
          "email": email,
          "name": name,
          "shopname": shopname,
          "shopaddress": address,
          "noofcounter": noofcounter,
          "pannumber": pannumber,
          "phone": phone,
          "uid": cred.user!.uid,
          "isBarber": isBarber,
        });
      }

      res = "success";
    } on FirebaseAuthException catch (err) {
      res = err.message.toString();
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // loging up a user
  Future<String> loginUser(
      {required String email,
      required String password,
      required bool inputBarber}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String res = "Some error occured";
    // log(email);
    log("$password passwrord");
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        // this will only signup a user
        UserCredential cred = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";

        if (res == "success") {
          if (inputBarber) {
            UserModel user = UserModel.fromSnap(
                await _fireStore.collection("users").doc(cred.user!.uid).get());
            prefs.setString("uuid", cred.user!.uid);
            prefs.setString("name", user.name);

            prefs.setString("userType", "barber");
            res = "barber";
            log(user.name);
            // log(user.shopImage!);
          } else if (!inputBarber) {
            UserModel user = UserModel.fromSnap(await _fireStore
                .collection("customers")
                .doc(cred.user!.uid)
                .get());

            prefs.setString("uuid", cred.user!.uid);
            prefs.setString("name", user.name);

            prefs.setString("userType", "customer");
            res = "customer";
          }
        }
      } else {
        res = "Please enter email and password";
      }
    } on FirebaseAuthException catch (err) {
      res = err.message.toString();
    } on SocketException catch (err) {
      res = err.toString();
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
