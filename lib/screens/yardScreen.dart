import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class YardScreen extends StatefulWidget {
  const YardScreen({super.key});
  static const routeName = '/yard-screen';

  @override
  State<YardScreen> createState() => _YardScreenState();
}

class _YardScreenState extends State<YardScreen> {
  @override
  Widget build(BuildContext context) {
    CarouselController buttonCarouselController = CarouselController();
    return Scaffold(
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: <Widget>[
                ButtonsTabBar(
                  elevation: 5,
                  contentPadding: const EdgeInsets.all(8),
                  labelSpacing: 20,
                  backgroundColor: Colors.blue[600],
                  unselectedBackgroundColor: Colors.white,
                  labelStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelStyle: TextStyle(
                    color: Colors.blue[600],
                    fontWeight: FontWeight.bold,
                  ),
                  borderWidth: 1,
                  unselectedBorderColor: Colors.blue.shade600,
                  radius: 100,
                  tabs: const [
                    Tab(
                      icon: Icon(Icons.warehouse_sharp),
                      text: "Yard",
                    ),
                    Tab(
                      icon: Icon(Icons.local_parking_sharp),
                      text: "Parking",
                    ),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: <Widget>[
                      CarouselSlider(
                        items: [1, 2, 3, 4, 5].map((i) {
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
                                      'Dock No - $i',
                                      style: const TextStyle(
                                        fontSize: 24,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: 3,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Trailer No: $index',
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const StepProgressIndicator(
                                                size: 15,
                                                padding: 2,
                                                totalSteps: 4,
                                                currentStep: 2,
                                                selectedColor:
                                                    Colors.greenAccent,
                                                unselectedColor: Colors.yellow,
                                              ),
                                            ],
                                          ),
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
                          initialPage: 1,
                          enlargeCenterPage: true,
                          enableInfiniteScroll: true,
                          enlargeStrategy: CenterPageEnlargeStrategy.height,
                          padEnds: true,
                        ),
                      ),
                      CarouselSlider(
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
                                        physics:
                                            const NeverScrollableScrollPhysics(),
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
