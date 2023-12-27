import 'package:e_commerce/productRatingAndReviews.dart';
import 'package:e_commerce/salesReportPages.dart';
import 'package:e_commerce/sellerOrderPage.dart';
import 'package:e_commerce/seller_profile_option.dart';
import 'package:flutter/material.dart';

class menuScreen extends StatefulWidget {
  const menuScreen({super.key});

  @override
  State<menuScreen> createState() => _menuScreenState();
}

class _menuScreenState extends State<menuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text(
          'Menu Options',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.lightBlue.shade900,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                SizedBox(
                  height: 8,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => profileOptions()));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.person),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Your Profile",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      Icon(Icons.keyboard_arrow_right_sharp)
                    ],
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Divider(
                  height: 1,
                ),
                SizedBox(
                  height: 12,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => sellerReturnReplacement(
                                  index1: 1,
                                )));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            "assets/images/product-return.png",
                            height: 21,
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          Text(
                            "Return and Replacement",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      Icon(Icons.keyboard_arrow_right_sharp)
                    ],
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Divider(
                  height: 1,
                ),
                SizedBox(
                  height: 12,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SalesReportPages()));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.trending_up_sharp),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Sales Overview",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      Icon(Icons.keyboard_arrow_right_sharp)
                    ],
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Divider(
                  height: 1,
                ),
                SizedBox(
                  height: 12,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => productRatingAndReview()));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.rate_review_sharp),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Rating and Reviews",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      Icon(Icons.keyboard_arrow_right_sharp)
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}