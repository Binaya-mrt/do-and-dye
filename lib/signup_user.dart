import 'package:do_and_dye/auth/auth_method.dart';
import 'package:do_and_dye/main.dart';
import 'package:flutter/material.dart';

class UserSignup extends StatelessWidget {
  UserSignup({super.key});
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  userSignup({
    required String name,
    required String email,
    required String password,
    required String address,
    required String phone,
    required BuildContext context,
  }) async {
    print("called upper function");
    String res = await AuthMethod().signUpUser(
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      address: _address.text,
      phone: _phoneController.text,
      isBarber: false,
    );
    if (res == "success") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Signup Successful"),
        ),
      );
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginPage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Signup Failed"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          inputForm(
              hintText: "Enter your FullName",
              labelText: "Full Name",
              controller: _nameController,
              textInputType: TextInputType.name),
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
              textInputType: TextInputType.phone),
          inputForm(
              hintText: "Enter your Address",
              labelText: "Address",
              controller: _address,
              textInputType: TextInputType.emailAddress),
          inputForm(
              hintText: "Choose a Password",
              labelText: "Password",
              textInputType: TextInputType.visiblePassword,
              controller: _passwordController,
              obscureText: true),
          Center(
            child: ElevatedButton(
                onPressed: () {
                  userSignup(
                    name: _nameController.text,
                    email: _emailController.text,
                    password: _passwordController.text,
                    address: _address.text,
                    phone: _phoneController.text,
                    context: context,
                  );
                },
                child: const Text("Signup as a User")),
          )
        ],
      ),
    ));
  }

  inputForm(
      {required String hintText,
      required String labelText,
      bool obscureText = false,
      required TextInputType textInputType,
      required TextEditingController controller}) {
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
