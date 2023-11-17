import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../apis/orderModel.dart';
import '../orderDescriptionPage.dart';
import '../services/tokenId.dart';
import 'package:http/http.dart'as http;

class RecentOrder extends StatefulWidget {
  const RecentOrder({super.key});

  @override
  State<RecentOrder> createState() => _RecentOrderState();
}

class _RecentOrderState extends State<RecentOrder> {

  late List<Order> orders1 = [];
  Future<List<Order>> fetchOrderData(filter, {bool ok = true}) async {
    print(filter);
    try {
      var url = "https://api.pehchankidukan.com/seller/${TokenId.id}/orders?orderStatus.status=$filter";
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
        print("Order get successful1");
        orders1 =  orders;
      } else {
        print('Failed to get orders. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error while fetching orders: $e');
    }
    orders1 = [];
    return orders1;
  }


  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    print("orders.length");
    print(orders1.length);
    return  Container(
      margin: const EdgeInsets.only(left: 5.0, right: 5.0),
      child: FutureBuilder<List<Order>>(
        future: fetchOrderData("OrderPrepared",ok:false),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            print("re${snapshot.data?.length}");
            final orders = snapshot.data;
            if(orders?.length==0)return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: (Text("No orders Now",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),))),
            );
            return ListView.builder(
              itemCount: min(2,orders!.length),
              itemBuilder: (BuildContext context, int index) {
                final order = orders?[index];
                return Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 10.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => OrderDescriptionPage(order: order, status: 'Preparing', )));
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
                                    color: Colors.orangeAccent,
                                    child: const Center(
                                      child: Text('Preparing',),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text('${order?.shippedBy.name}\'s Order',
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
                                Text(order!.productShowOnOrder,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
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
                                      'See more Details',
                                      style: TextStyle(
                                        color: Colors.black,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ),
                                const Spacer(),
                              ],
                            ),
                            // const SizedBox(height: 10),
                            const Row(
                              children: [
                                Text("pappu singh is waiting for order  ",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                                Spacer()
                              ],
                            ),
                            const SizedBox(height: 10),
                            Container(
                              height: 38,
                              color: const Color(0xFF204969),
                              width: double.infinity,
                              child: ElevatedButton(onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF204969),
                                    elevation: 3, // Remove button elevation if not needed
                                  ),
                                  child: const Center(
                                    child: Text('Make Order Ready',style: TextStyle(color: Colors.white),),)
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
    // );
  }
}

