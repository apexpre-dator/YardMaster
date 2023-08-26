import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:yms/firebase_options.dart';
import 'package:yms/screens/outgoingVehicles.dart';
import 'package:yms/screens/home.dart';
import 'package:yms/screens/incomingRegistration.dart';
import 'package:yms/screens/phone.dart';
import 'package:yms/screens/signup.dart';
import 'package:yms/screens/qr_scan.dart';
import 'package:yms/screens/records.dart';
import 'package:yms/screens/verify.dart';
import 'package:yms/screens/yardScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'YardMaster',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: const MyPhone(),
        routes: {
          SignUpScreen.routeName: (context) => SignUpScreen(),
          HomeScreen.routeName: (context) => const HomeScreen(),
          MyPhone.routeName: (context) => const MyPhone(),
          MyVerify.routeName: (context) => const MyVerify(),
          QRViewExample.routeName: (context) => const QRViewExample(),
          OutgoingRegistration.routeName: (context) =>
              const OutgoingRegistration(vRegNo: ""),
          IncomingRegistration.routeName: (context) =>
              const IncomingRegistration(),
          RecordScreen.routeName: (context) => const RecordScreen(),
          YardScreen.routeName: (context) => const YardScreen(),
        });
  }
}
