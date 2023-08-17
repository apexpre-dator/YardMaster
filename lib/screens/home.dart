import 'package:flutter/material.dart';
import 'package:yms/screens/incomingRegistration.dart';
import 'package:yms/screens/outgoingVehicles.dart';
import 'package:yms/screens/qr_scan.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Yard Management System"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
          height: MediaQuery.of(context).size.height - 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  print('here');
                  Navigator.of(context)
                      .pushNamed(IncomingRegistration.routeName);
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                    color: Colors.black54,
                    width: 3,
                  )),
                  height: 180,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('assets/incoming.gif'),
                      const Text(
                        'Incoming',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  // Navigator.of(context)
                  //               .pushNamed(QRViewExample.routeName);
                  // Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => OutgoingRegistration(
                        vRegNo: "e68615c0-3c63-11ee-a167-893336dfd0f6"),
                  ));
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                    color: Colors.black54,
                    width: 3,
                  )),
                  height: 180,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('assets/outgoing.gif'),
                      const Text(
                        'Outgoing',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
