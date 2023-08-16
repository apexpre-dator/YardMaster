import 'package:flutter/material.dart';
import 'package:yms/screens/Outgoing.dart';
import 'package:yms/screens/home.dart';
import 'package:yms/screens/IncomingRegistration.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'YMS',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(),
        routes: {
          OutgoingRegistration.routeName: (context) => OutgoingRegistration(),
          IncomingRegistration.routeName: (context) => IncomingRegistration(),
        });
  }
}
