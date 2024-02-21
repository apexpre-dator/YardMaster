import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:yms/methods/firestore_methods.dart';

import '../models/vehicle_model.dart';

class DriverQRScreen extends StatefulWidget {
  const DriverQRScreen({super.key});

  @override
  State<DriverQRScreen> createState() => _DriverQRScreenState();
}

class _DriverQRScreenState extends State<DriverQRScreen> {
  bool _isLoading = false;
  Vehicle? v;

  Future<void> getQR() async {
    setState(() {
      _isLoading = true;
    });
    v = await FirestoreMethods()
        .getCurrentDriverVehicle(FirebaseAuth.instance.currentUser!.uid);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getQR();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
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
          : v == null
              ? Container(
                  margin: const EdgeInsets.all(30),
                  alignment: Alignment.center,
                  child: const Text(
                    'No Vehicle Assigned yet!',
                    style: TextStyle(fontSize: 20),
                  ),
                )
              : Column(
                  children: [
                    // implement logic for checking if QR is generated
                    const Text(
                      'QR Code Generated',
                      style: TextStyle(fontSize: 24),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: QrImageView(
                        data: v!.regNo,
                        version: QrVersions.auto,
                        size: 320,
                        gapless: false,
                      ),
                    ),
                    // Image.asset(
                    //   'assets/QR-Code.png',
                    //   height: MediaQuery.of(context).size.height * 0.4,
                    //   width: MediaQuery.of(context).size.width * 0.8,
                    // ),
                  ],
                ),
    );
  }
}
