import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:yms/colours.dart';
import 'package:yms/models/yard_vehicle_model.dart';

class YardScreen extends StatefulWidget {
  const YardScreen({super.key});
  static const routeName = '/yard-screen';

  @override
  State<YardScreen> createState() => _YardScreenState();
}

class _YardScreenState extends State<YardScreen> {
  YardVehicle v = YardVehicle.getData();
  List<String> items = [
    'Not Started',
    'Loading',
    'Unloading',
    'Both',
    'Finished',
  ];
  final TextEditingController timing = TextEditingController();

  void updateStatus(String? val) async {
    setState(() {
      v.step = items.indexOf(val!);
      if (v.step == 1 || v.step == 2 || v.step == 3) {
        v.operationStartTime = timing.text;
      }
      if (v.step == 5) {
        v.operationEndTime = timing.text;
      }
    });
  }

  @override
  void dispose() {
    timing.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CarouselController buttonCarouselController = CarouselController();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              height: 375,
              width: double.infinity,
              child: CarouselSlider(
                items: [1, 2, 3, 4].map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: lightColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Dock No : $i',
                              style: const TextStyle(
                                fontSize: 20,
                                color: darkColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 40,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Vehicles',
                                    style: TextStyle(
                                        color: darkColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Status',
                                    style: TextStyle(
                                        color: darkColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                            StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection(i.toString())
                                  .snapshots(),
                              builder: (context,
                                  AsyncSnapshot<
                                          QuerySnapshot<Map<String, dynamic>>>
                                      snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    final snap =
                                        snapshot.data!.docs[index].data();

                                    return Container(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (dctx) =>
                                                    GiffyDialog.rive(
                                                  const RiveAnimation.network(
                                                    'https://cdn.rive.app/animations/vehicles.riv',
                                                    fit: BoxFit.cover,
                                                    placeHolder: Center(
                                                        child:
                                                            CircularProgressIndicator()),
                                                  ),
                                                  giffyBuilder:
                                                      (context, rive) {
                                                    return ClipRRect(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  20)),
                                                      child: SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.2,
                                                        child: rive,
                                                      ),
                                                    );
                                                  },
                                                  title: Text(
                                                    snap['vNo'],
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  content: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      if (snap['step'] == 0)
                                                        const Text(
                                                            'Vehicle Dock In')
                                                      else if (snap['step'] ==
                                                          1)
                                                        const Text(
                                                            'Start Vehicle Operations')
                                                      else if (snap['step'] ==
                                                          2)
                                                        const Text(
                                                            'End Vehicle Operations')
                                                      else if (snap['step'] ==
                                                          3)
                                                        const Text(
                                                            'Vehicle Dock Out')
                                                      else
                                                        const Text(
                                                            'CheckOut Vehicle from Dock'),
                                                      if (snap['step'] < 4)
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: TextField(
                                                            controller:
                                                                timing, //editing controller of this TextField
                                                            decoration:
                                                                const InputDecoration(
                                                              icon: Icon(Icons
                                                                  .timer), //icon of text field
                                                              labelText:
                                                                  "Select Time", //label text of field
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                            ),
                                                            readOnly:
                                                                true, //set it true, so that user will not able to edit text
                                                            onTap: () async {
                                                              TimeOfDay?
                                                                  pickedTime =
                                                                  await showTimePicker(
                                                                initialTime:
                                                                    TimeOfDay
                                                                        .now(),
                                                                context:
                                                                    context,
                                                              );

                                                              if (pickedTime !=
                                                                  null) {
                                                                print(pickedTime
                                                                    .format(
                                                                        context));
                                                                setState(() {
                                                                  timing.text =
                                                                      pickedTime
                                                                          .format(
                                                                              context);
                                                                });
                                                              } else {
                                                                print(
                                                                    "Time is not selected");
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                  actions: [
                                                    IconButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              dctx, 'CALL'),
                                                      icon: const Icon(
                                                        Icons.phone,
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () async {
                                                        if (snap['step'] == 0) {
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection("1")
                                                              .doc(snap['vNo'])
                                                              .update({
                                                            "dockInTime":
                                                                timing.text,
                                                            "step": 1,
                                                          });
                                                        }
                                                        if (snap['step'] == 1) {
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection("1")
                                                              .doc(snap['vNo'])
                                                              .update({
                                                            "operationStartTime":
                                                                timing.text,
                                                            "step": 2,
                                                          });
                                                        }
                                                        if (snap['step'] == 2) {
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection("1")
                                                              .doc(snap['vNo'])
                                                              .update({
                                                            "operationEndTime":
                                                                timing.text,
                                                            "step": 3,
                                                          });
                                                        }
                                                        if (snap['step'] == 3) {
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection("1")
                                                              .doc(snap['vNo'])
                                                              .update({
                                                            "dockOutTime":
                                                                timing.text,
                                                            "step": 4,
                                                          });
                                                        }
                                                        if (snap['step'] == 4) {
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "checkedOut")
                                                              .doc(snap['vNo'])
                                                              .set({
                                                            "vNO": snap['vNo'],
                                                            "vRegNo":
                                                                snap['vRegNo'],
                                                            "dockInTime": snap[
                                                                'dockInTime'],
                                                            "operationStartTime":
                                                                snap[
                                                                    'operationStartTime'],
                                                            "operationEndTime":
                                                                snap[
                                                                    'operationEndTime'],
                                                            "dockOutTime": snap[
                                                                'dockOutTime'],
                                                          });

                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection("1")
                                                              .doc(snap['vNo'])
                                                              .delete();
                                                        }

                                                        Navigator.pop(
                                                            dctx, 'OK');
                                                      },
                                                      child: Text(
                                                          snap['step'] == 4
                                                              ? 'Check Out'
                                                              : 'OK'),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                left: 25,
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                      height: 75,
                                                      child: Image.asset(
                                                          'assets/truck.png')),
                                                  Text(
                                                    '${snap['vNo']}',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          StepProgressIndicator(
                                            size: 15,
                                            padding: 2,
                                            totalSteps: 4,
                                            currentStep: snap['step'],
                                            selectedColor: Colors.greenAccent,
                                            unselectedColor:
                                                Colors.yellowAccent,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }).toList(),
                carouselController: buttonCarouselController,
                options: CarouselOptions(
                  //autoPlay: true,
                  height: MediaQuery.of(context).size.height * 0.5,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  viewportFraction: 0.9,
                  initialPage: 0,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: true,
                  enlargeStrategy: CenterPageEnlargeStrategy.height,
                  padEnds: true,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 20,
              ),
              child: Column(
                children: [
                  Container(
                    height: 50,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: darkColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'Total Vehicles in Dock',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: lightColor,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                    ),
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection(1.toString())
                          .snapshots(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return Center(
                          child: Text(
                            snapshot.data!.docs.length.toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
