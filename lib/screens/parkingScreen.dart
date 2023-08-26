import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

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
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 15),
          child: CarouselSlider(
            items: [1, 2, 3].map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Parking Lot- $i',
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: GridView.builder(
                            itemCount: 9,
                            itemBuilder: (context, index) {
                              return Icon(
                                Icons.directions_car_filled,
                                color: index % 2 == 0
                                    ? Colors.redAccent
                                    : Colors.greenAccent,
                                size: 80,
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
              initialPage: 1,
              enlargeCenterPage: true,
              enableInfiniteScroll: true,
              enlargeStrategy: CenterPageEnlargeStrategy.height,
              padEnds: true,
            ),
          ),
        ),
      ),
    );
  }
}
