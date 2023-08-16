import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:yms/methods/firestore_methods.dart';
import 'package:yms/models/driver_model.dart';
import 'package:yms/models/vehicle_model.dart';
import 'package:yms/screens/qr_scan.dart';
import 'package:yms/widgets/custom_input.dart';
import 'package:yms/widgets/text_display.dart';

class OutgoingRegistration extends StatefulWidget {
  final String vRegNo;
  static const routeName = '/outgoing-registration';

  const OutgoingRegistration({super.key, required this.vRegNo});

  @override
  State<OutgoingRegistration> createState() => _OutgoingRegistrationState();
}

class _OutgoingRegistrationState extends State<OutgoingRegistration> {
  int currentStep = 0;
  final TextEditingController addressDestinationController =
      TextEditingController();
  final TextEditingController outgoingWeight = TextEditingController();
  final TextEditingController timeOutgoing = TextEditingController();
  // String? vRegno;

  bool _isLoading = false;
  // String? vehicleImage;
  // String? driverPic;
  // String? vehicleNumber;
  // String? incomingWeight;
  // String? vehicleModel;
  // String? accompaniedPersonnel;
  // String? driverName;
  // String? licenseNumber;
  // String? identificationNumber;
  // String? phoneNumber;
  // String? driverAddress;
  // String? objective;
  // String? timeIn;
  // String? sourceAddress;
  late Driver driver;
  late Vehicle vehicle;
  // final String vRegNo = const Uuid().v1();

  void loadData() {}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      _isLoading = true;
    });
    vehicle = await FirestoreMethods().getVehicle(widget.vRegNo);
    driver = await FirestoreMethods().getDriver(vehicle.dId);

    setState(() {
      _isLoading = false;
    });
  }

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
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
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
                vehicle.photoUrl,
                width: 150,
                height: 150,
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextDisplay(
              hint: vehicle.vNo,
            ),
            TextDisplay(
              hint: vehicle.vWeight,
            ),
            TextDisplay(
              hint: vehicle.vModel,
            ),
            TextDisplay(
              hint: vehicle.persons,
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
                driver.photoUrl,
                width: 150,
                height: 150,
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextDisplay(
              hint: driver.dName,
            ),
            TextDisplay(
              hint: driver.dlNo,
            ),
            TextDisplay(
              hint: driver.dId,
            ),
            TextDisplay(
              hint: driver.phone,
            ),
            TextDisplay(
              hint: driver.address,
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
              hint: vehicle.objective,
            ),
            TextDisplay(
              hint: vehicle.timeIn,
            ),
            TextDisplay(
              hint: vehicle.source,
            ),
            CustomInput(
              controller: outgoingWeight,
              hint: 'Enter Outgoing Weight (Metric Tons)',
              inputBorder: const OutlineInputBorder(),
            ),
            TextField(
              controller: timeOutgoing, //editing controller of this TextField
              decoration: const InputDecoration(
                  icon: Icon(Icons.timer), //icon of text field
                  labelText: "Enter Exit Time" //label text of field
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
                  hintText: 'Enter Destination Address',
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
