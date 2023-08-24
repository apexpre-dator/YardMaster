import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class YardScreen extends StatelessWidget {
  const YardScreen({super.key});
  static const routeName = '/yard-screen';

  @override
  Widget build(BuildContext context) {
    CarouselController buttonCarouselController = CarouselController();
    return CarouselSlider(
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              selectedColor: Colors.greenAccent,
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
        autoPlay: true,
        height: MediaQuery.of(context).size.height * 0.5,
        autoPlayCurve: Curves.fastOutSlowIn,
        viewportFraction: 0.9,
        initialPage: 1,
        enlargeCenterPage: true,
        enableInfiniteScroll: true,
        enlargeStrategy: CenterPageEnlargeStrategy.height,
        padEnds: true,
      ),
    );
  }
}
