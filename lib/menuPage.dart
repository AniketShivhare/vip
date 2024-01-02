import 'package:e_commerce/productRatingAndReviews.dart';
import 'package:e_commerce/salesReportPages.dart';
import 'package:e_commerce/sellerOrderPage.dart';
import 'package:e_commerce/seller_login.dart';
import 'package:e_commerce/seller_profile_option.dart';
import 'package:e_commerce/services/sellerTokenId.dart';
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
                            "Returns and Replacements",
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
                            "Ratings and Reviews",
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
                    showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          title: Text('Logout'),
                          content: Text(
                              'Are you sure you want to logout?'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('NO', style: TextStyle(color: Colors.green)),
                              onPressed: () {
                                Navigator.of(context)
                                    .pop(true);
                              },
                            ),
                            TextButton(
                              child: Text('YES', style: TextStyle(color: Colors.red)),
                              onPressed: () {
                                Candidate.clearAll().then((value) {
                                  if (value) {
                                    Navigator.of(context, rootNavigator: true)
                                        .pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) => LoginScreen()),
                                            (route) => false);
                                  }
                                  else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("Logout Failed!")));
                                    Navigator.of(context)
                                        .pop(true);
                                  }
                                  //   //Navigator.of(context).popUntil((route) => route == MaterialPageRoute(builder: (context) => const AuthScreen()));
                                });
                              },
                            ),
                          ]);
                    },
                  );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.logout_outlined),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Logout",
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
