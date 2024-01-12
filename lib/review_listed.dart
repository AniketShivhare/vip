import 'dart:convert';
import 'package:e_commerce/DataSaveClasses/ProductId.dart';
import 'package:e_commerce/services/User_api.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:e_commerce/services/tokenId.dart';
import 'package:e_commerce/sucessfully_add.dart';
import 'package:flutter/material.dart';
import 'add_product.dart';
import 'apis/ProductModel.dart';
import 'main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ReviewListed extends StatefulWidget {
  List<XFile> imageFileList = [];
  List<ItemOption> itemOptions = [];
  String productName = '';
  String productType = '';
  String description = '';
  String category = '';
  String subCategory1 = '';
  String subCategory2 = '';
  String Gpid = '';
  String barCodeNumber = '';
  String brandName = '';
  List<TextEditingController> searchKeywordsList = [];

  ReviewListed(
      {Key? key,
      required this.imageFileList,
      required this.itemOptions,
      required this.productName,
      required this.productType,
      required this.description,
      required this.category,
      required this.subCategory1,
      required this.subCategory2,
      required this.Gpid,
      required this.barCodeNumber,
      required this.brandName,
      required this.searchKeywordsList})
      : super(key: key);

  @override
  _ReviewListedState createState() => _ReviewListedState();
}

class _ReviewListedState extends State<ReviewListed> {
  @override
  Widget build(BuildContext context) {
    String pName = widget.productName;
    String pType = widget.productType;
    String pDescription = widget.description;
    String token = TokenId.token;
    String id = TokenId.id;
    List dummyProductList = [];
    String brandname = widget.brandName;
    String barcode = widget.barCodeNumber;
    List<String> KeywordsList =
        widget.searchKeywordsList.map((e) => e.text).toList();
    String keywords = jsonEncode(KeywordsList);
    Future<void> postProductData() async {
      final url =
          Uri.parse('https://api.pehchankidukan.com/seller/$id/products');
      // Create item options
      final itemOptions = widget.itemOptions;
      itemOptions.forEach((itemOption) {
        dummyProductList.add(QuantityPricing(
            offerPrice: double.parse(itemOption.offerPrice),
            quantity: double.parse(itemOption.quantity),
            mrpPrice: double.parse(itemOption.price),
            maxOrderQuantity: double.parse(itemOption.maxOrderQuantity),
            unit: itemOption.unit,
            inStock: false));
      });
      print("pidddd1");
      print("barcodeNmber");
      print(widget.barCodeNumber);
      print(ProductId.categoryCheck);
      if (ProductId.categoryCheck == true) {
        print("mAXQuantityyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy");
        print(dummyProductList);
        final pid = await UserApi.createProduct(
            widget.Gpid,
            pName,
            widget.category,
            widget.subCategory1,
            widget.subCategory2,
            pDescription,
            token,
            id,
            dummyProductList);
        print("mAXQuantityyzzzzzzzzzzzzzzzzzzzzzzzzzzzz");
      }
      try {
        // Add each image file to the request
        if (ProductId.categoryCheck == false) {
          final url1 =
              'https://api.pehchankidukan.com/seller/${TokenId.id}/products';
          var request = http.MultipartRequest('POST', (Uri.parse(url1)));
          request.headers['Authorization'] = 'Bearer ${TokenId.token}';
          request.fields['productName'] = pName;
          request.fields['category'] = widget.category;
          request.fields['subCategory1'] = widget.subCategory1;
          request.fields['subCategory2'] = widget.subCategory2;

          print("keywordList:");
          print(KeywordsList);
          if (KeywordsList.length > 0) {
            // String keywordsJson = jsonEncode(KeywordsList);
            // request.fields['searchKeywords'] = keywordsJson;
            for (int i = 0; i < KeywordsList.length; i++) {
              request.fields['searchKeywords[$i]'] = KeywordsList[i];
            }
          }
          print("barcodeNmber");
          print(widget.barCodeNumber);
          if (widget.barCodeNumber.length > 0)
            request.fields['barCodeNumber'] = widget.barCodeNumber;
          if (widget.brandName.length > 0)
            request.fields['brandName'] = widget.brandName;
          print('dummyProductList');
          print(dummyProductList);

          print(jsonEncode(dummyProductList));

          for (int i = 0; i < dummyProductList.length; i++) {
            final product = dummyProductList[i];
            final productJson = product.toJson();
            for (var key in productJson.keys) {
              request.fields['productDetails[$i][$key]'] =
                  productJson[key].toString();
            }
          }

          print("length");
          print(widget.imageFileList.length);
          if (widget.imageFileList.length > 0) {
            for (var imageFile in widget.imageFileList) {
              int length = await imageFile.length();
              String fileName = basename(imageFile.path);
              request.files.add(http.MultipartFile(
                'images', // Field name in the form
                imageFile.readAsBytes().asStream(),
                length,
                filename: fileName,
                contentType: MediaType(
                    'image[]', 'jpeg'), // Adjust content type accordingly
              ));
            }
          }
          print("bbbbbbbbbbbbbbbaaaaaaaaaaaaaaaaaaaaaaa");
          final response = await request.send();
          print("bbbbbbbbbbbbbbb");
          if (response.statusCode == 201) {
            print('POST images request successful');
            print('Response: ${await response.stream.bytesToString()}');
          } else {
            print('Failed to make POST request: ${response.statusCode}');
            print('Response: ${await response.stream.bytesToString()}');
          }
        }
      } catch (error) {
        print('Error: $error');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                "Review",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
            Spacer(),
            Expanded(
                child: Icon(
              Icons.notifications,
              color: Colors.white,
            )),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.lightBlue.shade900,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.grey.shade200,
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 45,
                decoration: BoxDecoration(
                    color: Colors.lightBlue.shade900,
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30))),
                child: Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 23,
                      width: 23,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(6))),
                      child: Center(
                          child: Text(
                        '1',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                    ),
                    Text(
                      '-----------',
                      style: TextStyle(color: Colors.white),
                    ),
                    Container(
                      height: 23,
                      width: 23,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(6))),
                      child: Center(
                          child: Text(
                        '2',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                    ),
                    Text(
                      '-----------',
                      style: TextStyle(color: Colors.white),
                    ),
                    Container(
                      height: 23,
                      width: 23,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.all(Radius.circular(6))),
                      child: Center(
                          child: Text(
                        '3',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                    ),
                    //Text('Add Product',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15,fontFamily: 'Poppins', ),),
                  ],
                )),
              ),
              Container(
                margin: EdgeInsets.only(right: 20, left: 20, top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Text(
                        'Review',
                        style: TextStyle(
                            fontSize: 25,
                            fontFamily: 'Poppins',
                            color: Colors.black87,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Container(
                      //     margin: EdgeInsets.only(left: 20,right: 20,top: 10),
                      //     child: Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Text("Product Image:",textScaleFactor: 1.2,style: TextStyle(fontWeight: FontWeight.bold)),
                      //         Container(
                      //           height: 150,
                      //
                      //           child: Padding(
                      //             padding: const EdgeInsets.all(8.0),
                      //             child: GridView.builder(
                      //                 scrollDirection: Axis.horizontal,
                      //                 itemCount: widget.imageFileList!.length,
                      //                 gridDelegate:
                      //                 SliverGridDelegateWithFixedCrossAxisCount(
                      //                     crossAxisCount: 1,
                      //                     mainAxisSpacing: 5),
                      //                 itemBuilder:
                      //                     (BuildContext context, int index) {
                      //                   return Image.file(
                      //                     File(widget.imageFileList![index].path),
                      //                     fit: BoxFit.cover,
                      //                   );
                      //                 }),
                      //           ),
                      //         ),
                      //       ],
                      //     )),
                      Container(
                          margin: EdgeInsets.only(left: 20, right: 20, top: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Product Category:",
                                  textScaleFactor: 1.0,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(widget.category, textScaleFactor: 1.2),
                            ],
                          )),
                      Container(
                          margin: EdgeInsets.only(left: 20, right: 20, top: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Product SubCategory1:",
                                  textScaleFactor: 1.0,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(widget.subCategory1, textScaleFactor: 1.2),
                            ],
                          )),
                      Container(
                          margin: EdgeInsets.only(left: 20, right: 20, top: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Product SubCategory2:",
                                  textScaleFactor: 1.0,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(widget.subCategory2, textScaleFactor: 1.2),
                            ],
                          )),
                      Container(
                          margin: EdgeInsets.only(left: 20, right: 20, top: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Product Name:",
                                  textScaleFactor: 1,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(pName, textScaleFactor: 1.2),
                            ],
                          )),
                      Container(
                          margin: EdgeInsets.only(left: 20, right: 20, top: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Product Barcode Number:",
                                  textScaleFactor: 1,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(barcode, textScaleFactor: 1.2),
                            ],
                          )),

                      Container(
                          margin: EdgeInsets.only(left: 20, right: 20, top: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Product Type:",
                                  textScaleFactor: 1,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(pType, textScaleFactor: 1.2),
                            ],
                          )),
                      Container(
                          margin: EdgeInsets.only(left: 20, right: 20, top: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Product Description:",
                                  textScaleFactor: 1,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(pDescription, textScaleFactor: 1.2),
                            ],
                          )),
                      Container(
                          margin: EdgeInsets.only(left: 20, right: 20, top: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Product Brand Name:",
                                  textScaleFactor: 1,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(brandname, textScaleFactor: 1.2),
                            ],
                          )),
                      Container(
                          margin: EdgeInsets.only(left: 20, right: 20, top: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Search Keywords:",
                                  textScaleFactor: 1,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(keywords, textScaleFactor: 1.2),
                            ],
                          )),
                      Container(
                          margin: EdgeInsets.only(left: 20, right: 20, top: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Product Variants:",
                                  textScaleFactor: 1,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          )),
                      Container(
                        // margin: EdgeInsets.only(left: 10, right: 10),
                        child: const ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Variant'),
                              Text('Price'),
                              Text('Offer'),
                              Text('Quantity'),
                              Text('Unit'),
                              Text('Max'),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 100,
                        margin: EdgeInsets.only(left: 20, right: 20),
                        child: ListView.builder(
                          itemCount: widget.itemOptions.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${(index + 1).toString()}'),
                                  Text(widget.itemOptions[index].price
                                      .toString()),
                                  Text(widget.itemOptions[index].offerPrice
                                      .toString()),
                                  Text(widget.itemOptions[index].quantity
                                      .toString()),
                                  Text(widget.itemOptions[index].unit),
                                  Text(widget
                                      .itemOptions[index].maxOrderQuantity)
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.maxFinite,
                margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                child: MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Edit',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  color: Colors.lightBlue.shade500,
                  height: 40,
                ),
              ),
              Container(
                width: double.maxFinite,
                margin:
                    EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 30),
                child: MaterialButton(
                  onPressed: () {
                    ProductId.categoryCheck = false;
                    postProductData();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SuccessfulAdd(
                            token: TokenId.token,
                            id: TokenId.id,
                          ),
                        ));
                  },
                  child: Text(
                    'Review And Post',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  color: Colors.lightBlue.shade700,
                  height: 40,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
