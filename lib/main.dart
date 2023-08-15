import 'package:flutter/material.dart';
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
        home: const MyHomePage(title: 'Yard Management System'),
        routes: {
          HomeScreen.routeName: (context) => HomeScreen(),
          IncomingRegistration.routeName: (context) => IncomingRegistration(),
        });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const HomeScreen();
  }
}
