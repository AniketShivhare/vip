

import 'package:flutter/material.dart';



class OrderDescriptionPage extends StatefulWidget {
  @override
  State<OrderDescriptionPage> createState() => _OrderDescriptionPageState();
}

class _OrderDescriptionPageState extends State<OrderDescriptionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Order #12345',style: TextStyle(fontWeight: FontWeight.bold),),

                Container(
                  height: 30,
                  width: 140,
                  child: Center(child: Text('PREPARING',style: TextStyle(color: Colors.brown.shade600,fontWeight: FontWeight.bold),)),

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.orangeAccent.shade200,
                  ),
                )
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('02:12 PM',style: TextStyle(fontSize: 18),),
                Text('2 items for ₹150.01',style: TextStyle(fontSize: 18),)
              ],
            )

          ],
        ),


      ),
      body: SingleChildScrollView(

          child: Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 20,),

                Container(
                  width: 300,
                  // height: 100,
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.white
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.person,size: 40,),
                              SizedBox(width: 5,),
                              Text('Order from Mani',style: TextStyle(fontSize: 20),),
                            ],
                          ),
                          Icon(Icons.phone,color: Colors.red,),

                        ],
                      ),
                     Divider(height: 1,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            Icon(Icons.delivery_dining_outlined,size: 40,),
                              SizedBox(width: 2,),
                              // Text('Delivery Partner: Pappu Singh',overflow: TextOverflow.ellipsis,
                              //   maxLines: 2,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: WrapTextIfLong(
                                      text: 'Delivery Partner:Pappu Singh sharma',
                                      maxLineLength: 30,

                                    ),
                                  ),
                                  Text('OTP- 0231',style: TextStyle(fontSize: 17),),
                                ],
                              ),
                          ],),

                          Icon(Icons.phone,color: Colors.red,),
                        ],
                      )

                    ],
                  ),
                ),

                 SizedBox(height: 20,),
                Container(

              width:300,
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.white
              ),
                child:Column(
                  children: [
                    OrderItemCard(
                      itemName: 'Burger',
                      itemPrice: '\₹10.00',
                      itemQuantity: 2,
                    ),
                    OrderItemCard(
                      itemName: 'Pizza',
                      itemPrice: '\₹15.00',
                      itemQuantity: 1,
                    ),
                    OrderItemCard(
                      itemName: 'Cola',
                      itemPrice: '\₹5.00',
                      itemQuantity: 3,
                    ),

                    Divider(height: 1,),
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Total Amount',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '\₹30.00',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(height: 1),
                  ],
                )

            ),

                SizedBox(height: 30,),
                ElevatedButton(
                    onPressed: (){},
                    child: Text('Mark Order Ready',style: TextStyle(color: Colors.white,fontSize: 20),),
                  style: ElevatedButton.styleFrom(

                    backgroundColor: Colors.blue.shade900,
                  ),

                )
              ],
            ),
          ),
        ),
    );
  }
}

class OrderItemCard extends StatelessWidget {
  final String itemName;
  final String itemPrice;
  final int itemQuantity;

  OrderItemCard({
    required this.itemName,
    required this.itemPrice,
    required this.itemQuantity,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                itemName,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('Quantity: $itemQuantity'),
            ],
          ),
          Text(
            itemPrice,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class WrapTextIfLong extends StatelessWidget {
  final String text;
  final int maxLineLength;

  WrapTextIfLong({
    required this.text,
    this.maxLineLength = 20, // Set your desired maximum length here
  });

  @override
  Widget build(BuildContext context) {
    if (text.length <= maxLineLength) {
      return Text(
        text,
        style: TextStyle(fontSize: 17,), // Set your desired text style
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text.substring(0, 17),
            style: TextStyle(fontSize: 17),
          ),
          Text(
            text.substring(17),
            style: TextStyle(fontSize: 17),
          ),
        ],
      );
    }
  }
}
