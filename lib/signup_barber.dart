import 'package:do_and_dye/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get_state_manager/src/simple/list_notifier.dart';

import 'auth/auth_method.dart';

class BarberSignup extends StatelessWidget {
  BarberSignup({super.key});
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _shopnameController = TextEditingController();
  final TextEditingController _shopaddressController = TextEditingController();
  final TextEditingController _noofcounterController = TextEditingController();
  final TextEditingController _pannumberController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  barberSignup({
    required String name,
    required String email,
    required String password,
    required String shopname,
    required String shopaddress,
    required int noofcounter,
    required String pannumber,
    required String phone,
    required BuildContext context,
  }) async {
    String res = await AuthMethod().signUpUser(
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      shopname: _shopnameController.text,
      address: _shopaddressController.text,
      noofcounter: int.parse(_noofcounterController.text),
      pannumber: _pannumberController.text,
      phone: _phoneController.text,
      isBarber: true,
    );
    if (res == "success") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Signup Successful"),
        ),
      );
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginPage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Signup Failed"),
        ),
      );
    }
  }

  @override
  dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _shopnameController.dispose();
    _shopaddressController.dispose();
    _noofcounterController.dispose();
    _pannumberController.dispose();
    _phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            inputForm(
              hintText: "Your Full Name",
              labelText: "Full Name",
              controller: _nameController,
              textInputType: TextInputType.name,
            ),
            inputForm(
              hintText: "Enter your Email",
              labelText: "Email",
              controller: _emailController,
              textInputType: TextInputType.emailAddress,
            ),
            inputForm(
              hintText: "Enter your Phone Number",
              labelText: "Phone",
              controller: _phoneController,
              textInputType: TextInputType.phone,
            ),
            inputForm(
              hintText: "Shop Name",
              controller: _shopnameController,
              labelText: "Shop Name",
              textInputType: TextInputType.name,
            ),
            inputForm(
              hintText: "Shop Address",
              labelText: "Shop Address",
              controller: _shopaddressController,
              textInputType: TextInputType.streetAddress,
            ),
            inputForm(
              hintText: "No of counter",
              labelText: "No of counter",
              controller: _noofcounterController,
              textInputType: TextInputType.number,
            ),
            inputForm(
              hintText: "PAN Number",
              labelText: "PAN number",
              controller: _pannumberController,
              textInputType: TextInputType.number,
            ),
            inputForm(
                hintText: "Enter password",
                labelText: "Password",
                controller: _passwordController,
                textInputType: TextInputType.visiblePassword,
                obscureText: true),
            //ToDo: Add a button to upload shop image, and a button to upload shop license
            Center(
              child: ElevatedButton(
                  onPressed: () {
                    barberSignup(
                      name: _nameController.text,
                      email: _emailController.text,
                      password: _passwordController.text,
                      shopname: _shopnameController.text,
                      shopaddress: _shopaddressController.text,
                      noofcounter: int.parse(_noofcounterController.text),
                      pannumber: _pannumberController.text,
                      phone: _phoneController.text,
                      context: context,
                    );
                    print("signuo button pressed");
                  },
                  child: Text("Signup as a Owner")),
            )
          ],
        ),
      )),
    );
  }

  inputForm({
    required String hintText,
    required String labelText,
    bool obscureText = false,
    required TextInputType textInputType,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: labelText,
          filled: true,
          hintText: hintText,
        ),
        obscureText: obscureText,
        keyboardType: textInputType,
        controller: controller,
      ),
    );
  }
}
