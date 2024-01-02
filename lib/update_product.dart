import 'dart:convert';
import 'dart:io';
import 'package:e_commerce/services/User_api.dart';
import 'package:e_commerce/services/category_api.dart';
import 'package:e_commerce/services/tokenId.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'add_product.dart';
import 'apis/ProductModel.dart';
import 'customWidgets/update_stock_dialog.dart';
import 'main_dashboard.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;

class UpdateProducts extends StatefulWidget {
  // String productImage = '';
  String productName = '';
  String productCategory = '';
  String productSubCategory1 = '';
  String productSubCategory2 = '';
  final List quantityPricing;
  // String productType = '';
  bool stockTF = true;
  String stockIO = '';
  String description = '';
  final String token, id;
  final String pid;
  final List<String> imageList;
  final Product prod;
  UpdateProducts(
      {Key? key,
      required this.pid,
      required this.token,
      required this.id,
      required this.productName,
      required this.productCategory,
      required this.productSubCategory1,
      required this.productSubCategory2,
      required this.stockTF,
      required this.stockIO,
      required this.description,
      required this.quantityPricing,
      required this.prod,
      required  this.imageList})
      : super(key: key);

  @override
  _UpdateProductsState createState() => _UpdateProductsState();
}

class _UpdateProductsState extends State<UpdateProducts> {
  void callSetState() {
    setState(() {

    });
  }
  List<ItemOption> itemOptions = [];
  late List dummyProductList;

  void handleOptionAdded(ItemOption itemOption) {
    // dummyProductList.add(QuantityPricing(offerPrice: int.parse(itemOption.offerPrice),
    //     quantity: itemOption.price, mrpPrice: double.parse(itemOption.quantity), unit: itemOption.unit));
    setState(() {
      itemOptions.add(itemOption);
    });
  }

  late String s = widget.stockIO;
  late bool _switchValue = widget.stockTF;
  String stock = 'In Stock';

  late String pType = 'Veg';

  // var items = [
  //   'gm',
  //   'ml',
  //   'pic',
  // ];
  var items2 = [
    'Veg',
    'Non Veg',
  ];

  String units = 'kg';
  List<String> dropDownItems =
    ["KG", "G", "L", "ML", "PACK OF", "BOX", "BAG", "CAN"];

  final qController = TextEditingController();

  String AllpCategory = '';
  final pName = TextEditingController();
  String pCategory = '';
  String pSCategory1 = '';
  String pSCategory2 = '';
  final description = TextEditingController();

  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? imageFileList = [];

  void selectImages() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      imageFileList!.addAll(selectedImages);
    }
    print("Image List Length:" + imageFileList!.length.toString());
    setState(() {});
  }

  List<String> imgList = [];


  @override
  void initState() {
    super.initState();
    pCategory = widget.prod.globalProductID.category;
    pSCategory1 = widget.productSubCategory1;
    pSCategory2 = widget.productSubCategory2;
  }

  @override
  Widget build(BuildContext context) {
    if(widget.prod.globalProductID.images.length>0)
      imgList = widget.prod.globalProductID.images;
    dummyProductList = widget.quantityPricing;
    print("dummyProductList1234");
    print(dummyProductList);
    print(widget.pid);
    print("pid");

    var data = dummyProductList.length;
    print(data);

    String token = widget.token;
    String id = widget.id;
    pName.text = widget.productName;
    print(pName.text);
    print("pName.text");

    description.text = widget.description;
    AllpCategory = '$pCategory / $pSCategory1';
    if (pSCategory2 != '') {
      AllpCategory += '/ $pSCategory2';
    }
    print("AllpCategory");
    print(AllpCategory);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                "Update Product",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.lightBlue.shade900,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.white,
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CupertinoSwitch(
                                activeColor: Colors.green,
                                value: _switchValue,
                                onChanged: (bool value) {
                                  s = value == false ? 'In stock' : 'Out of stock';
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Update Product Stock'),
                                        content: StockUpdateDialog(prod: widget.prod, callSetState: callSetState),
                                      );
                                    },
                                  );
                                },
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 0),
                                child: Center(
                                  child: Text(s,
                                      style: TextStyle(
                                          color: Colors.green.shade900,
                                          fontSize: 18,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Product Images:",
                                  textScaleFactor: 1.2,
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                              (imgList.length>0) ?
                              Container(
                                height: 120,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GridView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: imgList.length,
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1, mainAxisSpacing: 5),
                                      itemBuilder: (BuildContext context, int index) {
                                        return Stack(
                                          children: [
                                            Container(
                                              height:100,
                                              width: 100,
                                              child: Hero(
                                                tag: 'image_$index',
                                                child: GestureDetector(
                                                  onTap: () {
                                                    showImageExpansion(index);
                                                  },
                                                  child: Image.network(
                                                    imgList[index],
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: -10,
                                              right: -5,
                                              child: IconButton(
                                                icon: Icon(
                                                  Icons.cancel_outlined,
                                                  color: Colors.cyanAccent,
                                                ),
                                                onPressed: () {
                                                  showDeleteConfirmationDialog(index);
                                                  // removeImage(index);
                                                },
                                              ),
                                            ),
                                          ],
                                        );
                                      }),
                                ),
                              ) :
                              Center(
                                child: Container(
                                    height:20,
                                    child: Text('No Images Available',style: TextStyle(fontSize: 17),)),
                              ),
                            ],
                          )),
                      pCategory.isNotEmpty
                          ?Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                            child: const Text(
                              'Category :',
                              style: TextStyle(
                                fontSize: 17,
                                fontFamily: 'Poppins',
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: Text(AllpCategory.toString()),
                          ),
                        ],
                      )
                          : Container(),
                      // SizedBox(height: 15),
                      Container(
                        margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                        child: Text(
                          'Product Name',
                          style: TextStyle(
                            fontSize: 17,
                            fontFamily: 'Poppins',
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        child: TextField(
                          controller: pName,
                          enabled: false,
                          style: TextStyle(
                              color: Colors.black87,
                              fontFamily: 'Poppins', fontSize: 15),
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.teal.shade900)),
                          ),
                        ),
                      ),

                      pCategory == 'Food'?
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20, top: 25),
                            child: const Text(
                              'Product Type (Veg/Non-veg,/in case if applicable)',
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'Poppins',
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: DropdownButton(
                              value: pType,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: items2.map((String items2) {
                                return DropdownMenuItem(
                                  value: items2,
                                  child: Text(items2),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  pType = newValue!;
                                });
                              },
                            ),
                          ),
                        ],
                      ):Container(),
                      Container(
                        margin: EdgeInsets.only(left: 20, right: 20,top: 10),
                        child: Text(
                          'Product Description',
                          style: TextStyle(
                            fontSize: 17,
                            fontFamily: 'Poppins',
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.only(left: 20, right: 20, bottom: 10),
                        child: TextField(
                          controller: description,
                          enabled: false,
                          style: TextStyle(
                              color: Colors.black87,
                              fontFamily: 'Poppins', fontSize: 15),
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.teal.shade900)),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                        child: Text(
                          'Product Quantity/Price',
                          style: TextStyle(
                            fontSize: 17,
                            fontFamily: 'Poppins',
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Container(
                        height: 188.0 * (data),
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: dummyProductList.length,
                          itemBuilder: (BuildContext context, int index) {
                            final product = dummyProductList[index];
                            // final productUnit = product["unit"];
                            return Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 20, right: 20),
                                  child: Text(
                                    'Variant ${(index + 1).toString()}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: 'Poppins',
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(15),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              controller: TextEditingController(
                                                  text: product.quantity),
                                              // onChanged: (value) => option.quantity = value,
                                              onChanged: (value) {
                                                itemOptions[index].quantity =
                                                    value ;
                                              },
                                              decoration: InputDecoration(
                                                hintText: 'Quantity',
                                                label: const Text('Quantity'),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                              ),
                                              style: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(1.0),
                                                fontSize: 16,
                                                fontFamily: 'Urbanist',
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Container(
                                            height: 60,
                                            padding: const EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                width: 1,
                                                color: Colors.black,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: DropdownButton<String>(
                                              value: product.unit,
                                              onChanged: (String? value) {
                                                setState(() {
                                                  product.unit = value!;
                                                });
                                              },
                                              items: dropDownItems
                                                  .map((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(
                                                    value,
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontFamily: 'Urbanist',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                          SizedBox(width: 20,),
                                          InkWell(
                                            onTap: () {

                                             setState(() {
                                               showDeleteConfirmationVarient(index);
                                             });
                                            },
                                            child: Icon(
                                              size:35,
                                              Icons.delete_outlined,
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 8,),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              controller: TextEditingController(
                                                  text: product.mrpPrice.toString()),
                                              onChanged: (value) {
                                                itemOptions[index].price = value;
                                              },
                                              decoration: InputDecoration(
                                                hintText: 'Price (In Rs.)',
                                                label: const Text('Price (In Rs.)'),
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(15),
                                                ),
                                              ),
                                              style: TextStyle(
                                                color: Colors.black.withOpacity(1.0),
                                                fontSize: 16,
                                                fontFamily: 'Urbanist',
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 16),
                                          Expanded(
                                            child: TextFormField(
                                              keyboardType: TextInputType.number,
                                              controller: TextEditingController(
                                                  text: product.offerPrice.toString()),
                                              onChanged: (value) {
                                                itemOptions[index].offerPrice = value;
                                              },
                                              decoration: InputDecoration(
                                                hintText: 'Offer Price',
                                                label: const Text('Offer Price'),
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(15),
                                                ),
                                              ),
                                              style: TextStyle(
                                                color: Colors.black.withOpacity(1.0),
                                                fontSize: 16,
                                                fontFamily: 'Urbanist',
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      PriceQuantitySpinnerRow(
                          options: itemOptions,
                          onOptionAdded: handleOptionAdded,
                          updateInitialValue:
                              (pControllers, oController, qController) {}),
                      Container(
                        width: double.maxFinite,
                        margin: const EdgeInsets.only(
                            left: 20, right: 20, top: 20, bottom: 30),
                        // color: Colors.lightBlue.shade500,
                        child: ElevatedButton(
                          onPressed: () {
                            saveProductData(imageFileList!, pName, pSCategory2, description,
                                token, id, widget.pid, dummyProductList, true);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors
                                .lightBlue, // Set the background color to white
                          ),
                          child: const Text(
                            'Update Product',
                            style: TextStyle(color: Colors.white, fontSize: 17),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void DeleteExistedVarient(int index) {

  }

//update Stock only
  Future<void> updateStock(bool value) async {
    print(value);
    print("value");
    print(widget.pid);
    final apiUrl =
        'https://api.pehchankidukan.com/seller/${TokenId.id}/products/${widget.pid}';
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
    setState(() {});
  }

  Future<void> saveProductData(
  List<XFile> imageFileList, TextEditingController pName, String pSCategory2, TextEditingController
      description, String token, String id, String pid, dummyProductList, toSave) async {
    print("dummyProductList");
    itemOptions.forEach((itemOption) {
      dummyProductList.add(QuantityPricing(
          offerPrice: double.parse(itemOption.offerPrice),
          quantity: (itemOption.quantity),
          mrpPrice: double.parse(itemOption.price),
          unit: itemOption.unit, inStock: true));
    });
    itemOptions = [];
    print(dummyProductList.length);
    if (toSave) {
      print("updatinggggg");
      await UserApi.updateProduct(pid, dummyProductList);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) =>
                MainDashboard(token: token, id: id, pageIndex: 2, sortt: "")),
        (route) => false,
      );
    }
  }


  Future<void> removeImage(int index) async {
    //we have to change condition this one later
    print("lengthhh");
    print(widget.prod.globalProductID.images.length);
    await UserApi.deleteImage(widget.prod.globalProductID.images[index], widget.pid);
    setState(() {
      imgList.removeAt(index);
      widget.prod.globalProductID.images.removeAt(index);
      print("lengthhh");
      print(widget.prod.globalProductID.images.length);
    });
  }
  Future<void> showDeleteConfirmationDialog(int index) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Image?'),
          content: Text('Are you sure you want to delete this image?'),
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
                removeImage(index); // Remove the image from the list
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
  Future<void> showDeleteConfirmationVarient(int index) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Varient'),
          content: Text('Are you sure you want to delete this Price Varient'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                setState(() {
                  dummyProductList.removeAt(index);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showImageExpansion(int index) {
    Navigator.of(context ).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Expanded Image'),
            ),
            body: Center(
              child: Hero(
                tag: 'image_$index',
                child: Image.network(
                  imgList[index],
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  void removeCameraImage(int index) {
    setState(() {
      imageFileList!.removeAt(index);
    });
  }
  Future<void> showCameraDeleteConfirmationDialog(int index) async {
    return showDialog(
      context: context ,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Image?'),
          content: Text('Are you sure you want to delete this image?'),
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
                removeCameraImage(index); // Remove the image from the list
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
  void showCameraImageExpansion(int index) {
    Navigator.of(context ).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Expanded Image'),
            ),
            body: Center(
              child: Hero(
                  tag: 'image_$index',
                  child: Image.file(
                    File(imageFileList![index].path),
                    fit: BoxFit.cover,
                  )),
            ),
          );
        },
      ),
    );
  }
  Widget categoryDialog() {
    return Container(
      height: 600,
      width: 500,
      child: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
              future: getCategory(TokenId.token),
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
                  final items = snapshot.data!.data;
                  return Column(
                    children: items.map((item) {
                      return ListTile(
                        onTap: () {
                          setState(() {
                            pCategory = item.toString();
                          });
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Row(
                                  children: [
                                    InkWell(
                                      onTap: () => Navigator.pop(context),
                                      child: const Icon(Icons.arrow_back_ios),
                                    ),
                                    const SizedBox(width: 5),
                                    const Text("Sub Category 1"),
                                  ],
                                ),
                                content: subCategory1Dialog(),
                              );
                            },
                          );
                        },
                        leading: CircleAvatar(),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                        ),
                        title: Text(
                          item.toString(),
                          style: TextStyle(fontSize: 14),
                        ),
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
  Widget subCategory1Dialog() {
    return Container(
      height: 600,
      width: 500,
      child: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
              future: getSubCategory(TokenId.token, pCategory),
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
                  print("adfghjkl");
                  print(snapshot.data!.data.length);
                  final items = snapshot.data!.data;
                  return Column(
                    children: items.map((item) {
                      return ListTile(
                        onTap: () {
                          setState(() {
                            pSCategory1 = item;
                          });
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Row(
                                  children: [
                                    InkWell(
                                      onTap: () => Navigator.pop(context),
                                      child: Icon(Icons.arrow_back_ios),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      "Sub Category 2",
                                    ),
                                  ],
                                ),
                                content: subCategory2Dialog(),
                              );
                            },
                          );
                        },
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                        ),
                        title: Text(
                          item,
                          style: TextStyle(fontSize: 14),
                        ),
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
  Widget subCategory2Dialog() {
    return Container(
      height: 600,
      width: 500,
      child: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
              future: getSubCategory2(TokenId.token, pCategory, pSCategory1),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("Error : ${snapshot.error}"),
                  );
                } else if (snapshot.data!.data.length == 0) {
                  Future.delayed(Duration(milliseconds: 1), () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    pSCategory2 = '';
                    setState(() {});
                  });
                  return Center(
                    child: Text("No subcategories available for the selected criteria."),
                  );
                } else {
                  return Column(
                    children: snapshot.data!.data.map((subCategory) {
                      return ListTile(
                        onTap: () {
                          setState(() {
                            pSCategory2 = subCategory;
                          });
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        title: Text(
                          subCategory,
                          style: TextStyle(fontSize: 14),
                        ),
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

}




class PriceQuantitySpinnerRow extends StatefulWidget {
   List<ItemOption> options;
  final ValueChanged<ItemOption> onOptionAdded;
  final Function(List<TextEditingController>, List<TextEditingController>,
      List<TextEditingController>) updateInitialValue;

  PriceQuantitySpinnerRow({
    required this.options,
    required this.onOptionAdded,
    required this.updateInitialValue,
  });

  @override
  _PriceQuantitySpinnerRowState createState() =>
      _PriceQuantitySpinnerRowState();
}

class _PriceQuantitySpinnerRowState extends State<PriceQuantitySpinnerRow> {


  ItemOption newItem = ItemOption(
    price: "",
    quantity: "",
    unit: 'KG',
    offerPrice: "",
  );
  List<String> dropDownItems = ["KG", "G", "L", "ML", "PACK OF", "BOX", "BAG", "CAN"];

  void addOption() {
    widget.onOptionAdded(newItem);
    newItem = ItemOption(
      price: "",
      quantity: "",
      unit: 'KG',
      offerPrice: "",
    );
  }

  bool _validate4 = false;
  bool _validate5 = false;
  bool _validate6 = false;
  List<ItemOption> options=[];// = widget.options;
  @override
  void initstate() {
    options = widget.options;
  }

  @override
  Widget build(BuildContext context) {
    options = widget.options;
    return Column(
      children: [
        Column(
         children: options.asMap().entries.map((entry) {
            int index = entry.key;
            ItemOption option = entry.value;
            return Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller:
                          TextEditingController(text: option.quantity.toString()),
                          onChanged: (value) => option.quantity = value ,
                          decoration: InputDecoration(
                            hintText: 'Quantity',
                            label: const Text('Quantity'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            errorText: _validate4 ? 'Value Can\'t Be Empty' : null,
                          ),
                          style: TextStyle(
                            color: Colors.black.withOpacity(1.0),
                            fontSize: 16,
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Container(
                        height: 60,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButton<String>(
                          value: option.unit,
                          onChanged: (String? value) {
                            setState(() {
                              option.unit = value!;
                            });
                          },
                          items: dropDownItems.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'Urbanist',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(width: 25,),
                      InkWell(
                        onTap: () {
                          print("asdfdfadsfasdfasdfads");
                          showDeleteConfirmationVarient1(index);
                        },
                        child: Icon(
                          size:35,
                          Icons.delete_outlined,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller:
                          TextEditingController(text: option.price.toString()),
                          onChanged: (value) => option.price = value ,
                          decoration: InputDecoration(
                            hintText: 'Price (In Rs.)',
                            label: const Text('Price (In Rs.)'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            errorText:
                            _validate5 ? 'Value Can\'t Be Empty' : null,
                          ),
                          style: TextStyle(
                            color: Colors.black.withOpacity(1.0),
                            fontSize: 16,
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: TextEditingController(
                              text: option.offerPrice.toString()),
                          onChanged: (value) => option.offerPrice = value,
                          decoration: InputDecoration(
                            hintText: 'Offer Price',
                            labelText: 'Offer Price',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            errorText:
                            _validate6 ? 'Value Can\'t Be Empty' : null,
                          ),
                          style: TextStyle(
                            color: Colors.black.withOpacity(1.0),
                            fontSize: 16,
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        Center(
          // margin: EdgeInsets.only(left: 20),
            child: ElevatedButton(
              onPressed: addOption,
              child: Text("Add items"),
            )),
      ],
    );
  }
  Future<void> showDeleteConfirmationVarient1(int index) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Varient'),
          content: Text('Are you sure you want to delete this Price Varient'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                setState(() {
                  options.removeAt(index);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}

