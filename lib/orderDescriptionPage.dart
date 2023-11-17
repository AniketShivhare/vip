

import 'package:e_commerce/apis/orderModel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';



class OrderDescriptionPage extends StatefulWidget {
  final Order order ;
  final String status;
  const OrderDescriptionPage({Key? key, required this.order, required this.status, });
  @override
  State<OrderDescriptionPage> createState() => _OrderDescriptionPageState();
}

class _OrderDescriptionPageState extends State<OrderDescriptionPage> {

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
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
                  child: Center(child: Text('${widget.status.toUpperCase()}',style: TextStyle(color: Colors.brown.shade600,fontWeight: FontWeight.bold),)),
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
                Text(DateFormat.Hm().format(order!.createdAt),style: TextStyle(fontSize: 18),),
                Text('${order.productList.length} items for ₹${order.payment.paymentAmount}',style: TextStyle(fontSize: 18),)
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
                              Text('Order from ${order.shippedBy.name}',style: TextStyle(fontSize: 20),),
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
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: order.productList.length,
                      itemBuilder: (context, productIndex) {
                        Product1 product = order.productList[productIndex];

                        return OrderItemCard(
                          itemName: product.productName,
                          itemPrice: '\₹${product.offerPrice.toStringAsFixed(2)}', // Assuming offerPrice is a double
                          itemQuantity: product.quantity,
                        );
                      },
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
                            '\₹${order.payment.paymentAmount}',
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
