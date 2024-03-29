import 'dart:async';
import 'dart:convert';
import 'package:e_commerce/apis/ReplacementModel.dart';
import 'package:intl/intl.dart';

import 'package:e_commerce/services/User_api.dart';
import 'package:e_commerce/services/tokenId.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../apis/orderModel.dart';
import 'package:http/http.dart' as http;
import 'apis/ReturnModel.dart';
import 'orderDescriptionPage.dart';

class sellerReturnReplacement extends StatefulWidget {
  final index1;
  const sellerReturnReplacement({
    Key? key,
    required this.index1,
  }) : super(key: key);
  @override
  _BankDetailsFormState createState() => _BankDetailsFormState();
}

class _BankDetailsFormState extends State<sellerReturnReplacement> {
  Color color1 = Colors.blue.shade300;
  Color color2 = const Color(0xFFFFF7F7);
  Color color3 = const Color(0xFFDADADA);
  Color color4 = const Color(0xFF204969);
  bool isNewOrders = true;
  late Replacement rep;
  StreamController<List<Return>> orderStreamController =
      StreamController<List<Return>>.broadcast();

  Future<List<Return>> fetchReturnData({bool ok = true}) async {
    List<Return> returnProducts = await UserApi.getAllReturn();
    if (!orderStreamController.isClosed && ok) {
      orderStreamController.sink.add(returnProducts);
    }
    return returnProducts;
  }

  Future<List<Replacement>> fetchReplacementData({bool ok = true}) async {
    List<Replacement> returnProducts = await UserApi.getAllReplacement();
    return returnProducts;
  }

  Future<List<Replacement>> fetchReplacementReturnData({bool ok = true}) async {
    List<Replacement> returnProducts = await UserApi.getAllReplacementReturn();
    return returnProducts;
  }

  void fetchDataPeriodically() {
    Timer.periodic(const Duration(seconds: 2), (timer) {
      fetchReturnData();
    });
  }

  int currentTabIndex = 0;

  @override
  void dispose() {
    orderStreamController.close();
    _fetchOrderTimer?.cancel();
    super.dispose();
  }

  Timer? _fetchOrderTimer;
  @override
  void initState() {
    super.initState();
    fetchReturnData();
    currentTabIndex = widget.index1;
    _fetchOrderTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      fetchReturnData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Color(0xFFFFF7F7),
        appBar: AppBar(
          backgroundColor: const Color(0xFF204969),
          toolbarHeight: 45,
          title: const Text(
            'Return Replacement',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          bottom: TabBar(
            indicatorWeight: 6,
            indicatorColor: Colors.black54,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white,
            onTap: (index) {
              // orderStreamController.close();
              setState(() {
                currentTabIndex = index;
              });
            },
            tabs: const [
              Tab(text: 'Return'),
              Tab(text: 'Replacement'),
              Tab(text: 'Copleted Requests')
            ],
          ),
        ),
        body: TabBarView(
          children: [
            StreamBuilder<List<Return>>(
              stream: orderStreamController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  print("snapshot.data");
                  print(snapshot.data);
                  List<Return>? orders = snapshot.data;
                  return buildPage1(orders!);
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  print(snapshot.hasData);
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
            FutureBuilder<List<Replacement>>(
              future: fetchReplacementData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  print("re${snapshot.data?.length}");
                  return buildPage3(snapshot.data!);
                }
              },
            ),
            FutureBuilder<List<Replacement>>(
              future: fetchReplacementReturnData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  print("re${snapshot.data?.length}");
                  return buildPage4(snapshot.data!);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPage1(List<Return> orders, {bool ok = false}) {
    double ewidth = MediaQuery.of(context).size.width;
    double eheight = MediaQuery.of(context).size.height;
    print("orders.length");
    print(orders.length);
    return Scaffold(
        backgroundColor: Colors.white30,
        body: ListView.builder(
          itemCount: (ok) ? 2 : orders.length,
          itemBuilder: (BuildContext context, int index) {
            final order = orders[index];
            return Container(
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
                child: InkWell(
                  onTap: () {
                    // Navigator.push(context,
                    // MaterialPageRoute(builder: (context) => OrderDescriptionPage(order: order, status: 'Return Request', )));
                  },
                  child: Card(
                    color: Colors.white,
                    elevation: 5, // Add elevation to make it appear as a card
                    child: ListTile(
                      tileColor: Colors.white,
                      title: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'ID: #${order.id}',
                                style: TextStyle(
                                    fontSize: ewidth * 0.045,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Row(
                            children: [
                              Text(
                                'Return Status: ${order.status}',
                                style: TextStyle(
                                    fontSize: ewidth * 0.048,
                                    fontWeight: FontWeight.bold),
                              ),
                              Spacer(),
                              Text(
                                DateFormat('yyyy-MM-dd')
                                    .format(order.createdAt!),
                                style: TextStyle(fontSize: ewidth * 0.04),
                              ),
                            ],
                          ),
                          Divider(),
                          Row(
                            children: [
                              Text(
                                '${order.shippedBy?.name}\'s Request',
                                style: TextStyle(
                                  fontSize: ewidth * 0.05,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),
                        ],
                      ),
                      subtitle: Column(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text(
                                '${order.productInstance?.quantity}${order.productInstance?.unit} ${order.productInstance?.productName}',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: ewidth * 0.05),
                              ),
                              const Spacer(),
                              Text(
                                'Rs ',
                                style: TextStyle(
                                  fontSize: ewidth * 0.045,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              // Spacer(),
                              Text(
                                order.productInstance!.offerPrice.toString(),
                                style: TextStyle(
                                    fontSize: ewidth * 0.05,
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Center(
                                    child: Text(
                                      'Reason:  ${order.reasons}',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                          fontSize: ewidth * 0.045
                                          // decoration: TextDecoration.underline,
                                          ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      // softWrap: true,
                                    ),
                                  ),
                                ),
                              ),
                              // Spacer(),
                            ],
                          ),
                          // const SizedBox(height: 10),

                          const SizedBox(height: 10),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  showCustomDialog(context, "Return");
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                                child: Text('Return product Received',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: ewidth * 0.045)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ));
  }

  Widget buildPage3(List<Replacement> orders) {
    double ewidth = MediaQuery.of(context).size.width;
    double eheight = MediaQuery.of(context).size.height;
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (BuildContext context, int index) {
        Replacement order = orders[index];
        return Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
          child: InkWell(
            onTap: () {
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => OrderDescriptionPage(order: order, status: 'Preparing', )));
            },
            child: Card(
              color: Colors.white10,
              elevation: 5, // Add elevation to make it appear as a card
              child: ListTile(
                tileColor: Colors.white,
                title: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          '#${order.id}',
                          style: TextStyle(
                              fontSize: ewidth * 0.05,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          'Status: ${order.status}',
                          style: TextStyle(
                              fontSize: ewidth * 0.06,
                              fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Text(
                          DateFormat('yyyy-MM-dd').format(order.createdAt!),
                          style: TextStyle(fontSize: ewidth * 0.045),
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      children: [
                        Text(
                          '${order.shippedBy?.name}\'s Order',
                          style: TextStyle(
                            fontSize: ewidth * 0.052,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ],
                ),
                subtitle: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text(
                          '${order.productInstance?.quantity}${order.productInstance?.unit} ${order.productInstance?.productName}',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: ewidth * 0.05),
                        ),
                        const Spacer(),
                        Text(
                          'Total Bill: ${order.productInstance?.offerPrice}',
                          style: TextStyle(
                            fontSize: ewidth * 0.05,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        // Spacer(),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Reason: ${order.reasons}",
                            style: TextStyle(
                                fontSize: ewidth * 0.045,
                                fontWeight: FontWeight.w500),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            rep = order;
                            print("rep.productInstance?.productID");
                            print(rep.productInstance?.productID);
                            showCustomDialog(context, "Replacement");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: Text('Replacement product Received',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: ewidth * 0.045)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildPage4(List<Replacement> orders) {
    double ewidth = MediaQuery.of(context).size.width;
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (BuildContext context, int index) {
        Replacement order = orders[index];
        return Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
          child: InkWell(
            onTap: () {
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => OrderDescriptionPage(order: order, status: 'Preparing', )));
            },
            child: Card(
              color: Colors.white10,
              elevation: 5, // Add elevation to make it appear as a card
              child: ListTile(
                tileColor: Colors.white,
                title: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          '#${order.id}',
                          style: TextStyle(
                              fontSize: ewidth * 0.045,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          'Status: ${order.status}',
                          style: TextStyle(
                              fontSize: ewidth * 0.045,
                              fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Text(
                          DateFormat('yyyy-MM-dd').format(order.createdAt!),
                          style: TextStyle(fontSize: ewidth * 0.04),
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      children: [
                        Text(
                          '${order.shippedBy?.name}\'s Order',
                          style: TextStyle(
                            fontSize: ewidth * 0.04,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ],
                ),
                subtitle: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text(
                          '${order.productInstance?.quantity}${order.productInstance?.unit} ${order.productInstance?.productName}',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: ewidth * 0.04),
                        ),
                        const Spacer(),
                        Text(
                          'Total Bill: ${order.productInstance?.offerPrice}',
                          style: TextStyle(
                            fontSize: ewidth * 0.04,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        // Spacer(),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Reason: ${order.reasons}",
                            style: TextStyle(
                                fontSize: ewidth * 0.04,
                                fontWeight: FontWeight.w500),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Spacer()
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void showCustomDialog(BuildContext context, String request) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("$request Request"),
          content: Text(
            'Did you Received The $request Product \n  Accepting will initiate the refund',
            style: TextStyle(fontSize: 17),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (request == "Replacement")
                  UserApi.ReplacementFromSeller(rep);
                Navigator.of(context).pop();
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                // Handle Reject button press
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }
}
