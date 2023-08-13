import 'package:flutter/material.dart';
import 'package:yms/widgets/custom_input.dart';

class IncomingRegistration extends StatefulWidget {
  static const routeName = '/incoming-registration';
  IncomingRegistration({super.key});

  @override
  State<IncomingRegistration> createState() => _IncomingRegistrationState();
}

class _IncomingRegistrationState extends State<IncomingRegistration> {
  int currentStep = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Yard Management System"),
          centerTitle: true,
        ),
        body: Container(
            padding: const EdgeInsets.all(10),
            child: Stepper(
              type: StepperType.horizontal,
              currentStep: currentStep,
              onStepCancel: () => currentStep == 0
                  ? null
                  : setState(() {
                      currentStep -= 1;
                    }),
              onStepContinue: () {
                bool isLastStep = (currentStep == getSteps().length - 1);
                if (isLastStep) {
                  //Do something with this information
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
          children: const [
            CustomInput(
              hint: "Vehicle Number",
              inputBorder: OutlineInputBorder(),
            ),
            CustomInput(
              hint: "Vehicle Weight",
              inputBorder: OutlineInputBorder(),
            ),
            CustomInput(
              hint: "Vehicle Model",
              inputBorder: OutlineInputBorder(),
            ),
            CustomInput(
              hint: "Accompanied Personnel",
              inputBorder: OutlineInputBorder(),
            ),
          ],
        ),
      ),
      Step(
        state: currentStep > 1 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 1,
        title: const Text("Driver"),
        content: Column(
          children: const [
            CustomInput(
              hint: "Driver Name",
              inputBorder: OutlineInputBorder(),
            ),
            CustomInput(
              hint: "License Number",
              inputBorder: OutlineInputBorder(),
            ),
            CustomInput(
              hint: "Identification Number",
              inputBorder: OutlineInputBorder(),
            ),
            CustomInput(
              hint: "Phone Number",
              inputBorder: OutlineInputBorder(),
            ),
            CustomInput(
              hint: "Address",
              inputBorder: OutlineInputBorder(),
            ),
          ],
        ),
      ),
      Step(
        state: currentStep > 2 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 2,
        title: const Text("Checking In"),
        content: Column(
          children: const [
            CustomInput(
              hint: "Objective",
              inputBorder: OutlineInputBorder(),
            ),
            CustomInput(
              hint: "Parking Lot",
              inputBorder: OutlineInputBorder(),
            ),
            CustomInput(
              hint: "Dock Number",
              inputBorder: OutlineInputBorder(),
            ),
            CustomInput(
              hint: "Entry Time",
              inputBorder: OutlineInputBorder(),
            ),
            CustomInput(
              hint: "Source Destination",
              inputBorder: OutlineInputBorder(),
            ),
          ],
        ),
      ),
    ];
  }
}
