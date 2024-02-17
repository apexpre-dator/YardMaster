import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:yms/colours.dart';
import 'package:yms/firebase_options.dart';
import 'package:yms/screens/driver_history.dart';
import 'package:yms/screens/driver_home.dart';
import 'package:yms/screens/outgoingVehicles.dart';
import 'package:yms/screens/home.dart';
import 'package:yms/screens/incomingRegistration.dart';
import 'package:yms/screens/parkingScreen.dart';
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

  // Future<bool> myFunction(String userId) async {
  //   bool flag = true;
  //   final docRef =
  //       await FirebaseFirestore.instance.collection('employees').doc(userId);
  //   docRef.get().then((doc) => {
  //         if (doc.exists) {flag = true} else {flag = false}
  //       });

  //   return flag;
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'YardMaster',
        theme: ThemeData(
          primarySwatch: colorCustom,
        ),
        debugShowCheckedModeBanner: false,
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (_, snapshot) {
            final isSignedIn = snapshot.data != null;
            if (isSignedIn) {

              // Change here to Driver Screen for Driver Login
              return const HomeScreen(); // DriverHomeScreen();
            } else {
              return const MyPhone();
            }
          },
        ),
        //home: DriverHomeScreen(),
        routes: {
          SignUpScreen.routeName: (context) => const SignUpScreen(),
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
          ParkingScreen.routeName: (context) => const ParkingScreen(),
          DriverHomeScreen.routeName: (context) => const DriverHomeScreen(),
          DriverHistoryScreen.routeName: (context) =>
              const DriverHistoryScreen(),
        });
  }
}
