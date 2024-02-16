import 'package:flutter/material.dart';
import '../widgets/driver_history.dart';

class DriverHistoryScreen extends StatefulWidget {
  const DriverHistoryScreen({super.key});
  static const routeName = '/driver-history';

  @override
  State<DriverHistoryScreen> createState() => _DriverHistoryScreenState();
}

class _DriverHistoryScreenState extends State<DriverHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              DriverHistoryCard(),
              DriverHistoryCard(),
              DriverHistoryCard(),
              DriverHistoryCard(),
            ],
          ),
        ),
      ),
    );
  }
}
