import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel_app/Models-and-Functions/controller/authcontroller.dart';
import 'package:travel_app/Models-and-Functions/user_model.dart';
import 'package:travel_app/admin&trave_agency/agency/agency_home.dart';
import 'package:travel_app/screens/home/home_screen.dart';
import 'package:travel_app/screens/login-register/login_screen.dart';
import 'package:uuid/uuid.dart';
import 'firebase_options.dart';

var uuid = const Uuid();
final ctrl = Get.put(AuthController());
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  User? currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    UserModel thisuserModel =
        await AuthController().getUserModelById(currentUser.uid);
    runApp(IfLogged(
      thisUserModel: thisuserModel,
      currentUser: currentUser,
    ));
  } else {
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: const LoginPage(),
    );
  }
}

class IfLogged extends StatelessWidget {
  final UserModel thisUserModel;
  final User currentUser;
  const IfLogged({
    super.key,
    required this.thisUserModel,
    required this.currentUser,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        home: thisUserModel.type == "user"
            ? HomeScreen(
                thisUserModel: thisUserModel,
                currentUser: currentUser,
              )
            : Agencymainpage(thisAgency: thisUserModel));
  }
}
