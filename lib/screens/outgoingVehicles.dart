import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:yms/models/driver_model.dart';
import 'package:yms/models/vehicle_model.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:yms/widgets/custom_input.dart';
import 'package:yms/widgets/text_display.dart';

class OutgoingRegistration extends StatefulWidget {
  static const routeName = '/outgoing-registration';
  const OutgoingRegistration({super.key});

  @override
  State<OutgoingRegistration> createState() => _OutgoingRegistrationState();
}

class _OutgoingRegistrationState extends State<OutgoingRegistration> {
  int currentStep = 0;
  final TextEditingController addressDestinationController =
      TextEditingController();
  final TextEditingController outgoingWeight = TextEditingController();
  final TextEditingController timeOutgoing = TextEditingController();
  bool verify = false;
  String? vehicleImage;
  String? driverPic;
  String? vehicleNumber;
  String? incomingWeight;
  String? vehicleModel;
  String? accompaniedPersonnel;
  String? driverName;
  String? licenseNumber;
  String? identificationNumber;
  String? phoneNumber;
  String? driverAddress;
  String? objective;
  String? timeIn;
  String? sourceAddress;
  late Driver driver;
  late Vehicle vehicle;
  final String vRegNo = const Uuid().v1();

  void loadData() {}

  @override
  void dispose() {
    super.dispose();
    addressDestinationController.dispose();
    timeOutgoing.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Vehicle Outgoing"),
          centerTitle: true,
        ),
        body: verify
            ? Container(
                height: MediaQuery.of(context).size.height - 10,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //Implement scan QR code UI and set verify to false after verification and loading data
                      //default verify will be true
                      // const SizedBox(
                      //   height: 45,
                      // ),
                      // const Text(
                      //   'Vehicle Registered Successfully!',
                      //   style: TextStyle(
                      //     fontSize: 20,
                      //     fontWeight: FontWeight.w600,
                      //   ),
                      // ),
                      // const SizedBox(
                      //   height: 35,
                      // ),
                      // Center(
                      //   child: QrImageView(
                      //     data: vRegNo,
                      //     version: QrVersions.auto,
                      //     size: 320,
                      //     gapless: false,
                      //   ),
                      // ),
                      // const SizedBox(
                      //   height: 25,
                      // ),
                      // const Text('QR sent to Driver\'s Dashboard'),
                      // const SizedBox(
                      //   height: 45,
                      // ),
                      // ElevatedButton(
                      //   onPressed: () {
                      //     Navigator.of(context).popAndPushNamed('/');
                      //   },
                      //   child: const Text('Home'),
                      // ),
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
                      //vehicle gone out deregister
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
              child: Image.network(
                vehicleImage!,
                width: 150,
                height: 150,
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextDisplay(
              hint: vehicleNumber,
            ),
            TextDisplay(
              hint: incomingWeight,
            ),
            TextDisplay(
              hint: vehicleModel,
            ),
            TextDisplay(
              hint: accompaniedPersonnel,
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
              child: Image.network(
                driverPic!,
                width: 150,
                height: 150,
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextDisplay(
              hint: driverName,
            ),
            TextDisplay(
              hint: licenseNumber,
            ),
            TextDisplay(
              hint: identificationNumber,
            ),
            TextDisplay(
              hint: phoneNumber,
            ),
            TextDisplay(
              hint: driverAddress,
            ),
          ],
        ),
      ),
      Step(
        state: currentStep > 2 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 2,
        title: const Text("Checking Out"),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextDisplay(
              hint: objective,
            ),
            TextDisplay(
              hint: timeIn,
            ),
            TextDisplay(
              hint: sourceAddress,
            ),
            CustomInput(
              controller: outgoingWeight,
              hint: 'Outgoing Weight',
              inputBorder: const OutlineInputBorder(),
            ),
            TextField(
              controller: timeOutgoing, //editing controller of this TextField
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
                    timeOutgoing.text = pickedTime.format(context);
                  });
                } else {
                  print("Time is not selected");
                }
              },
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: TextField(
                maxLines: 5,
                minLines: 3,
                controller: addressDestinationController,
                onSubmitted: (v) {},
                decoration: const InputDecoration(
                  hintText: 'Destination Address',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    ];
  }
}
