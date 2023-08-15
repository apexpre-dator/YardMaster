import 'package:flutter/material.dart';

class OutgoingRegistration extends StatefulWidget {
  static const routeName = '/outgoing-registration';
  const OutgoingRegistration({super.key});

  @override
  State<OutgoingRegistration> createState() => _OutgoingRegistrationState();
}

class _OutgoingRegistrationState extends State<OutgoingRegistration> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicle Outgoing'),
        centerTitle: true,
      ),
      body: Center(
        child: Text('Scan QR'),
      ),
    );
  }
}