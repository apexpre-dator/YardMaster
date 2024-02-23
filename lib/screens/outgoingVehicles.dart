import 'package:flutter/material.dart';
import 'package:yms/methods/firestore_methods.dart';
import 'package:yms/models/driver_model.dart';
import 'package:yms/models/vehicle_model.dart';
import 'package:yms/widgets/custom_display.dart';
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

  bool _isLoading = false;
  late DriverModel driver;
  late Vehicle? vehicle;
  bool _checkOut = false;

  void loadData() {}

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      _isLoading = true;
    });
    vehicle = await FirestoreMethods().getOutgoingVehicle(widget.vRegNo);
    if (vehicle != null) {
      driver = await FirestoreMethods().getDriver(vehicle!.dId);
    } else {
      setState(() {
        _checkOut = true;
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  void exitYard(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    vehicle!.destination = addressDestinationController.text;
    vehicle!.timeOut = DateTime.now().toIso8601String();

    String res = await FirestoreMethods().exitYard(vehicle!);

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
        _checkOut = true;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    addressDestinationController.dispose();
    timeOutgoing.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vehicle Outgoing"),
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 25,
                  ),
                  Text('Retrieving Vehicle Data...')
                ],
              ),
            )
          : _checkOut
              ? SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        // alignment: Alignment.center,
                        height: 250,
                        width: 250,
                        child:
                            Image.asset(fit: BoxFit.contain, 'assets/done.gif'),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      const Text('Checked-Out Successfully!'),
                      const SizedBox(
                        height: 25,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).popAndPushNamed('/home');
                          },
                          child: const Text('Return Home'))
                    ],
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
                        exitYard(context);
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
                vehicle!.photoUrl,
                width: 150,
                height: 150,
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const CustomDisplay(title: 'Vehicle Number'),
            TextDisplay(
              hint: vehicle!.vNo,
            ),
            const CustomDisplay(title: 'Vehicle Weight (MT)'),
            TextDisplay(
              hint: vehicle!.vWeight,
            ),
            const CustomDisplay(title: 'Vehicle Model'),
            TextDisplay(
              hint: vehicle!.vModel,
            ),
            const CustomDisplay(title: 'Accompanied Personnel'),
            TextDisplay(
              hint: vehicle!.persons,
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
            // Container(
            //   alignment: Alignment.centerLeft,
            //   height: 150,
            //   width: double.infinity,
            //   child: Image.network(
            //     driver.photoUrl,
            //     width: 150,
            //     height: 150,
            //     fit: BoxFit.fill,
            //   ),
            // ),
            const SizedBox(
              height: 10,
            ),
            const CustomDisplay(title: 'Driver Name'),
            TextDisplay(
              hint: driver.dName,
            ),
            const CustomDisplay(title: 'Driving License Number'),
            TextDisplay(
              hint: driver.dlNo,
            ),
            const CustomDisplay(title: 'Identification Number'),
            TextDisplay(
              hint: driver.dId,
            ),
            const CustomDisplay(title: 'Phone Number'),
            TextDisplay(
              hint: driver.phone,
            ),
            const CustomDisplay(title: 'Address'),
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
            const CustomDisplay(title: 'Objective'),
            TextDisplay(
              hint: vehicle!.objective,
            ),
            const CustomDisplay(title: 'Incoming Time'),
            TextDisplay(
              hint: TimeOfDay.fromDateTime(DateTime.parse(vehicle!.timeIn))
                  .format(context),
            ),
            // const CustomDisplay(title: 'Source Address'),
            // TextDisplay(
            //   hint: vehicle.source,
            // ),
            const CustomDisplay(title: 'Vehicle Weight'),
            const SizedBox(height: 10),
            CustomInput(
              controller: outgoingWeight,
              hint: 'Enter Outgoing Weight (Metric Tons)',
              inputBorder: const OutlineInputBorder(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: timeOutgoing, //editing controller of this TextField
                decoration: const InputDecoration(
                    icon: Icon(Icons.timer),
                    border: InputBorder.none, //icon of text field
                    labelText: "Select Outgoing Time" //label text of field
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
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: TextField(
                maxLines: 2,
                minLines: 1,
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
