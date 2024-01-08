import 'dart:async';
import 'dart:convert';
import 'package:e_commerce/filterWidget.dart';
import 'package:e_commerce/productDetailScreen.dart';
import 'package:e_commerce/services/Categories.dart';
import 'package:e_commerce/services/filterData.dart';
import 'package:e_commerce/services/tokenId.dart';
import 'package:e_commerce/update_product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_popup_menu_button/custom_popup_menu_button.dart';
import 'package:number_paginator/number_paginator.dart';
import './services/User_api.dart';
import './apis/orderModel.dart';
import './apis/ProductModel.dart';
import 'package:http/http.dart' as http;
import 'customWidgets/update_stock_dialog.dart';

class ManageProducts extends StatefulWidget {
  final String token, id;
  final List<String> selectedcategories;
  final Map<String, List<String>> selectedsubcategories;
  final double selectedminPrice, selectedmaxPrice;
  final sortt;
  const ManageProducts(
      {Key? key,
        required this.token,
        required this.id,
        required this.selectedcategories,
        required this.selectedsubcategories,
        required this.selectedminPrice,
        required this.selectedmaxPrice,
        required this.sortt,})
      : super(key: key);

  @override
  _ManageProductsState createState() => _ManageProductsState();
}

class _ManageProductsState extends State<ManageProducts> {

  void callSetState() {
    setState(() {});
  }
  bool okforfilter=true;
  String stockIn = 'In Stock';
  String stockOut = 'Out of stock';
  String sortt = "";
  bool isSelected = false;
  late ScrollController _scrollController = ScrollController();
  late Order order;
  late List<Product> product;
  String response1 = "";
  Future<List<Product>>? _productData;
  List<Product> data =[];
  bool _isLoading = false;
  int _currentPage = 1;
  bool ApproachedEnd=false;
  String queryyy = "";
  // late Timer _debounceTimer;


  @override
  void dispose() {
    // _debounceTimer.cancel();
    _scrollController.dispose();
    // if(ok)
    FilterOptions.clear();
    super.dispose();
  }

  @override
  initState()  {
    // _debounceTimer = Timer(Duration(milliseconds: 500), () {});

    sortt = widget.sortt;
    _scrollController.addListener(_scrollListener);
    if (FilterOptions.changed == true) {
      callfilterProduct();
    } else {
      callFetchProduct();
    }

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    Widget backButton = Navigator.canPop(context) ?
    IconButton(
      icon: Icon(Icons.arrow_back, color: Colors.white),
      onPressed: () {
        Navigator.pop(context);
      },
    ) :
    const SizedBox(width: 18,);
    String token = widget.token;
    String id = widget.id;
    print("token = " + token);
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 115,
          flexibleSpace: Column(
            children: [
              SizedBox(height:40),
              Padding(
                padding:  EdgeInsets.only(right: 18.0),
                child: Row(
                  children: [
                    backButton,
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: Colors.black, width: 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black38.withOpacity(0.5), //color of shadow
                              blurRadius: 7, // blur radius
                            ),
                            //you can set more BoxShadow() here
                          ],
                        ),
                        margin: const EdgeInsets.only(bottom: 5),
                        child: TextField(
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black, fontFamily: 'comfort'),
                          decoration: const InputDecoration(
                            hintText: 'search',
                            hintStyle: TextStyle(color: Colors.black),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.black,
                            ),
                            border: InputBorder.none,
                          ),
                          onChanged: (query) async {
                            // _debounceTimer.cancel();
                            // if(query=="") {
                              queryyy = query;
                              updateOnSearch(query);
                            //}
                            // Start a new timer to delay the search
                            // _debounceTimer = Timer(Duration(milliseconds: 500), () {
                            //   queryyy = query;
                            //   updateOnSearch(query);
                            // });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    if(Navigator.canPop(context))
                      SizedBox(width: 18.0,),
                    Expanded(
                      flex: 2,
                      child: InkWell(
                        onTap: () async {
                          okforfilter = false;
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) => FilterScreen(),
                          //     ));
                          openBottomSheet();

                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Container(
                            height: 50,
                            margin: const EdgeInsets.only(
                                left: 5, right: 2, top: 5),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.all(Radius.circular(30)),
                                border: Border.all(
                                    color: Colors.black, width: 1),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                    Colors.black38.withOpacity(0.5),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              margin: EdgeInsets.only(bottom: 5),
                              child: Center(
                                child: Row(
                                  children: [
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Image.asset(
                                      'assets/images/filter.png',
                                      width: 20,
                                    ),
                                    SizedBox(
                                      width: 6,
                                    ),
                                    Text('Filter',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontFamily: 'comfort',
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Container(
                          height: 50,
                          margin: EdgeInsets.only(left: 2, right: 5, top: 5),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: FlutterPopupMenuButton(
                              direction: MenuDirection.left,
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(20)),
                                  color: Colors.white),
                              popupMenuSize: const Size(220, 300),
                              child: FlutterPopupMenuIcon(
                                key: GlobalKey(),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(30)),
                                    border: Border.all(
                                        color: Colors.black, width: 1),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black38
                                            .withOpacity(0.5),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                  margin: EdgeInsets.only(bottom: 5),
                                  child: const Center(
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Icon(Icons.sort,
                                            color: Colors.black),
                                        SizedBox(
                                          width: 6,
                                        ),
                                        Text('Sort',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontFamily: 'comfort',
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              children: [
                                FlutterPopupMenuItem(
                                    onTap: () async {
                                      FilterOptions.sortChanged = true;
                                      FilterOptions.sortName = "minMrpPrice:asc";
                                      setState(() {
                                        data=[];
                                        sortt = "minMrpPrice:asc";
                                        _currentPage=1;ApproachedEnd=false;
                                        callFetchProduct();
                                      });
                                    },
                                    closeOnItemClick: true,
                                    child: ListTile(
                                      title: const Text('Price(Low to High)',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      leading: Container(
                                        height: 15, width: 15,
                                        decoration: BoxDecoration(
                                            color: Colors.redAccent.withOpacity(0.3),
                                            shape: BoxShape.circle),
                                      ),
                                    )),
                                FlutterPopupMenuItem(
                                    onTap: () {
                                      FilterOptions.sortChanged = true;
                                      FilterOptions.sortName = "minMrpPrice:desc";
                                      setState(() {
                                        data=[];
                                        sortt = "minMrpPrice:desc";
                                        _currentPage=1;ApproachedEnd=false;
                                        callFetchProduct();
                                      });
                                    },
                                    closeOnItemClick: true,
                                    child: ListTile(
                                      title: const Text('Price(High to Low)',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      leading: Container(
                                        height: 15, width: 15,
                                        decoration: BoxDecoration(
                                            color: Colors.redAccent.withOpacity(0.3),
                                            shape: BoxShape.circle),
                                      ),
                                    )),
                                FlutterPopupMenuItem(
                                    onTap: () {
                                      FilterOptions.sortChanged = true;
                                      setState(() {

                                      });
                                    },
                                    closeOnItemClick: true,
                                    child: ListTile(
                                      title: const Text('Most Selling',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      leading: Container(
                                        height: 15, width: 15,
                                        decoration: BoxDecoration(
                                            color: Colors.redAccent.withOpacity(0.3),
                                            shape: BoxShape.circle),
                                      ),
                                    )),
                                FlutterPopupMenuItem(
                                    onTap: () {
                                      FilterOptions.sortChanged = true;
                                      setState(() {

                                      });
                                    },
                                    closeOnItemClick: true,
                                    child: ListTile(
                                      title: const Text('Rating',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      leading: Container(
                                        height: 15, width: 15,
                                        decoration: BoxDecoration(
                                            color: Colors.redAccent.withOpacity(0.3),
                                            shape: BoxShape.circle),
                                      ),
                                    )),
                                FlutterPopupMenuItem(
                                    onTap: () {
                                      FilterOptions.sortChanged = true;
                                      setState(() {
                                        data=[];
                                        sortt="-createdAt";
                                        _currentPage=1;ApproachedEnd=false;
                                        callFetchProduct();
                                      });
                                    },
                                    closeOnItemClick: true,
                                    child: ListTile(
                                      title: const Text('Recently Added',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      leading: Container(
                                        height: 15, width: 15,
                                        decoration: BoxDecoration(
                                            color: Colors.redAccent.withOpacity(0.3),
                                            shape: BoxShape.circle),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: Colors.lightBlue.shade300,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        backgroundColor: Colors.white,
        body:   (data.isNotEmpty)?
    ListView.builder(
      shrinkWrap: true,
      controller: _scrollController,
      // scrollDirection: Axis.horizontal,
      itemCount: data.length+1,
      itemBuilder: (context, index) {
        if(index==data.length) {
          if(ApproachedEnd==false && data.isNotEmpty) return Center(child: CircularProgressIndicator(),);
          else return Column(
            children: [
              SizedBox(height: 10,),
              Text('No More Products Found',style: TextStyle(fontSize: 19),),
              SizedBox(height: 20,)
            ],
          );
        }
        Product prod = data[index];
        String s = prod.inStock.toString() == 'true' ? 'In stock' : 'Out of stock';
        String starRating = '';
        double prating = prod.globalProductID.productName.length % 6;
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
                    builder: (context) => ProductDetailsScreen(prod: prod, productId: prod.id)));
          },
          child: Container(
            color: Colors.grey.shade300,
            child: Card(
              margin: EdgeInsets.only(left: 10, right: 10, top: 6, bottom: 6),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    BorderRadius.all(
                        Radius.circular(10))),
                height: 170,
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Transform.scale(
                            scale: 0.7,
                            child: CupertinoSwitch(
                              activeColor: Colors.green,
                              value: prod.inStock,
                              onChanged: (bool value) {
                                // s = value == true ? 'In stock' : 'Out of stock';
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Update Product Stock'),
                                      content: StockUpdateDialog(prod: prod, callSetState: callSetState),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          Expanded(
                              flex: 2,
                              child: Container(
                                child: Text(s,
                                    style: TextStyle(
                                        color: Colors.green.shade900,
                                        fontSize: 11,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.bold)),
                              )),
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red.shade900,
                              size: 25,
                            ),
                            onPressed: () {
                              showDeleteConfirmationDialog(prod.id);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5,),
                    Expanded(
                      flex: 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Container(
                                margin: EdgeInsets.only(right: 15),
                                child: (prod.globalProductID.images.length > 0)
                                    ? Image.network(
                                  prod.globalProductID.images[0],
                                  height: 150, width: 80,
                                  fit: BoxFit.fill,
                                ) : Image.asset('assets/images/a1.jpg',
                                    height: 150, width: 80),
                              )),
                          Expanded(
                            flex: 2,
                            child:
                            Container(
                              child:
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      child:
                                      Container(
                                        // margin: EdgeInsets.only(left: 20),
                                        child: Text(prod.productName,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 19,
                                                fontFamily: 'comfart',
                                                fontWeight: FontWeight.bold)),
                                      )),
                                  Expanded(
                                    child:
                                    Row(
                                      children: [
                                        Text(
                                            '₹${prod.minMrpPrice.toString()}',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontFamily: 'comfort',
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text('MRP ''₹${prod.minMrpPrice.toString()}''${860}',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontFamily: 'comfort',
                                                decoration: TextDecoration.lineThrough)),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child:
                                    Container(
                                      width:
                                      100,
                                      height:
                                      18,
                                      decoration: const BoxDecoration(
                                        //  border: Border.all(color: Colors.black),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                      //   margin: EdgeInsets.only(right: 20),
                                      child:
                                      Text(starRating,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 13.5,
                                              fontFamily: 'comfort',
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                  Expanded(
                                    child:
                                    Container(
                                      width:
                                      220,
                                      child:
                                      MaterialButton(
                                        color: Colors.lightBlue.shade400,
                                        onPressed: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      UpdateProducts(
                                                        prod:prod,
                                                        imageList:prod.globalProductID.images,
                                                        pid: prod.id,
                                                        token: token,
                                                        id: id,
                                                        productName: prod.globalProductID.productName,
                                                        productCategory: prod.globalProductID.category,
                                                        productSubCategory1: prod.globalProductID.subCategory1,
                                                        productSubCategory2: prod.globalProductID.subCategory2,
                                                        quantityPricing: prod.productDetails,
                                                        stockTF: prod.inStock,
                                                        stockIO: s,
                                                        description: prod.globalProductID.description,
                                                      )));
                                        },
                                        child: Text(
                                          'Edit',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
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
          ),
        );
      },
    ) : Center(child: CircularProgressIndicator()) //Text('No Products Found',style: TextStyle(fontSize: 19),
    );
  }

  Future<void> showDeleteConfirmationDialog(String id) async {
    print("idddd12");
    print(id);
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Product?'),
          content: const Text('Are you sure you want to delete this product?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                // removeImage(0);
                print("iddd");
                print(id);
                UserApi.deleteProduct(id);
                setState(() {
                  Navigator.of(context).pop();
                });
                // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> openBottomSheet() async {
    // Wait for the bottom sheet to be closed
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible:false,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6, // Adjust the fraction as needed
          child: FilterScreen(),
        );
      },
    );

    // Call the method in the state after the bottom sheet is closed
    _currentPage=1;ApproachedEnd=false;
    callFetchProduct();
  }


  Future<void> updateOnSearch(query) async {
    _currentPage = 1;
    if (query.length == 0) {
      setState(() {
        if(data.length==0) {
          callFetchProduct();
        }
      });
      print(_productData);
    } else {
      data = await UserApi.filterProduct(sortt, query, _currentPage);
      setState(() {
      });
    }
  }


  void removeImage(int index) {
    setState(() {
      product.removeAt(index);
    });
  }

  //fetch product all
  Future<void> fetchProducts() async {
    if(_currentPage==1)
    data = await UserApi.filterProduct(sortt, queryyy, _currentPage);
    else
    data += await UserApi.filterProduct(sortt, queryyy, _currentPage);

    setState(() {
    });
  }

  //update Stock only
  Future<void> updateStock(bool value, ppid) async {
    // print(value);
    // print("value");
    print(TokenId.id);
    print(ppid);
    final apiUrl =
        'https://api.pehchankidukan.com/seller/${TokenId.id}/products/$ppid';
    final Map<String, dynamic> productJson;
    if (value == true)
      productJson = {"inStock": "true"};
    else
      productJson = {"inStock": "false"};
    var uri = Uri.parse(apiUrl);
    try {
      final response = await http.put(
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

  void _scrollListener() {
    if (!_isLoading && _scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent-1500 ) {
      _loadMoreData();
    }
  }

  Future<void> _loadMoreData() async {
    if(ApproachedEnd==true)return;
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });
      _currentPage++;
      List<Product> newData = await UserApi.filterProduct(sortt, queryyy, _currentPage );
      if(newData.length==0)ApproachedEnd=true;
      setState(() {
        data += newData;
        _isLoading = false;
      });
    }
  }

  void callFetchProduct() {
      fetchProducts();
  }

  void callfilterProduct() {
    Userapifilterproductcall();
  }

  Future<void> Userapifilterproductcall() async {
    if(_currentPage == 1)
    data = await UserApi.filterProduct(sortt, queryyy, _currentPage);
    else
    data += await UserApi.filterProduct(sortt, queryyy, _currentPage);

    setState(() {});
  }
}

