// ignore: file_names
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:yms/methods/firestore_methods.dart';
import 'package:yms/models/vehicle_model.dart';
import 'package:yms/widgets/custom_display.dart';
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
  final TextEditingController dlNoController = TextEditingController();
  final TextEditingController timeIncoming = TextEditingController();

  late String countryName;
  late String? stateName;
  late String? cityName;

  bool registered = false;
  File? vehicleImage;
  File? driverPic;
  String lotNo = (Random().nextInt(8) + 1).toString();
  String dockNo = (Random().nextInt(4) + 1).toString();
  bool _isLoading = false;
  String obj = 'Loading';

  late Vehicle vehicle;
  final String vRegNo = const Uuid().v1();

  Future pickImage(bool flag) async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);

      setState(() {
        if (flag) {
          vehicleImage = imageTemp;
        } else {
          driverPic = imageTemp;
        }
      });
    } catch (e) {}
  }

  void registerVehicle(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    // driver = DriverModel(
    //   dId: dIdController.text,
    //   dName: dNameController.text,
    //   dlNo: dlNoController.text,
    //   phone: phoneController.text,
    //   address: addressController.text,
    // );

    final ref = await FirebaseFirestore.instance
        .collection('drivers')
        .where('dlNo', isEqualTo: dIdController.text)
        .get();

    final allData = ref.docs.map((doc) => doc.data()).toList();
    final driverId = allData[0]['dId'];

    vehicle = Vehicle(
      regNo: vRegNo,
      vNo: vNoController.text,
      vWeight: vWeightController.text,
      vModel: vModelController.text,
      persons: personsController.text,
      dId: driverId,
      objective: obj,
      dockNo: dockNo,
      lotNo: lotNo,
      timeIn: DateTime.now().toIso8601String(),
      // timeOut: null,
      sourceWarehouse: sourceController.text,
      sourceCity: cityName!,
      sourceState: stateName!,
      sourceCountry: countryName,
      // destination: "",
      photoUrl: "",
    );

    final res = await FirestoreMethods()
        .registerVehicle(vehicle, vehicleImage, driverPic);

    await FirebaseFirestore.instance.collection(dockNo).doc(vehicle.vNo).set({
      "vNo": vehicle.vNo,
      "objective": vehicle.objective,
      "dockInTime": null,
      "operationStartTime": null,
      "operationEndTime": null,
      "dockOutTime": null,
      "step": 0,
      "vRegNo": vRegNo,
      "dId": vehicle.dId,
    });

    await FirebaseFirestore.instance
        .collection("dockVehicles")
        .doc(vehicle.vNo)
        .set({
      "vNo": vehicle.vNo,
      "objective": vehicle.objective,
      "step": 0,
      "vRegNo": vRegNo,
    });

    setState(() {
      _isLoading = false;
    });

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
    dlNoController.dispose();
    timeIncoming.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vehicle Registration"),
        centerTitle: true,
        elevation: 0,
        leading: const Icon(
          Icons.menu,
        ),
        actions: const [
          Icon(
            Icons.more_vert,
          ),
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(23),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 20,
                  ),
                  Text('Registering Vehicle, Please wait...')
                ],
              ),
            )
          : registered
              ? SizedBox(
                  height: MediaQuery.of(context).size.height - 10,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                          height: 25,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 5,
                          ),
                          child: Column(
                            children: [
                              const CustomDisplay(
                                  title: "Assigned Parking Lot "),
                              CustomDisplay(title: lotNo),
                              const CustomDisplay(title: "Assigned Dock No "),
                              CustomDisplay(title: dockNo),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).popAndPushNamed('/home');
                              },
                              child: const Text('Print QR'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).popAndPushNamed('/home');
                              },
                              child: const Text('Home'),
                            ),
                          ],
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
    );
  }

  void setParkingLot(String? val) {
    setState(() {
      lotNo = val!;
    });
  }

  void setYardNo(String? val) {
    setState(() {
      dockNo = val!;
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
              hint: "Vehicle Weight (Metric Tons)",
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
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                await pickImage(false);
                              },
                              child: const Text('Upload'),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            ElevatedButton(
                              onPressed: () async {},
                              child: const Text('Scan Id'),
                            ),
                          ],
                        )
                      ],
                    ),
            ),
            const SizedBox(
              height: 10,
            ),
            CustomInput(
              hint: "Id Number",
              inputBorder: const OutlineInputBorder(),
              controller: dIdController,
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
            const CustomDisplay(title: 'Objective'),
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
                setState(() {
                  obj = value;
                });
              },
              selectedColor: Theme.of(context).colorScheme.secondary,
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: TextField(
                maxLines: 2,
                minLines: 1,
                controller: sourceController,
                onSubmitted: (v) {},
                decoration: const InputDecoration(
                  hintText: 'Enter Source Warehouse Name',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            CSCPicker(
              dropdownDecoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300, width: 1)),
              disabledDropdownDecoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.grey.shade300,
                  border: Border.all(color: Colors.grey.shade300, width: 1)),
              countrySearchPlaceholder: "Country",
              stateSearchPlaceholder: "State",
              citySearchPlaceholder: "City",
              countryDropdownLabel: "Country",
              stateDropdownLabel: "State",
              cityDropdownLabel: "City",
              defaultCountry: CscCountry.India,
              selectedItemStyle: const TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
              dropdownHeadingStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.bold),
              dropdownItemStyle: const TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
              dropdownDialogRadius: 10.0,
              searchBarRadius: 10.0,
              onCountryChanged: (value) {
                setState(() {
                  countryName = value;
                });
              },
              onStateChanged: (value) {
                setState(() {
                  stateName = value;
                });
              },
              onCityChanged: (value) {
                setState(() {
                  cityName = value;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: timeIncoming, //editing controller of this TextField
                decoration: const InputDecoration(
                  icon: Icon(Icons.timer), //icon of text field
                  labelText: "Select Incoming Time", //label text of field
                  border: InputBorder.none,
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
            ),
            // const CustomDisplay(title: 'Parking Lot'),
            // Container(
            //   margin: const EdgeInsets.symmetric(
            //     horizontal: 5,
            //     vertical: 10,
            //   ),
            //   child: CustomDropdownButton2(
            //     dropdownWidth: MediaQuery.of(context).size.width - 80,
            //     buttonWidth: double.infinity,
            //     hint: 'Select Parking Lot',
            //     value: lotNo,
            //     dropdownItems: const ['1', '2', '3', '4', '5', '7', '8', '9'],
            //     onChanged: setParkingLot,
            //   ),
            // ),
            // const CustomDisplay(title: 'Dock Number'),
            // Container(
            //   margin: const EdgeInsets.symmetric(
            //     horizontal: 5,
            //     vertical: 10,
            //   ),
            //   child: CustomDropdownButton2(
            //     dropdownWidth: MediaQuery.of(context).size.width - 80,
            //     buttonWidth: double.infinity,
            //     hint: 'Select Dock No',
            //     value: dockNo,
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
