import 'package:do_and_dye/auth/auth_method.dart';
import 'package:do_and_dye/controllers/utils_controller.dart';
import 'package:do_and_dye/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserSignup extends StatelessWidget {
  UserSignup({super.key});
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final UtilsController _controller = Get.put(UtilsController());
  userSignup({
    required String name,
    required String email,
    required String password,
    required String address,
    required String phone,
    required BuildContext context,
  }) async {
    print("called upper function");
    _controller.isLoading.value = true;
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
          MaterialPageRoute(builder: (context) => const LoginPage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Signup Failed"),
        ),
      );
    }
    _controller.isLoading.value = false;
  }

  final _formKey = GlobalKey<FormState>();

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
        body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
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
                  GestureDetector(
                    onTap: (() {
                      if (_formKey.currentState!.validate()) {
                        userSignup(
                          name: _nameController.text,
                          email: _emailController.text,
                          password: _passwordController.text,
                          address: _address.text,
                          phone: _phoneController.text,
                          context: context,
                        );
                      }
                    }),
                    child: Container(
                        margin: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: const Color(0xffaf3557),
                            borderRadius: BorderRadius.circular(30)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 27.0, vertical: 10),
                          child: Obx(() => _controller.isLoading.value
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  "Sign Up",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                )),
                        )),
                  ),
                ],
              ),
            ),
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
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter ${hintText.toLowerCase()}';
          }
          return null;
        },
        decoration: InputDecoration(
          focusColor: const Color(0xffaf3557),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xffaf3557)),
          ),
          disabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xffaf3557)),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xffaf3557)),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          labelText: labelText,
          labelStyle: const TextStyle(color: Color(0xffaf3557)),
          hintText: hintText,
        ),
        obscureText: obscureText,
        keyboardType: textInputType,
        controller: controller,
      ),
    );
  }
}
