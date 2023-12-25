import 'dart:io';

import 'package:e_commerce/DataSaveClasses/ProductId.dart';
import 'package:e_commerce/review_listed.dart';
import 'package:e_commerce/services/User_api.dart';
import 'package:e_commerce/services/category_api.dart';
import 'package:e_commerce/services/tokenId.dart';
import 'package:flutter/material.dart';
import 'addFromExistingProduct.dart';
import 'package:image_picker/image_picker.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'apis/ProductSearchModel.dart';



class AddProduct extends StatefulWidget {
  final String productName;
  final String productDescription;
  final List productDetails;
  final List<ItemOption> itemOptions;
   AddProduct(
      {Key? key,
      required this.productName,
      required this.productDescription,
      required this.productDetails,
      required this.itemOptions})
      : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final GlobalKey<AutoCompleteTextFieldState<Product2>> key = GlobalKey();
  final GlobalKey<AutoCompleteTextFieldState<Product2>> key1 = GlobalKey();

  TextEditingController productNameContt = TextEditingController();
  TextEditingController _searchController = TextEditingController();
  List<Product2> _suggestions = [];



  String category = "";
  String subCategory1 = "";
  String subCategory2 = "";
   List<ItemOption> itemOptions =[];
  TextEditingController productDescriptionController = TextEditingController();
  PageController pageController = PageController();
  String AllpCategory = "";
  final ImagePicker imagePicker = ImagePicker();
  List<XFile> imageFileList = [];
  bool viewMore = false;
  String viewML = 'View more categories';
  bool _validate1 = false;
  bool _validate2 = false;
  String productType = 'Veg';
  final _formkey = GlobalKey<FormState>();
  String productCategoryType = 'Food';
  TextEditingController productTypeContt = TextEditingController();
  TextEditingController productDescriptionContt = TextEditingController();
  FocusNode descriptionFocusNode = FocusNode();
// Initialize the FocusNode in your build method or constructor.

  @override
  void initState() {
    print("Token = ${TokenId.token}");
    print("id = ${TokenId.id}");
    valueUpdate(widget.productName, widget.productDescription);
    category=ProductId.cat;
    subCategory1 = ProductId.subCat1;
    subCategory2 = ProductId.subCat2;
    itemOptions=[ItemOption(
      price: "",
      quantity: "",
      unit: 'kg',
      offerPrice: "",
    )];
  }

  @override
  void dispose() {
    super.dispose();
    ProductId.reset();
  }

  @override
  Widget build(BuildContext context) {
    var items2 = [
      'Veg',
      'Non Veg',
      'Not required',
    ];
    descriptionFocusNode.addListener(() {
      if (!descriptionFocusNode.hasFocus) {
        setState(() {
          _validate2 = productDescriptionContt.text.isEmpty;
        });
      }
    });
    AllpCategory = '$category / $subCategory1';
    if (subCategory2 != '') {
      AllpCategory += '/ $subCategory2';
    }
    print(AllpCategory);
    return GestureDetector(
      onTap: _onScreenTap,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductSelectionPage()));
                },
                child:  Text(
                  "Add Product",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
          centerTitle: true,
          backgroundColor: Colors.lightBlue.shade100,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 45,
                decoration: BoxDecoration(
                    color: Colors.lightBlue.shade100,
                    borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30))),
                child: Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 23,
                      width: 23,
                      decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(6))),
                      child: const Center(
                          child: Text(
                        '1',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                    ),
                    const Text(
                      '-----------',
                      style: TextStyle(color: Colors.white),
                    ),
                    Container(
                      height: 23,
                      width: 23,
                      decoration: const BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.all(Radius.circular(6))),
                      child: const Center(
                          child: Text(
                        '2',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                    ),
                    const Text(
                      '-----------',
                      style: TextStyle(color: Colors.white),
                    ),
                    Container(
                      height: 23,
                      width: 23,
                      decoration: const BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.all(Radius.circular(6))),
                      child: const Center(
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
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 15, right: 20, top: 5),
                        child: const Text(
                          'Fill your product details correctly',
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              color: Colors.black87,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      category.isNotEmpty && subCategory1.isNotEmpty ||
                              subCategory2.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 20, right: 20, top: 20),
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
                      const SizedBox(height: 10),
                      ProductId.categoryCheck==false ?
                      Container(
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Choose Category'),
                                  content: categoryDialog(),
                                );
                              },
                            );
                          },
                          child: const Text('Choose Category'),
                        ),
                      ):Container(),
                      Container(
                        margin:
                            const EdgeInsets.only(right: 20, top: 20, left: 20),
                        child: const Text(
                          'Add Images',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Poppins',
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                selectImages();
                              },
                              child: Container(
                                  height: 80,
                                  width: 80,
                                  margin: const EdgeInsets.only(
                                      left: 20, right: 20, top: 10, bottom: 5),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(13)),
                                  ),
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.camera_alt),
                                      Icon(Icons.add_circle_outline),
                                    ],
                                  )),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              height: 120,
                              width: 100,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GridView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: imageFileList.length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 1,
                                            mainAxisSpacing: 5),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Stack(
                                        children: [
                                          Container(
                                            height:100,
                                            width: 100,
                                            child: Hero(
                                              tag: 'image_$index',
                                              child: GestureDetector(
                                                  onTap: () {
                                                    showCameraImageExpansion(
                                                        index);
                                                  },
                                                  child: Image.file(
                                                    File(imageFileList[index]
                                                        .path),
                                                    fit: BoxFit.cover,
                                                  )),
                                            ),
                                          ),
                                          Positioned(
                                            top: -10,
                                            right: -5,
                                            child: IconButton(
                                              icon: const Icon(
                                                Icons.cancel_outlined,
                                                color: Colors.cyanAccent,
                                              ),
                                              onPressed: () {
                                                showCameraDeleteConfirmationDialog(
                                                    index);
                                                // removeImage(index);
                                              },
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                              ),
                            ),
                          ),
                        ],
                      ),
                      category == "Food"
                      ?
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin:
                                const EdgeInsets.only(left: 20, right: 20, top: 25),
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
                            margin: const EdgeInsets.only(left: 20, right: 20),
                            child: DropdownButton(
                              value: productType,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: items2.map((String items2) {
                                return DropdownMenuItem(
                                  value: items2,
                                  child: Text(items2),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  productType = newValue!;
                                });
                              },
                            ),
                          ),
                        ],
                      ): Container(),
                      Container(
                        child: Form(
                          key: _formkey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment
                                .start, // Align everything to the left
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                    left: 20, right: 20, top: 20),
                                child:  Row(
                                  children: [
                                    Text(
                                      'Product Name',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontFamily: 'Poppins',
                                        color: Colors.black,
                                      ),
                                    ),
                                    if(ProductId.categoryCheck)Spacer(),
                                    if(ProductId.categoryCheck)
                                        IconButton(
                                          icon: Icon(
                                            Icons.cancel_outlined,
                                            color: Colors.red,
                                          ),
                                          onPressed: () {
                                            ProductId.reset();
                                            Navigator.pop(context);
                                            // removeImage(index);
                                          },
                                        ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left:20.0,right:20),
                                child: TextFormField(
                                  controller: _searchController,
                                  enabled: (ProductId.categoryCheck) ?false:true,
                                  onChanged: _onSearchChanged,
                                  style: const TextStyle(
                                      color: Colors.black87,
                                      fontFamily: 'Poppins', fontSize: 15),
                                  decoration: InputDecoration(
                                    hintText: 'Write the productName',
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.teal.shade900),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10,),
                              Stack(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: 20, right: 20, top: 5),
                                        child: Text(
                                          'Product  Description',
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontFamily: 'Poppins',
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: 20, right: 20, bottom: 10),
                                        child: TextFormField(
                                          controller:
                                          productDescriptionController,

                                          enabled: (ProductId.categoryCheck) ?false:true,
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontFamily: 'Poppins', fontSize: 15),
                                          decoration: InputDecoration(
                                            hintText: (ProductId.categoryCheck==false)?'Write Product Description(Optional)':"",
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.teal.shade900),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: 20, right: 20, top: 5),
                                        child: const Text(
                                          'Select Quantity/price',
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontFamily: 'Poppins',
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      PriceQuantitySpinnerRow(
                                        options: itemOptions,
                                        onOptionAdded: handleOptionAdded,
                                        updateInitialValue:
                                            (pControllers, oController, qController) {},
                                      ),
                                    ],
                                  ),
                                  if (_suggestions.isNotEmpty)
                                    Card(
                                      color: Colors.white,
                                      elevation: 4.0,
                                      child: Container(
                                        height: (_suggestions.length * 45.0)%250,
                                        child: ListView.builder(
                                          itemCount: _suggestions.length,
                                          itemExtent: 40.0,
                                          itemBuilder: (context, index) {
                                            final suggestion = _suggestions[index];
                                            return ListTile(
                                              title: Text(suggestion.productName),
                                              onTap: () {
                                                _onSuggestionSelected(suggestion);
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left:8.0,right:8.0),
                                child: Container(
                                  width: double.infinity,
                                  height: 45,
                                  // color: Colors.blue,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (_formkey.currentState!.validate()) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ReviewListed(
                                                Gpid: '',
                                                itemOptions: itemOptions,
                                                productName:
                                                    productNameContt.text,
                                                imageFileList: imageFileList,
                                                productType: productType,
                                                description:
                                                    productDescriptionController
                                                        .text,
                                                category: category,
                                                subCategory1: subCategory1,
                                                subCategory2: subCategory2,
                                              ),
                                            ));
                                      }
                                    },
                                    child: const Text(
                                      'Submit',
                                    ),
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.blue),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 75,
                              )
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
                            category = item.toString();
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
              future: getSubCategory(TokenId.token, category),
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
                            subCategory1 = item;
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
              future: getSubCategory2(TokenId.token, category, subCategory1),
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
                    subCategory2 = '';
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
                            subCategory2 = subCategory;
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
  Future<void> showCameraDeleteConfirmationDialog(int index) async {
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
                removeCameraImage(index); // Remove the image from the list
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
  void removeCameraImage(int index) {
    setState(() {
      imageFileList.removeAt(index);
    });
  }
  Widget PageDialog() {
    return AlertDialog(
      content: PageView(controller: pageController, children: [
        categoryDialog(),
        Text("Page 2"),
        Text("Page 3"),
      ]),
    );
  }
  void handleOptionAdded(ItemOption newItem) {
    setState(() {
      itemOptions.add(newItem);
    });
  }
  void selectImages() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      imageFileList.addAll(selectedImages);
    }
    print("Image List Length:" + imageFileList.length.toString());
    setState(() {});
  }
  void valueUpdate(String pname, String desc) {
    productNameContt.text = pname;
    _searchController.text = pname;
    productDescriptionContt.text = desc;
    productDescriptionController.text = desc;
    if(ProductId.categoryCheck) {
      productNameContt.removeListener(() {});
      productDescriptionContt.removeListener(() {});
      productDescriptionController.removeListener(() {});
    }
    setState(() {
      itemOptions = widget.itemOptions;
    });
  }
  void showCameraImageExpansion(int index) {
    Navigator.of(context).push(
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
                    File(imageFileList[index].path),
                    fit: BoxFit.cover,
                  )),
            ),
          );
        },
      ),
    );
  }

  void _onSearchChanged(String query) async {
    print("sadfdf");
    productNameContt.text=_searchController.text;
    List<Product2> suggestions = await fetchSuggestions(query);
    setState(() {
      _suggestions = suggestions;
    });
  }

  Future<List<String>> fetchSuggestionsFromDatabase(String query) async {
    await Future.delayed(Duration(seconds: 1)); // Simulate async delay.
    return List.generate(15, (index) => '$query suggestion ${index + 1}');
  }

  void _onSuggestionSelected( Product2 selectedSuggestion) {
    _searchController.text = selectedSuggestion.productName;
    ProductId.cat=selectedSuggestion.category;
    ProductId.subCat1=selectedSuggestion.subCategory1;
    ProductId.subCat2=selectedSuggestion.subCategory2;
    ProductId.categoryCheck=true;
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddProduct(
            productName: selectedSuggestion.productName,
            productDescription: selectedSuggestion.description, productDetails: [], itemOptions: [],
          ),
        ));
  }
  void _onScreenTap() {
    setState(() {
      _suggestions = [];
    });
  }

  Future<List<Product2>> fetchSuggestions(String query) async {
    print("querydiwakar singh chauhan ");
    print(query);
    if(query.isEmpty)return[];
    List<Product2> prods = await UserApi.fetchGlobalProduct(query);
    print(prods.length);
    return prods;
  }

}


class ItemOption {
  String price;
  String quantity;
  String unit;
  String offerPrice;

  ItemOption({
    required this.price,
    required this.quantity,
    required this.unit,
    required this.offerPrice,
  });

  Map<String, dynamic> toJson() {
    return {
      'price': price,
      'quantity': quantity,
      'unit': unit,
      'offerPrice': offerPrice,
    };
  }
}



class PriceQuantitySpinnerRow extends StatefulWidget {
  final List<ItemOption> options;
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
    unit: 'kg',
    offerPrice: "",
  );
  List<String> dropDownItems = [
    "kg",
    "litre",
    "piece",
    "packet",
    "box",
    "bottle",
    "can",
    "bag",
    "sack",
    "tin",
    "other",
  ];

  bool _validate4 = false;
  bool _validate5 = false;
  bool _validate6 = false;

  @override
  void initstate() {
    super.initState();
    widget.onOptionAdded(newItem);
  }

  void addOption() {
    widget.onOptionAdded(newItem);
    newItem = ItemOption(
      price: "",
      quantity: "",
      unit: 'kg',
      offerPrice: "",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: widget.options.map((option) {
            return Container(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller:
                            TextEditingController(text: option.quantity.toString()),
                            onChanged: (value) => option.quantity = value,
                            decoration: InputDecoration(
                              hintText: 'Quantity',
                              label: const Text('Quantity'),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              errorText:
                              _validate4 ? 'Value Can\'t Be Empty' : null,
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
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller:
                            TextEditingController(text: option.price.toString()),
                            onChanged: (value) => option.price = value,
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
                            keyboardType: TextInputType.number,
                            controller:
                            TextEditingController(text: option.offerPrice.toString()),
                            onChanged: (value) => option.offerPrice = value,
                            decoration: InputDecoration(
                              hintText: 'Offer Price',
                              label: const Text('Offer Price'),
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
              ),
            );
          }).toList(),
        ),
        Container(
            margin: EdgeInsets.only(left: 20),
            child: ElevatedButton(
              onPressed: addOption,
              child: Text("Add items"),
            )),
      ],
    );
  }
}
