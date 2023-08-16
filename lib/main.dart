import 'package:flutter/material.dart';
import 'package:yms/screens/outgoing.dart';
import 'package:yms/screens/home.dart';
import 'package:yms/screens/incomingRegistration.dart';

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
        home: const HomeScreen(),
        routes: {
          OutgoingRegistration.routeName: (context) =>
              const OutgoingRegistration(),
          IncomingRegistration.routeName: (context) => IncomingRegistration(),
        });
  }
}
