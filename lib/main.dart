import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_and_dye/auth/auth_method.dart';
import 'package:do_and_dye/screens/barber_main_screen.dart';
import 'package:do_and_dye/screens/user_main_screen.dart';
import 'package:do_and_dye/signup_barber.dart';
import 'package:do_and_dye/signup_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyAzQjCIIkcmbM2udRalwT-lHAWM68U4UPA",
            appId: "1:990000369617:web:da099b997490cab2909af0",
            messagingSenderId: "990000369617",
            storageBucket: "do-and-dye.appspot.com",
            projectId: "do-and-dye"));
  } else {
    await Firebase.initializeApp();
  }

  SharedPreferences prefs = await SharedPreferences.getInstance();
  var uuid = prefs.getString('uuid');
  var userType = prefs.getString('userType');
  var name = prefs.getString('name');
  runApp(GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
      color: Color(0xffaf3557),
      home: uuid == null
          ? LoginPage()
          : userType == "barber"
              ? BarberHome(
                  uuid: uuid,
                )
              : UserHome(
                  uuid: uuid,
                  name: name ?? "binaya",
                )));
}

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  dispose() {
    _emailController.dispose();
    _passwordController.dispose();
  }

  userLogin(
      {required String email,
      required String password,
      required BuildContext context}) async {
    String res = await AuthMethod().loginUser(email: email, password: password);
    log(res);
    if (res == "barber") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  BarberHome(uuid: FirebaseAuth.instance.currentUser!.uid)));
    } else if (res == "customer") {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => UserHome(
                    uuid: FirebaseAuth.instance.currentUser!.uid,
                    name: "binaya",
                  )));
    } else {
      print("Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Do and Dye',
              style: TextStyle(fontSize: 35),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'Enter your email',
              ),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                hintText: 'Enter your password',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                userLogin(
                    email: _emailController.text,
                    password: _passwordController.text,
                    context: context);

                log("login pressed");
              },
              child: Text('Login'),
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              children: [
                Icon(Icons.new_releases_outlined),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserSignup()),
                    );
                  },
                  child: Text("New user Signup"),
                )
              ],
            ),
            Row(
              children: [
                Text('✃'),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BarberSignup()),
                    );
                  },
                  child: Text("Owns a shop? Signup here!"),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
