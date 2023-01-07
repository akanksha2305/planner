import 'package:planner/constants/constants.dart';
import 'package:planner/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:planner/pages/home.dart';
import 'package:planner/pages/onBoard.dart';
import 'package:planner/helper/helperFunctions.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: Constants.apiKey,
            appId: Constants.appId,
            messagingSenderId: Constants.messagingSenderId,
            projectId: Constants.projectId));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSignedIn = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getUserLoggedInStatus();
  }

  getUserLoggedInStatus() async {
    await HelperFunctions.getUserLoggedInStatus().then((value) {
      setState(() {
        _isSignedIn = value!;
      });
    });
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Event Planning App',
      theme: ThemeData(
        primaryColor: Constants.primaryColor,
      ),
      home: _isSignedIn ? const Home() : const Login(),
    );
  }
}
