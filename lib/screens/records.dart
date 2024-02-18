import 'package:flutter/material.dart';
import 'package:toggle_list/toggle_list.dart';
import 'package:yms/colours.dart';
import 'package:yms/methods/firestore_methods.dart';
import 'package:yms/models/vehicle_model.dart';

class RecordScreen extends StatefulWidget {
  static const routeName = '/record-screen';
  const RecordScreen({super.key});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  List<Vehicle> v = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      _isLoading = true;
    });
    v = await FirestoreMethods().getVehicles();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Records"),
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
                  Text('Retrieving Data...')
                ],
              ),
            )
          : v.isEmpty
              ? const Center(
                  child: Text('No Records Found'),
                )
              : Container(
                  margin: const EdgeInsets.only(top: 10, left: 5, right: 5),
                  child: ToggleList(
                    divider: const SizedBox(height: 10),
                    toggleAnimationDuration: const Duration(milliseconds: 400),
                    scrollPosition: AutoScrollPosition.begin,
                    trailing: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(Icons.expand_more),
                    ),
                    children: List.generate(
                      v.length,
                      (index) => ToggleListItem(
                        leading: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(
                            Icons.directions_car_filled_sharp,
                            color: Colors.white,
                          ),
                        ),
                        title: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                v[index].vNo,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(fontSize: 18)
                                    .copyWith(color: Colors.white),
                              ),
                              Text(
                                v[index].vModel,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontSize: 17)
                                    .copyWith(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        divider: const Divider(
                          color: Colors.white,
                          height: 2,
                          thickness: 2,
                        ),
                        content: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(20),
                            ),
                            color: lightColor.withOpacity(0.7),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                // Change here to source
                                "Source: ${v[index].sourceCity}, ${v[index].sourceState} | Destination: ${v[index].destination ?? '-'}",
                                maxLines: 2,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(color: Colors.white),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.55,
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'CheckIn Time',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                      color: Colors.white),
                                            ),
                                            Text(
                                              TimeOfDay.fromDateTime(
                                                      DateTime.parse(
                                                          v[index].timeIn))
                                                  .format(context),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                      color: Colors.white),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'CheckOut Time',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                      color: Colors.white),
                                            ),
                                            Text(
                                              v[index].timeOut == null
                                                  ? '-'
                                                  : TimeOfDay.fromDateTime(
                                                          DateTime.parse(
                                                              v[index]
                                                                  .timeOut!))
                                                      .format(context),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                      color: Colors.white),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'DockNo',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                      color: Colors.white),
                                            ),
                                            Text(
                                              v[index].dockNo,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                      color: Colors.white),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'ParkingLot',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                      color: Colors.white),
                                            ),
                                            Text(
                                              v[index].lotNo,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                      color: Colors.white),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Objective',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                      color: Colors.white),
                                            ),
                                            Text(
                                              v[index].objective,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                      color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Image.network(
                                    v[index].photoUrl,
                                    width: MediaQuery.of(context).size.height *
                                        0.12,
                                    height: MediaQuery.of(context).size.height *
                                        0.12,
                                    fit: BoxFit.fill,
                                  ),
                                ],
                              ),
                              Divider(
                                color: lightColor,
                                height: 0,
                                thickness: 0,
                              ),
                            ],
                          ),
                        ),
                        headerDecoration: BoxDecoration(
                          color: darkColor.withOpacity(0.7),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        expandedHeaderDecoration: BoxDecoration(
                          color: darkColor.withOpacity(0.9),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
    );
  }
}
