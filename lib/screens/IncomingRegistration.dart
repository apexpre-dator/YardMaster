import 'dart:io';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:yms/custom.dart';
import 'package:yms/models/driver_model.dart';
import 'package:yms/models/vehicle_model.dart';
import 'package:yms/widgets/custom_input.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:image_picker/image_picker.dart';

class IncomingRegistration extends StatefulWidget {
  static const routeName = '/incoming-registration';
  const IncomingRegistration({super.key});

  @override
  State<IncomingRegistration> createState() => _IncomingRegistrationState();
}

class _IncomingRegistrationState extends State<IncomingRegistration> {
  int currentStep = 0;
  final TextEditingController vNoController = TextEditingController();
  final TextEditingController vWeightController = TextEditingController();
  final TextEditingController vModelController = TextEditingController();
  final TextEditingController personsController = TextEditingController();
  final TextEditingController objectiveController = TextEditingController();
  final TextEditingController sourceController = TextEditingController();
  final TextEditingController dIdController = TextEditingController();
  final TextEditingController dNameController = TextEditingController();
  final TextEditingController dlNoController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  bool registered = false;
  File? vehicleImage;
  File? driverPic;

  late Driver driver;
  late Vehicle vehicle;
  final String vRegNo = const Uuid().v1();

  Future pickImage(bool flag) async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => flag ? vehicleImage : driverPic = imageTemp);
    } catch (e) {
      print('Failed to pick image: $e');
    }
  }

  void registerVehicle(BuildContext context) {
    if (vModelController.text.isEmpty ||
        vNoController.text.isEmpty ||
        vWeightController.text.isEmpty ||
        personsController.text.isEmpty ||
        objectiveController.text.isEmpty ||
        sourceController.text.isEmpty ||
        dIdController.text.isEmpty ||
        dNameController.text.isEmpty ||
        dlNoController.text.isEmpty ||
        addressController.text.isEmpty ||
        phoneController.text.isEmpty) {
      const snackBar = SnackBar(
        content: Text('Please fill in all the fields correctly!'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    driver = Driver(
        dId: dIdController.text,
        dName: dNameController.text,
        dlNo: dlNoController.text,
        phone: phoneController.text,
        address: addressController.text,
        vRegNo: vRegNo);
    vehicle = Vehicle(
      regNo: vRegNo,
      vNo: vNoController.text,
      vWeight: vWeightController.text,
      vModel: vModelController.text,
      persons: personsController.text,
      driver: driver,
      objective: objectiveController.text,
      dockNo: 1,
      lotNo: 1,
      timeIn: DateTime.now(),
      timeOut: DateTime.now(),
      source: sourceController.text,
      destination: "",
    );

    vehicles.add(vehicle);
    setState(() {
      registered = true;
    });
  }

  @override
  void dispose() {
    super.dispose();
    vNoController.dispose();
    vWeightController.dispose();
    vModelController.dispose();
    personsController.dispose();
    objectiveController.dispose();
    sourceController.dispose();
    dIdController.dispose();
    dNameController.dispose();
    dlNoController.dispose();
    addressController.dispose();
    phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Vehicle Registration"),
          centerTitle: true,
        ),
        body: registered
            ? Container(
                height: MediaQuery.of(context).size.height - 10,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 45,
                      ),
                      const Text(
                        'Vehicle Registered Successfully!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      Center(
                        child: QrImageView(
                          data: vRegNo,
                          version: QrVersions.auto,
                          size: 320,
                          gapless: false,
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      const Text('QR sent to Driver\'s Dashboard'),
                      const SizedBox(
                        height: 45,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).popAndPushNamed('/');
                        },
                        child: const Text('Home'),
                      ),
                    ],
                  ),
                ),
              )
            : Container(
                padding: const EdgeInsets.all(10),
                child: Stepper(
                  type: StepperType.horizontal,
                  currentStep: currentStep,
                  onStepCancel: () => currentStep == 0
                      ? Navigator.of(context).pop()
                      : setState(() {
                          currentStep -= 1;
                        }),
                  onStepContinue: () {
                    bool isLastStep = (currentStep == getSteps().length - 1);
                    if (isLastStep) {
                      FocusScope.of(context).unfocus();
                      registerVehicle(context);
                      print('here');
                      // setState(() {
                      //   registered = false;
                      // });
                    } else {
                      setState(() {
                        currentStep += 1;
                      });
                    }
                  },
                  onStepTapped: (step) => setState(() {
                    currentStep = step;
                  }),
                  steps: getSteps(),
                )),
      ),
    );
  }

  List<Step> getSteps() {
    return <Step>[
      Step(
        state: currentStep > 0 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 0,
        title: const Text("Vehicle"),
        content: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              height: 150,
              width: double.infinity,
              child: vehicleImage != null
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.file(
                          vehicleImage!,
                          width: 150,
                          height: 150,
                          fit: BoxFit.fill,
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              vehicleImage = null;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.redAccent, // Background color
                          ),
                          child: const Text('Delete'),
                        ),
                      ],
                    )
                  : Row(
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/dummy.png',
                          width: 150,
                          height: 150,
                          fit: BoxFit.fill,
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await pickImage(true);
                          },
                          child: const Text('Upload'),
                        ),
                      ],
                    ),
            ),
            const SizedBox(
              height: 10,
            ),
            CustomInput(
              hint: "Vehicle Number",
              inputBorder: const OutlineInputBorder(),
              controller: vNoController,
            ),
            CustomInput(
              hint: "Vehicle Weight",
              inputBorder: const OutlineInputBorder(),
              controller: vWeightController,
            ),
            CustomInput(
              hint: "Vehicle Model",
              inputBorder: const OutlineInputBorder(),
              controller: vModelController,
            ),
            CustomInput(
              hint: "Accompanied Personnel",
              inputBorder: const OutlineInputBorder(),
              controller: personsController,
            ),
          ],
        ),
      ),
      Step(
        state: currentStep > 1 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 1,
        title: const Text("Driver"),
        content: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              height: 150,
              width: double.infinity,
              child: driverPic != null
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.file(
                          driverPic!,
                          width: 150,
                          height: 150,
                          fit: BoxFit.fill,
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              driverPic = null;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.redAccent, // Background color
                          ),
                          child: const Text('Delete'),
                        ),
                      ],
                    )
                  : Row(
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/dummy.png',
                          width: 150,
                          height: 150,
                          fit: BoxFit.fill,
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await pickImage(false);
                          },
                          child: const Text('Upload'),
                        ),
                      ],
                    ),
            ),
            const SizedBox(
              height: 10,
            ),
            CustomInput(
              hint: "Driver Name",
              inputBorder: const OutlineInputBorder(),
              controller: dNameController,
            ),
            CustomInput(
              hint: "License Number",
              inputBorder: const OutlineInputBorder(),
              controller: dlNoController,
            ),
            CustomInput(
              hint: "Identification Number",
              inputBorder: const OutlineInputBorder(),
              controller: dIdController,
            ),
            CustomInput(
              hint: "Phone Number",
              inputBorder: const OutlineInputBorder(),
              controller: phoneController,
            ),
            CustomInput(
              hint: "Address",
              inputBorder: const OutlineInputBorder(),
              controller: addressController,
            ),
          ],
        ),
      ),
      Step(
        state: currentStep > 2 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 2,
        title: const Text("Checking In"),
        content: Column(
          children: [
            CustomInput(
              hint: "Objective",
              inputBorder: const OutlineInputBorder(),
              controller: objectiveController,
            ),
            // CustomInput(
            //   hint: "Parking Lot",
            //   inputBorder: OutlineInputBorder(),
            //   controller: lotNoController,
            // ),
            // CustomInput(
            //   hint: "Dock Number",
            //   inputBorder: OutlineInputBorder(),
            //   controller: dockNoController,
            // ),
            CustomInput(
              hint: "Source Address",
              inputBorder: const OutlineInputBorder(),
              controller: sourceController,
            ),
          ],
        ),
      ),
    ];
  }
}
