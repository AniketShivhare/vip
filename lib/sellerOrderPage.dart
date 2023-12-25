import 'dart:async';
import 'dart:convert';

import 'package:e_commerce/services/User_api.dart';
import 'package:e_commerce/services/tokenId.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../apis/orderModel.dart';
import 'package:http/http.dart' as http;
import 'orderDescriptionPage.dart';


class sellerReturnReplacement extends StatefulWidget {
  final  index1;
  const sellerReturnReplacement(
      {Key? key,
        required this.index1,
      })
      : super(key: key);
  @override
  _BankDetailsFormState createState() => _BankDetailsFormState();
}

class _BankDetailsFormState extends State<sellerReturnReplacement> {

  Color color1 = Colors.blue.shade300;
  Color color2 = const Color(0xFFFFF7F7);
  Color color3 = const Color(0xFFDADADA);
  Color color4 = const Color(0xFF204969);
  bool isNewOrders = true;

  StreamController<List<Order>> orderStreamController = StreamController<List<Order>>.broadcast();

  Future<List<Order>> fetchOrderData(filter, {bool ok = true}) async {
    print(filter);
    try {
      var url = "https://api.pehchankidukan.com/seller/650861407bfbdb03672c18de/orders?status=OrderAccepted";
      final uri = Uri.parse(url);
      final response = await http.get(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${TokenId.token}'
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        // final body = response.body;
        // final Map<String,dynamic> productJson = jsonDecode(body);
        final bodyBytes = response.bodyBytes;
        final bodyString = utf8.decode(bodyBytes);
        final Map<String, dynamic> productJson = jsonDecode(bodyString);

        List<Order> orders = (productJson['allOrders'] as List<dynamic>?)
            ?.map((e) => Order.fromJson(e as Map<String, dynamic>))
            .toList() ?? [];
        for (Order order in orders) {
          order.getProductListString();
        }
        print("orders.length21232");
        print(orders.length);
        print(ok);
        if(!orderStreamController.isClosed && ok) {
          orderStreamController.sink.add(orders);
        }

        print("Order get successful1");
        return orders;
      } else {
        print('Failed to get orders. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error while fetching orders: $e');
    }
    return [];
  }

  void fetchDataPeriodically() {
    Timer.periodic(const Duration(seconds: 2), (timer) {
      fetchOrderData("OrderAccepted");
    });
  }
  int currentTabIndex=0;

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
    fetchOrderData("OrderAccepted");
    currentTabIndex = widget.index1;
    _fetchOrderTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      fetchOrderData("OrderAccepted");
    });
    // fetchOrderData("OrderReceived");
    // fetchOrderData("OrderReceived");
    // fetchDataPeriodically();
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Color(0xFFFFF7F7),
        appBar: AppBar(
          backgroundColor: const Color(0xFF204969),
          toolbarHeight: 45,
          title: const Text('Return Replacement',
            style: TextStyle(
                color: Colors.white),
          ),
          centerTitle: true,
          bottom:  TabBar(
            indicatorWeight: 5,
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
            ],
          ),
        ),
        body: TabBarView(
          children: [
            StreamBuilder<List<Order>>(
              stream: orderStreamController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  print("snapshot.data");
                  print(snapshot.data);
                  List<Order>? orders = snapshot.data;
                  return buildPage1(orders);
                }
                else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  print(snapshot.hasData);
                  return const Center(
                      child: CircularProgressIndicator()
                  );
                }
              },
            ),
            FutureBuilder<List<Order>>(
              future: fetchOrderData("OrderPrepared",ok:false),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  print("re${snapshot.data?.length}");
                  return buildPage3(snapshot.data,"OrderPrepared");
                }
              },
            ),

          ],
        ),
      ),
    );
  }

  Widget buildPage1(orders,{bool ok=false}) {
    print("orders.length");
    print(orders.length);
    return Scaffold(
        backgroundColor: Colors.white30,
        body: ListView.builder(
          itemCount: (ok)? 2 :orders?.length,
          itemBuilder: (BuildContext context, int index) {
            final order = orders?[index];
            return Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 10.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => OrderDescriptionPage(order: order, status: 'Return Request', )));
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
                            Text('#${order?.id?.substring(order.id!.length - 3)}',style: TextStyle(fontSize: 23,fontWeight: FontWeight.bold),),
                            const SizedBox(width: 20,),
                            Expanded(
                              child: Container(
                                height: 25,
                                // color: Colors.orangeAccent,
                                child: const Center(
                                  child: Text('Return Request',style: TextStyle(fontSize: 17),),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          children: [
                            Text('${order?.shippedBy.name}\'s Request',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),),
                            const Spacer(),
                            Text(DateFormat.Hm().format(order!.createdAt)),
                          ],
                        ),
                      ],
                    ),
                    subtitle: Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5,),
                        Row(
                          children: [
                            Text(order?.productShowOnOrder,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
                            const Spacer(),
                            const Text('Total Bill: ',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),),
                            // Spacer(),
                            Text(order.payment.paymentAmount.toString(),style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),)
                          ],
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {

                              },
                              child: const Center(
                                child: Text(
                                  'Reason:  product quality is not upto the mark',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18
                                    // decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(),
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
                              child: const Text('Return product Received', style: TextStyle(color: Colors.white)),
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
        )
    );
  }
  Widget buildPage3( orders, orderStatus) {
    String orderStatus1 = "";
    if(orderStatus=="OrderPrepared") {
      orderStatus1 = "ready for pick up ";
    }
    print("orders.length");
    print(orders.length);
    // final List<String> price = ["₹300", "₹70", "₹200", "₹150","123","1233","3423", "₹150","123","1233", "₹150","123","1233"];
    return Scaffold(
        backgroundColor: Colors.white,
        body: ListView.builder(
          itemCount: orders?.length,
          itemBuilder: (BuildContext context, int index) {
            Order order = orders[index];
            return Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 10.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => OrderDescriptionPage(order: order, status: 'Preparing', )));
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
                            Text('#${order?.id?.substring(order.id!.length - 3)}',style: TextStyle(fontSize: 23,fontWeight: FontWeight.bold),),
                            const SizedBox(width: 10,),
                            Expanded(
                              child: Container(
                                height: 25,
                                // color: Colors.lightGreen.shade400,
                                child:  Center(
                                  child: Text('Replacement Request Status',style: TextStyle(fontSize: 17),),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          children: [
                            Text('${order?.customer.name}\'s Order',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),),
                            const Spacer(),
                            Text(DateFormat.Hm().format(order!.createdAt)),
                          ],
                        ),
                      ],
                    ),
                    subtitle: Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5,),
                        Row(
                          children: [
                            Text(order.productShowOnOrder,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
                            const Spacer(),
                            const Text('Total Bill: ',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),),
                            // Spacer(),
                            Text(order.payment.paymentAmount.toString(),style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),)
                          ],
                        ),

                        const SizedBox(height: 10),
                        (orderStatus1 =='ready for pick up ') ? const Row(
                          children: [
                            Text("Reason:  product quality is not upto the mark",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                            Spacer()
                          ],
                        ):Container(),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [


                            ElevatedButton(
                              onPressed: () {
                                showCustomDialog(context, "Replacement");
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              child: const Text('Replacement product Received', style: TextStyle(color: Colors.white)),
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
        )
    );
  }

  Future<void> changeOrderstatus({required orderId, required String state}) async {
    final apiUrl = 'https://api.pehchankidukan.com/seller/changeOrderStatus';

    final Map<String, dynamic> productJson = {

    };
    var uri = Uri.parse(apiUrl);
    try {
      final response = await http.patch(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${TokenId.token}'
        },
        body: jsonEncode(productJson),
      );

      if (response.statusCode == 200) {
        print("product updated succesfully");

      } else {
        print('Failed to update product. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print(e);
    }
  }

}




void showCustomDialog(BuildContext context, String request) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("$request Request"),
        content: Text('Did you Received The $request Product \n \n Accepting will initiate the refund',style: TextStyle(fontSize: 17),),
        actions: [
          TextButton(
            onPressed: () {
              // Handle Accept button press
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Accept'),
          ),
          TextButton(
            onPressed: () {
              // Handle Reject button press
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Reject'),
          ),
        ],
      );
    },
  );
}