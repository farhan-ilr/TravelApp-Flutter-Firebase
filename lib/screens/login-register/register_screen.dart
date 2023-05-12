import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travel_app/Models-and-Functions/controller/authcontroller.dart';
import 'package:travel_app/screens/login-register/login_screen.dart';

class Registerpage extends StatefulWidget {
  const Registerpage({super.key});
  @override
  State<Registerpage> createState() => _RegisterpageState();
}

class _RegisterpageState extends State<Registerpage> {
  TextEditingController confPass = TextEditingController();
  final ctrl = Get.put(AuthController());
  final _formKey = GlobalKey<FormState>();
  InputDecoration decorationTextBox({required String label}) {
    return InputDecoration(labelText: label);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Center(
                    child: Form(
                        key: _formKey,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "TravelHub",
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontFamily:
                                        GoogleFonts.raleway().fontFamily,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 40),
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                  controller: ctrl.username,
                                  decoration:
                                      decorationTextBox(label: "Username :"),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter your Username';
                                    }
                                    return null;
                                  }),
                              const SizedBox(height: 15),
                              TextFormField(
                                  controller: ctrl.email,
                                  decoration:
                                      decorationTextBox(label: "E-Mail :"),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter a valid email';
                                    }
                                    return null;
                                  }),
                              const SizedBox(height: 15),
                              TextFormField(
                                  controller: ctrl.password,
                                  decoration:
                                      decorationTextBox(label: 'Password'),
                                  obscureText: true,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter your password';
                                    }
                                    return null;
                                  }),
                              const SizedBox(height: 15),
                              TextFormField(
                                  controller: confPass,
                                  decoration: decorationTextBox(
                                      label: 'Confirm Password'),
                                  obscureText: true,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please Renter your password';
                                    } else if (value !=
                                        ctrl.password.text.trim()) {
                                      return 'Password MissMatch';
                                    }
                                    return null;
                                  }),
                              const SizedBox(height: 15),
                              CupertinoButton(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();

                                      await ctrl.signUp(context);
                                    }
                                  },
                                  child: ctrl.loading.value
                                      ? const CircularProgressIndicator(
                                          color: Colors.white)
                                      : const Text("SignUp"))
                            ]))))),
        bottomNavigationBar:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text("Already  have a account?"),
          CupertinoButton(
              child: const Text("LogIn"),
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (ctx) => const LoginPage(),
                ));
              })
        ]));
  }
}
