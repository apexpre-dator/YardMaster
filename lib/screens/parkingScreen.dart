import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:yms/colours.dart';

class ParkingScreen extends StatefulWidget {
  const ParkingScreen({super.key});
  static const routeName = '/parking-screen';

  @override
  State<ParkingScreen> createState() => _ParkingScreenState();
}

class _ParkingScreenState extends State<ParkingScreen> {
  @override
  Widget build(BuildContext context) {
    CarouselController buttonCarouselController = CarouselController();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              child: CarouselSlider(
                items: [1, 2, 3].map((i) {
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
                              'Parking Lot : $i',
                              style: const TextStyle(
                                fontSize: 20,
                                color: darkColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Expanded(
                              child: GridView.builder(
                                itemCount: 9,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (_) => GiffyDialog.rive(
                                          const RiveAnimation.network(
                                            'https://cdn.rive.app/animations/vehicles.riv',
                                            fit: BoxFit.cover,
                                            placeHolder: Center(
                                                child:
                                                    CircularProgressIndicator()),
                                          ),
                                          giffyBuilder: (context, rive) {
                                            return ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(20)),
                                              child: SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.2,
                                                child: rive,
                                              ),
                                            );
                                          },
                                          title: Text(
                                            index % 2 == 0
                                                ? 'Empty Slot'
                                                : 'Vehicle Number: UP76XX9999',
                                            // textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                          content: Text(
                                            index % 2 == 0
                                                ? 'This Parking lot is Free'
                                                : 'Driver Name: Ayush Uttam',
                                            textAlign: TextAlign.center,
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(
                                                  context, 'CALL'),
                                              child: const Text('CALL'),
                                            ),
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, 'OK'),
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    child: index % 2 == 0 || i>=2
                                        ? SizedBox(
                                            height: 50,
                                            width: 50,
                                            child: Image.asset(
                                              'assets/free.png',
                                            ))
                                        : SizedBox(
                                            height: 50,
                                            width: 50,
                                            child: Image.asset(
                                                'assets/notFree.png')),
                                  );
                                },
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 8,
                                  crossAxisCount: 3,
                                ),
                              ),
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
                        'Total Vehicles in Parking',
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
                          .collection('vehicles')
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
                              fontSize: 18,
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
