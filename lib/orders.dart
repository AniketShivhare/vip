import 'package:e_commerce/services/User_api.dart';
import 'package:flutter/material.dart';
import '../apis/orderModel.dart';
void main() {
  runApp( sellerFrontPage());
}

class OrderPage extends StatefulWidget {

  @override
  State<OrderPage> createState() => _BankDetailsAppState();
}

class _BankDetailsAppState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Order Details',
      debugShowCheckedModeBanner: false,
      home: sellerFrontPage(),
    );
  }
}




class sellerFrontPage extends StatefulWidget {
  @override
  _BankDetailsFormState createState() => _BankDetailsFormState();
}

class _BankDetailsFormState extends State<sellerFrontPage> {

  Color color1 = Colors.blue.shade300;
  Color color2 = const Color(0xFFFFF7F7);
  Color color3 = const Color(0xFFDADADA);
  Color color4 = const Color(0xFF204969);
  bool isNewOrders = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UserApi.fetchOrderData("OrderReceived");
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
          title: const Text('Order Details',
            style: TextStyle(
                color: Colors.white),
          ),
          centerTitle: true,
          bottom: const TabBar(
            indicatorWeight: 5,
            indicatorColor: Colors.black54 ,
            labelColor: Colors.white,
            // Change the selected tab text color.
            unselectedLabelColor: Colors.white,
            // Change the unselected tab text color.
            tabs: [
              Tab(text: 'Preparing',),
              Tab(text: 'Ready',),
              Tab(text: 'Completed',)
            ],
          ),
        ),
        body: TabBarView(
          children: [
            buildPage1('Preparing'),
            buildPage3('Ready'),
            buildPage4('PickedUp'),
          ],
        ),
      ),
    );
  }

  Widget buildPage1(String s) {
    final List<Map<String, String>> orders = [
      {
        'name': 'Abhishek',
        'amount': '₹50',
        'id': '123',
        'order': 'Item 1',
        'time': '10:00 AM',
      },
      {
        'name': 'Sahil',
        'amount': '\$30',
        'id': '124',
        'order': 'Item 2',
        'time': '11:30 AM',
      },
      {
        'name': 'Rohan',
        'amount': '\$70',
        'id': '125',
        'order': 'Item 3',
        'time': '1:45 PM',
      },
      {
        'name': 'Rishi',
        'amount': '\$40',
        'id': '126',
        'order': 'Item 4',
        'time': '3:15 PM',
      },
    ];

    final List<List<List<String>>> data = [
      [
        ["5 ","kg", "sugar", "₹100.00"],
        ["3 ","kg", "rice", "₹150.00"],
        ["2 ","unit", "soap", "₹50"],
      ],
      [
        ["4 kg", "rice", "₹150.00"],
        ["3 kg", "sugar", "₹100.00"],
        ["2 unit", "soap", "₹50"],
      ],
      [
        ["5 kg", "sugar", "₹100500.00"],
      ],
      [
        ["5 kg", "sugar", "₹100.00"],
        ["3 kg", "rice", "₹150.00"],
      ]];

    final List<String> price = ["₹300", "₹70", "₹200", "₹150"];
    return Scaffold(
        backgroundColor: Colors.white30,
        body: Column(
          children: [
            const SizedBox(height: 10,),
            Expanded(
              child: ListView.builder(
                itemCount: orders.length,
                itemBuilder: (BuildContext context, int index) {
                  final order = orders[index];
                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0, right: 8.0, top: 10.0),


                    child: Card(
                      color: Colors.white,
                      elevation: 5, // Add elevation to make it appear as a card
                      child: ListTile(
                        tileColor: Colors.white,
                        title: Column(
                          children: [
                            Row(
                              children: [
                                Text('#${order['id']}',style: TextStyle(fontSize: 23,fontWeight: FontWeight.bold),),
                                const SizedBox(width: 10,),
                                Expanded(
                                  child: Container(
                                    height: 25,
                                    color: Colors.lightGreen.shade400,
                                    child: const Center(
                                      child: Text('Preparing',),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text('${order['name']}\'s Order',
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                  ),),
                                const Spacer(),
                                Text(order['time']!),
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
                                Text('5kg sugar, 3kg rice,.... ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
                                Spacer(),
                                const Text('Total Bill: ',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                  ),),
                                // Spacer(),
                                Text(price[index],style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),)
                              ],
                            ),


                             Row(
                               children: [
                                 GestureDetector(
                                   onTap: () {
                                     setState(() {

                                     });
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
                                Text("name is waiting for order  ",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
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
                  );
                },
              ),
            ),
          ],
        )


    );
  }


  Widget buildPage3(String s) {
    final List<Map<String, dynamic>> orders = [
      {
        'name': 'Abhishek',
        'amount': '₹50',
        'id': '123',
        'order': 'Item 1',
        'time': '10:00 AM',
      },
      {
        'name': 'Sahil',
        'amount': '\$30',
        'id': '124',
        'order': 'Item 2',
        'time': '11:30 AM',
      },
      {
        'name': 'Rohan',
        'amount': '\$70',
        'id': '125',
        'order': 'Item 3',
        'time': '1:45 PM',
      },
      {
        'name': 'Rishi',
        'amount': '\$40',
        'id': '126',
        'order': 'Item 4',
        'time': '3:15 PM',
      },
    ];
    final List<String> product = ["sugar", "rice", "soap", "flour"];
    final List<String> amount = ["1 kg", "2 kg", "2 Dozen", "5 kg"];
    final List<String> price = ["₹50", "₹70", "₹200", "₹150"];
    return Scaffold(
        backgroundColor: const Color(0xFFFFF7F7),
        body: Column(
          children: [
            const SizedBox(height: 10,),
            Expanded(
              child: ListView.builder(
                itemCount: orders.length,
                itemBuilder: (BuildContext context, int index) {
                  final order = orders[index];
                  return Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8.0, top: 10.0),

                    child: Card(
                      elevation: 5, // Add elevation to make it appear as a card
                      child: ListTile(
                        title: Column(
                          children: [
                            Container(
                              height: 25,
                              width: double.infinity,
                              color: const Color(0xFFDADADA),
                              child: const Center(
                                child: Text('Ready Order',),
                              ),
                            ),
                            Row(
                              children: [
                                Text('Order ID: ${order['id']}'),
                                const Spacer(),
                                Text(order['time']!),
                                PopupMenuButton<String>(
                                  // onSelected: _selectOption,
                                  itemBuilder: (BuildContext context) {
                                    return {'a', 'b'}.map((String choice) {
                                      return PopupMenuItem<String>(
                                        value: choice,
                                        child: Text(choice),
                                      );
                                    }).toList();
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        subtitle: Column(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [

                                Text('  ${order['name']}\'s Order',
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                  ),),
                                const Spacer(),
                                const Text('Takeaway',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                  ),)
                              ],
                            ),
                            const SizedBox(height: 10,),
                            Visibility(
                                child: Row(
                                  children: [
                                    Text('${amount[index]} ${product[index]}',
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                      ),),
                                    const Spacer(),
                                    Text(price[index],
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                      ),)
                                  ],
                                )
                            ),
                            const SizedBox(height: 10),
                            //
                            // const SizedBox(height: 10,),
                            Text('Total Bill: ${price[index]} ',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),)
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        )


    );
  }
  Widget buildPage4(String s) {
    final List<Map<String, String>> orders = [
      {
        'name': 'Abhishek',
        'amount': '₹50',
        'id': '123',
        'order': 'Item 1',
        'time': '10:00 AM',
      },
      {
        'name': 'Sahil',
        'amount': '\$30',
        'id': '124',
        'order': 'Item 2',
        'time': '11:30 AM',
      },
      {
        'name': 'Rohan',
        'amount': '\$70',
        'id': '125',
        'order': 'Item 3',
        'time': '1:45 PM',
      },
      {
        'name': 'Rishi',
        'amount': '\$40',
        'id': '126',
        'order': 'Item 4',
        'time': '3:15 PM',
      },
    ];
    final List<String> product = ["sugar", "rice", "soap", "flour"];
    final List<String> amount = ["1 kg", "2 kg", "2 Dozen", "5 kg"];
    final List<String> price = ["₹50", "₹70", "₹200", "₹150"];
    return Scaffold(
        backgroundColor: const Color(0xFFFFF7F7),
        body: Column(
          children: [
            const SizedBox(height: 10,),

            Expanded(
              child: ListView.builder(
                itemCount: orders.length,
                itemBuilder: (BuildContext context, int index) {
                  final order = orders[index];
                  return Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8.0, top: 10.0),

                    child: Card(
                      elevation: 5, // Add elevation to make it appear as a card
                      child: ListTile(
                        title: Column(
                          children: [
                            Container(
                              height: 25,
                              width: double.infinity,
                              color: const Color(0xFFDADADA),
                              child: const Center(
                                child: Text('Completed',),
                              ),),
                            Row(
                              children: [
                                Text('Order ID: ${order['id']}'),
                                const Spacer(),
                                Text(order['time']!),
                                PopupMenuButton<String>(
                                  // onSelected: _selectOption,
                                  itemBuilder: (BuildContext context) {
                                    return {'a', 'b'}.map((String choice) {
                                      return PopupMenuItem<String>(
                                        value: choice,
                                        child: Text(choice),
                                      );
                                    }).toList();
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        subtitle: Column(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [

                                Text('${order['name']}\'s Order',
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                  ),),
                                const Spacer(),
                                const Text('Takeaway',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                  ),)
                              ],
                            ),
                            const SizedBox(height: 10,),
                            Visibility(
                                child: Row(
                                  children: [
                                    Text('${amount[index]} ${product[index]}',
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                      ),),
                                    const Spacer(),
                                    Text(price[index],
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                      ),)
                                  ],
                                )
                            ),
                            const SizedBox(height: 10),
                            //
                            // const SizedBox(height: 10,),
                            Text('Total Amount: ${price[index]} ',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),)
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        )


    );
  }



}