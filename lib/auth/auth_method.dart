import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_and_dye/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthMethod {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  // Signup with email and password
  Future<String> signUpUser({
    required String name,
    required String email,
    required String password,
    String? shopname,
    required String address,
    int? noofcounter,
    String? pannumber,
    required String phone,
    required bool isBarber,
  }) async {
    String res = "Some error occured";
    log("1. The user is a : " + isBarber.toString());
    try {
      // this will only signup a user
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      // We also need to store bio and username in firestore
      // (_fireStrore.collection("users").doc(cred.user!.uid));
      if (isBarber) {
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
          "phone": phone,
          "address": address,
          "isBarber": isBarber,
          "uid": cred.user!.uid,
        });
      }
      log(cred.user!.uid);
      log("success");
      res = "success";
    } on FirebaseAuthException catch (err) {
      res = err.message.toString();
    } catch (err) {
      res = err.toString();
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // loging up a user
  Future<String> loginUser(
      {required String email, required String password}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String res = "Some error occured";
    // log(email);
    log(password + " passwrord");
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        // this will only signup a user
        UserCredential cred = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";

        if (res == "success") {
          log("success");
          log(cred.user!.uid);
          UserModel _user = UserModel.fromSnap(
              await _fireStore.collection("users").doc(cred.user!.uid).get());
          log(_user.toString() + " muji USER");
          prefs.setString("uuid", cred.user!.uid);
          prefs.setString("name", _user.name);

          prefs.setString("userType", _user.isBarber ? "barber" : "customer");

          if (_user.isBarber) {
            res = "barber";
          } else {
            res = "customer";
            log(res);
          }
        }
      } else {
        res = "Please enter email and password";
      }
    } on FirebaseAuthException catch (err) {
      res = err.message.toString();
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
