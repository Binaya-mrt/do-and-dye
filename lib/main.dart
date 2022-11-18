import 'dart:developer';

import 'package:do_and_dye/auth/auth_method.dart';
import 'package:do_and_dye/controllers/constant.dart';
import 'package:do_and_dye/controllers/utils_controller.dart';
import 'package:do_and_dye/screens/barber_main_screen.dart';
import 'package:do_and_dye/screens/user_main_screen.dart';
import 'package:do_and_dye/signup_barber.dart';
import 'package:do_and_dye/signup_user.dart';
import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    // color: Color(0xffaf3557),
    home: EasySplashScreen(
        durationInSeconds: 5,
        showLoader: false,
        backgroundColor: Colors.black,
        logo: Image.asset('assets/images/dondye.png'),
        navigator: uuid == null
            ? const LoginPage()
            : userType == "barber"
                ? BarberHome(
                    uuid: uuid,
                    name: name!,
                  )
                : UserHome(
                    uuid: uuid,
                    name: name!,
                  )),
  ));
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final UtilsController _utilsController = Get.put(UtilsController());
  final Color color = const Color(0xffaf3557);

  userLogin(
      {required String email,
      required String password,
      required BuildContext context}) async {
    _utilsController.isLoading.value = true;
    String res = await AuthMethod().loginUser(
        email: email,
        password: password,
        inputBarber: _utilsController.isBarber.value);
    log(res);
    if (res == "barber") {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BarberHome(
                uuid: FirebaseAuth.instance.currentUser!.uid, name: "binaya"),
          ));
    } else if (res == "customer") {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => UserHome(
                    uuid: FirebaseAuth.instance.currentUser!.uid,
                    name: "binaya",
                  )));
    } else if (res == "The email address is badly formatted.") {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Enter a valid email")));
    } else if (res ==
        "type 'Null' is not a subtype of type 'Map<String, dynamic>' in type cast") {
      Utils().showSnackBar(context, "Choose a valid user type!");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res)));
    }
    _utilsController.isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/dondye.png"),
                        fit: BoxFit.contain)),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15.0, horizontal: 8),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    focusColor: color,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: color),
                    ),
                    disabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    labelText: 'Email',
                    labelStyle: const TextStyle(color: Colors.white),
                    hintText: 'Enter your email',
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Obx(
                  () => TextField(
                    style: const TextStyle(color: Colors.white),
                    controller: _passwordController,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.all(8),
                      suffix: IconButton(
                          onPressed: () {
                            _utilsController.isObscure.value =
                                !_utilsController.isObscure.value;
                          },
                          icon: _utilsController.isObscure.value
                              ? const Icon(
                                  Icons.visibility_off,
                                  color: Colors.white,
                                )
                              : const Icon(
                                  Icons.visibility,
                                  color: Colors.white,
                                )),
                      disabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusColor: color,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: color),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      labelText: 'Password',
                      labelStyle: const TextStyle(color: Colors.white),
                      hintText: 'Enter password',
                    ),
                    obscureText: _utilsController.isObscure.value,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: color,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BarberSignup()),
                    );
                  },
                  child: const Text("Forgot Password"),
                ),
              ),
              Row(
                children: [
                  const Text(
                    "Salon Owner",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  Switch(
                    value: _utilsController.isBarber.value,
                    onChanged: (value) {
                      setState(() {
                        _utilsController.isBarber.value = value;
                      });
                      print(_utilsController.isBarber);
                    },
                    activeTrackColor: const Color(0xffaf3557),
                    activeColor: const Color(0xffaf3557),
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: Colors.white,
                  ),
                ],
              ),
              GestureDetector(
                onTap: (() => userLogin(
                    email: _emailController.text,
                    password: _passwordController.text,
                    context: context)),
                child: Container(
                    margin: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: color, borderRadius: BorderRadius.circular(30)),
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 27.0, vertical: 10),
                        child: Obx(
                          () => _utilsController.isLoading.value
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  "Login",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                        ))),
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Icon(
                      Icons.person,
                      color: color,
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: color,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UserSignup()),
                      );
                    },
                    child: const Text("New user Signup"),
                  )
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      '✃',
                      style: TextStyle(color: color, fontSize: 20),
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: color,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BarberSignup()),
                      );
                    },
                    child: const Text("Owns a shop? Signup here!"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
