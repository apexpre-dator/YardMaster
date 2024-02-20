import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yms/methods/firestore_methods.dart';
import 'package:yms/models/driver_model.dart';
import 'package:yms/models/vehicle_model.dart';
import '../widgets/driver_history.dart';

class DriverHistoryScreen extends StatefulWidget {
  const DriverHistoryScreen({super.key});
  static const routeName = '/driver-history';

  @override
  State<DriverHistoryScreen> createState() => _DriverHistoryScreenState();
}

class _DriverHistoryScreenState extends State<DriverHistoryScreen> {
  List<Vehicle> v = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      _isLoading = true;
    });
    DriverModel driver = await FirestoreMethods()
        .getDriver(FirebaseAuth.instance.currentUser!.uid);
    v = await FirestoreMethods().getDriverVehicles(driver.dlNo);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: _isLoading
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 25,
                    ),
                    Text('Retrieving Data...')
                  ],
                ),
              )
            : v.isEmpty
                ? Container(
                    margin: const EdgeInsets.all(30),
                    alignment: Alignment.center,
                    child: const Text(
                      'No Records Found',
                      style: TextStyle(fontSize: 20),
                    ),
                  )
                : Container(
                    margin: const EdgeInsets.all(10),
                    child: Column(
                      children: List.generate(
                          v.length, (index) => DriverHistoryCard(v: v[index])),
                    ),
                  ),
      ),
    );
  }
}
