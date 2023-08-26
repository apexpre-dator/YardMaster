import 'package:flutter/material.dart';
import 'package:toggle_list/toggle_list.dart';
import 'package:yms/methods/firestore_methods.dart';
import 'package:yms/models/vehicle_model.dart';

const Color appColor = Colors.blueAccent;

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
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
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
                            child: Icon(Icons.sailing)),
                        title: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                v[index].regNo,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(fontSize: 18),
                              ),
                              Text(
                                v[index].vNo,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontSize: 17),
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
                            color: appColor.withOpacity(0.15),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                v[index].destination ?? '-',
                                style: Theme.of(context).textTheme.bodyLarge,
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
                                                  .bodyLarge,
                                            ),
                                            Text(
                                              TimeOfDay.fromDateTime(
                                                      DateTime.parse(
                                                          v[index].timeIn))
                                                  .format(context),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge,
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
                                                  .bodyLarge,
                                            ),
                                            Text(
                                              v[index].timeOut ?? '-',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge,
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
                                                  .bodyLarge,
                                            ),
                                            Text(
                                              v[index].dockNo,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge,
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
                                                  .bodyLarge,
                                            ),
                                            Text(
                                              v[index].lotNo,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge,
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
                                                  .bodyLarge,
                                            ),
                                            Text(
                                              v[index].objective,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge,
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
                                color: appColor.withOpacity(0.15),
                                height: 0,
                                thickness: 0,
                              ),
                            ],
                          ),
                        ),
                        headerDecoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        expandedHeaderDecoration: BoxDecoration(
                          color: appColor.withOpacity(0.60),
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