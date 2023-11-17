import 'package:e_commerce/apis/ProductModel.dart';
import 'package:e_commerce/services/User_api.dart';
import 'package:e_commerce/services/tokenId.dart';
import 'package:e_commerce/update_product.dart';
import 'package:flutter/material.dart';

import '../productDetailScreen.dart';

class RecentAddedProduct extends StatefulWidget {
  const RecentAddedProduct({super.key});

  @override
  State<RecentAddedProduct> createState() => _RecentAddedProductState();
}

class _RecentAddedProductState extends State<RecentAddedProduct> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 5.0, right: 5.0),
      child: FutureBuilder(
        future: UserApi.getProducts(TokenId.token, TokenId.id, 1),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error : ${snapshot.error}"),
            );
          } else {
            final List<Product>? data = snapshot.data;

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 2,
              itemBuilder: (BuildContext context, int index) {
                final prod = data?[index];
                String s = prod!.inStock.toString() == 'true'
                    ? 'In stock'
                    : 'Out of stock';

                String starRating = '';
                double prating = prod.productName.length % 6;
                if (prating == 0) {
                  starRating = '⭐';
                } else {
                  int fullStars = prating.floor();
                  double remaining = (prating - fullStars) as double;

                  starRating = '⭐' * fullStars;
                }
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductDetailsScreen(
                                prod: prod, productId: prod.id)));
                  },
                  child: Card(
                    elevation: 5,
                    margin: const EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 6),
                    child: Row(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    height: 130,
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                  child: Container(
                                                margin: const EdgeInsets.only(
                                                    right: 15),
                                                child: (prod.images.isNotEmpty)
                                                    ? Image.network(
                                                        prod.images[0],
                                                        height: 150,
                                                        width: 80,
                                                        fit: BoxFit.fill,
                                                      )
                                                    : Image.asset(
                                                        'assets/images/a1.jpg',
                                                        height: 150,
                                                        width: 80),
                                              )),
                                              Expanded(
                                                flex: 2,
                                                child: Container(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                              prod.productName,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 19,
                                                                  fontFamily:
                                                                      'comfart',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold))),
                                                      Expanded(
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                                '₹${prod.offerPrice.toString()}',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        16,
                                                                    fontFamily:
                                                                        'comfort',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text(
                                                                'MRP '
                                                                '₹${prod.mrpPrice.toString()}'
                                                                '${860}',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14,
                                                                    fontFamily:
                                                                        'comfort',
                                                                    decoration:
                                                                        TextDecoration
                                                                            .lineThrough)),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          width: 100,
                                                          height: 18,
                                                          decoration:
                                                              BoxDecoration(
                                                                  //  border: Border.all(color: Colors.black),
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              5))),
                                                          //   margin: EdgeInsets.only(right: 20),
                                                          child: Text('⭐⭐⭐⭐',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                      13.5,
                                                                  fontFamily:
                                                                      'comfort',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          width: 220,
                                                          child: MaterialButton(
                                                            color: Colors
                                                                .lightBlue
                                                                .shade400,
                                                            onPressed: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          UpdateProducts(
                                                                            imageList: prod.images,
                                                                            pid:
                                                                                prod.id,
                                                                            token:
                                                                                TokenId.token,
                                                                            id: TokenId.id,
                                                                            productName:
                                                                                prod.productName,
                                                                            // productImage: prod!
                                                                            //     .image
                                                                            //     .toString(),
                                                                            productCategory:
                                                                                prod.category,
                                                                            productSubCategory1:
                                                                                prod.subCategory1,
                                                                            productSubCategory2:
                                                                                prod.subCategory2,

                                                                            quantityPricing:
                                                                                prod.productDetails,
                                                                            stockTF:
                                                                                prod.inStock,
                                                                            stockIO:
                                                                                s,
                                                                            // productType: prod!
                                                                            //     .productType,
                                                                            description:
                                                                                prod.description,
                                                                          )));
                                                            },
                                                            child: Text(
                                                              'Edit',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 16),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
