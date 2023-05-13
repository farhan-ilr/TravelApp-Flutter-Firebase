import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travel_app/admin&trave_agency/admin/admin_home.dart';
import 'package:travel_app/main.dart';
import 'package:travel_app/screens/login-register/register_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                child: SingleChildScrollView(
                    child: Form(
                        key: _formKey,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("TravelHub",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      fontFamily:
                                          GoogleFonts.raleway().fontFamily,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 40)),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: ctrl.loginEmail,
                                decoration: decorationTextBox(label: "E-Mail"),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 15),
                              TextFormField(
                                controller: ctrl.loginPassword,
                                decoration:
                                    decorationTextBox(label: 'Password'),
                                obscureText: true,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10),
                              CupertinoButton(
                                color: Theme.of(context).colorScheme.secondary,
                                onPressed: () async {
                                  // validating the details entered
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();

                                    if (ctrl.loginEmail.text == "admin") {
                                      if (ctrl.loginPassword.text ==
                                          "rootAdmin") {
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: ((context) =>
                                                    const AdminHome())));
                                      }
                                    }
                                    // Log the user in
                                    else {
                                      await ctrl.signIn(context);
                                      if (ctrl
                                          .auth.currentUser!.uid.isNotEmpty) {
                                        ctrl.loginEmail.clear();
                                        ctrl.loginPassword.clear();
                                      }
                                    }
                                  }
                                },
                                child: const Text("Login"),
                              )
                            ]))),
              )),
        ),
        bottomNavigationBar:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text("Don't have a account? "),
          CupertinoButton(
              child: const Text("SignUp"),
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (ctx) => const Registerpage(),
                ));
              })
        ]));
  }
}
