import 'package:do_and_dye/controllers/utils_controller.dart';
import 'package:do_and_dye/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  final UtilsController _utilsController = Get.put(UtilsController());
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
    _utilsController.isLoading.value = true;
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
    _utilsController.isLoading.value = false;
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

  // make form with validation
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              inputForm(
                hintText: "Your Full Name",
                labelText: "Full Name",
                controller: _nameController,
                textInputType: TextInputType.name,
              ),
              inputForm(
                hintText: "Your Email",
                labelText: "Email",
                controller: _emailController,
                textInputType: TextInputType.emailAddress,
              ),
              inputForm(
                hintText: "Your Phone Number",
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
                  hintText: "Password",
                  labelText: "Password",
                  controller: _passwordController,
                  textInputType: TextInputType.visiblePassword,
                  obscureText: true),
              //ToDo: Add a button to upload shop image, and a button to upload shop license

              GestureDetector(
                onTap: (() {
                  if (_formKey.currentState!.validate()) {
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
                      child: Obx(
                        () => _utilsController.isLoading.value
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "Signup as a Owner",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                      ),
                    )),
              ),
            ],
          ),
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
