import 'dart:io';

import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:yms/methods/firestore_methods.dart';
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
  final TextEditingController timeIncoming = TextEditingController();
  bool registered = false;
  File? vehicleImage;
  File? driverPic;
  String? parkingLot;
  String? yardNo;
  bool _isLoading = false;

  late Driver driver;
  late Vehicle vehicle;
  final String vRegNo = const Uuid().v1();

  Future pickImage(bool flag) async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() {
        vehicleImage = imageTemp;
      });
      setState(() {
        if (flag) {
          vehicleImage = imageTemp;
        } else {
          driverPic = imageTemp;
        }
      });
    } catch (e) {
      print('Failed to pick image: $e');
    }
  }

  void registerVehicle(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
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
      vRegNo: vRegNo,
      photoUrl: "",
    );
    vehicle = Vehicle(
        regNo: vRegNo,
        vNo: vNoController.text,
        vWeight: vWeightController.text,
        vModel: vModelController.text,
        persons: personsController.text,
        dId: driver.dId,
        objective: objectiveController.text,
        dockNo: "1",
        lotNo: "1",
        timeIn: DateTime.now().toIso8601String(),
        timeOut: DateTime.now().toIso8601String(),
        source: sourceController.text,
        destination: "",
        photoUrl: "");

    final res = await FirestoreMethods()
        .registerVehicle(vehicle, driver, vehicleImage, driverPic);

    setState(() {
      _isLoading = false;
    });

    print(res);

    if (res != "success") {
      SnackBar snackBar = SnackBar(
        content: Text(res),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      setState(() {
        registered = true;
      });
    }
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
    timeIncoming.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Vehicle Registration"),
          centerTitle: true,
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : registered
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
                        bool isLastStep =
                            (currentStep == getSteps().length - 1);
                        if (isLastStep) {
                          FocusScope.of(context).unfocus();
                          registerVehicle(context);
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

  void setParkingLot(String? val) {
    setState(() {
      parkingLot = val;
    });
  }

  void setYardNo(String? val) {
    setState(() {
      yardNo = val;
    });
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
                      crossAxisAlignment: CrossAxisAlignment.center,
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
            IntlPhoneField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(
                  borderSide: BorderSide(),
                ),
              ),
              initialCountryCode: 'IN',
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: TextField(
                maxLines: 5,
                minLines: 3,
                controller: addressController,
                onSubmitted: (v) {},
                decoration: const InputDecoration(
                  hintText: 'Address',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
      Step(
        state: currentStep > 2 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 2,
        title: const Text("Checking In"),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black45),
                  borderRadius: const BorderRadius.all(Radius.circular(5))),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              child: const Text(
                'Objective -',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            CustomRadioButton(
              horizontal: true,
              enableShape: true,
              defaultSelected: 'Loading',
              elevation: 0,
              unSelectedColor: Theme.of(context).canvasColor,
              buttonLables: const [
                'Loading',
                'Unloading',
                'Both',
              ],
              buttonValues: const [
                "Loading",
                "Unloading",
                "Both",
              ],
              buttonTextStyle: const ButtonTextStyle(
                selectedColor: Colors.white,
                unSelectedColor: Colors.black,
                textStyle: TextStyle(fontSize: 16),
              ),
              radioButtonValue: (value) {
                print(value);
              },
              selectedColor: Theme.of(context).accentColor,
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: TextField(
                maxLines: 5,
                minLines: 3,
                controller: sourceController,
                onSubmitted: (v) {},
                decoration: const InputDecoration(
                  hintText: 'Source Address',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            TextField(
              controller: timeIncoming, //editing controller of this TextField
              decoration: InputDecoration(
                  icon: Icon(Icons.timer), //icon of text field
                  labelText: "Enter Time" //label text of field
                  ),
              readOnly:
                  true, //set it true, so that user will not able to edit text
              onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  initialTime: TimeOfDay.now(),
                  context: context,
                );

                if (pickedTime != null) {
                  print(pickedTime.format(context));
                  setState(() {
                    timeIncoming.text = pickedTime.format(context);
                  });
                } else {
                  print("Time is not selected");
                }
              },
            ),
            // Container(
            //   margin: const EdgeInsets.all(5),
            //   child: CustomDropdownButton2(
            //     dropdownWidth: MediaQuery.of(context).size.width - 80,
            //     buttonWidth: double.infinity,
            //     hint: 'Select Parking Lot',
            //     value: parkingLot,
            //     dropdownItems: const ['1', '2', '3', '4', '5'],
            //     onChanged: setParkingLot,
            //   ),
            // ),
            // Container(
            //   margin: const EdgeInsets.all(5),
            //   child: CustomDropdownButton2(
            //     dropdownWidth: MediaQuery.of(context).size.width - 80,
            //     buttonWidth: double.infinity,
            //     hint: 'Select Yard No',
            //     value: yardNo,
            //     dropdownItems: const ['1', '2', '3', '4', '5'],
            //     onChanged: setYardNo,
            //   ),
            // ),
          ],
        ),
      ),
    ];
  }
}
