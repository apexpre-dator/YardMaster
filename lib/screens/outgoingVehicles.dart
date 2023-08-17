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
  late Driver driver;
  late Vehicle vehicle;
  bool _checkOut = false;

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

  void exitYard() async {
    setState(() {
      _isLoading = true;
    });
    vehicle.destination = addressDestinationController.text;
    vehicle.timeOut = DateTime.now().toIso8601String();

    String res = await FirestoreMethods().exitYard(vehicle);

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
            : _checkOut
                ? Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          // alignment: Alignment.center,
                          height: 250,
                          width: 250,
                          child: Image.network(
                              fit: BoxFit.contain,
                              "https://static.vecteezy.com/system/resources/previews/022/068/737/non_2x/approved-sign-and-symbol-clip-art-free-png.png"),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Text('Checked-Out Successfully!'),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).popAndPushNamed('/');
                            },
                            child: Text('Back to Home'))
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
                        bool isLastStep =
                            (currentStep == getSteps().length - 1);
                        if (isLastStep) {
                          FocusScope.of(context).unfocus();
                          exitYard();
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
            CustomDisplay(title: 'Vehicle Number'),
            TextDisplay(
              hint: vehicle.vNo,
            ),
            CustomDisplay(title: 'Vehicle Weight (MT)'),
            TextDisplay(
              hint: vehicle.vWeight,
            ),
            CustomDisplay(title: 'Vehicle Model'),
            TextDisplay(
              hint: vehicle.vModel,
            ),
            CustomDisplay(title: 'Accompanied Personnel'),
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
            CustomDisplay(title: 'Driver Name'),
            TextDisplay(
              hint: driver.dName,
            ),
            CustomDisplay(title: 'Driving License Number'),
            TextDisplay(
              hint: driver.dlNo,
            ),
            CustomDisplay(title: 'Identification Number'),
            TextDisplay(
              hint: driver.dId,
            ),
            CustomDisplay(title: 'Phone Number'),
            TextDisplay(
              hint: driver.phone,
            ),
            CustomDisplay(title: 'Address'),
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
            CustomDisplay(title: 'Objective'),
            TextDisplay(
              hint: vehicle.objective,
            ),
            CustomDisplay(title: 'Incoming Time'),
            TextDisplay(
              hint: TimeOfDay.fromDateTime(DateTime.parse(vehicle.timeIn))
                  .format(context),
            ),
            CustomDisplay(title: 'Source Address'),
            TextDisplay(
              hint: vehicle.source,
            ),
            CustomDisplay(title: 'Vehicle Weight'),
            const SizedBox(height: 10),
            CustomInput(
              controller: outgoingWeight,
              hint: 'Enter Outgoing Weight (Metric Tons)',
              inputBorder: const OutlineInputBorder(),
            ),
            TextField(
              controller: timeOutgoing, //editing controller of this TextField
              decoration: const InputDecoration(
                  icon: Icon(Icons.timer), //icon of text field
                  labelText: "Enter Outgoing Time" //label text of field
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
