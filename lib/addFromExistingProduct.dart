
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'DataSaveClasses/ProductId.dart';
import 'add_product.dart';
import 'apis/ProductSearchModel.dart';
import 'customWidgets/searchProduct.dart';
import 'package:e_commerce/services/User_api.dart';

import 'globalProductDescription.dart';

class ProductSelectionPage extends StatefulWidget {
  const ProductSelectionPage({super.key});

  @override
  _ProductSelectionPageState createState() => _ProductSelectionPageState();
}

class _ProductSelectionPageState extends State<ProductSelectionPage> {
  TextEditingController _searchController = TextEditingController();
  Future <List<Product2>>? _filteredProducts ;

  @override
  void initState() {
    super.initState();
    _updateFilteredProducts("");
  }

  void _updateFilteredProducts(String query) async {
    _filteredProducts =   UserApi.fetchGlobalProduct(query);
    setState(() {
    });
  }

// This variable is used to store BarCode Number by Scanning
  var _scanBarcodeResult;

  Future<void> scanBarcodeNormal() async {
    String barcodeSacanRes;
    try {
      barcodeSacanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      debugPrint(barcodeSacanRes);
    } on PlatformException {
      barcodeSacanRes = 'Failed to get platform version';
    }
    if (!mounted) return;
    setState(() {
      _scanBarcodeResult = barcodeSacanRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Search Product",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.lightBlue.shade100,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: TextField(
              controller: _searchController,
              onChanged: (query) {
                _updateFilteredProducts(query);
              },
              decoration: const InputDecoration(
                labelText: 'Enter Product Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Product2>>(
              future: _filteredProducts,
              builder: ( context,  snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
              return Center(child: Text('No Products Found'));
              } else {
                List<Product2>? prods = snapshot.data;
                if(prods!.isEmpty) return Center(child: Text('No Products Found'));
                return   ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: prods.length,
                  itemBuilder: (BuildContext context, int index) {
                    final prod = prods[index];
                    return Card(
                      elevation: 5,
                      margin: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 10,
                        bottom: 6,
                      ),
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
                                          Radius.circular(10),
                                        ),
                                      ),
                                      height: 150,
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    margin: EdgeInsets
                                                        .only(
                                                        right:
                                                        15),
                                                    child: (prod
                                                        .Url
                                                        .length >
                                                        0)
                                                        ? Image
                                                        .network(
                                                      prod.Url[0],
                                                      height:
                                                      150,
                                                      width:
                                                      80,
                                                      fit: BoxFit
                                                          .fill,
                                                    )
                                                        : Image
                                                        .asset(
                                                        'assets/images/a1.jpg',
                                                        height:
                                                        150,
                                                        width:
                                                        80),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        width: double.infinity,
                                                        child: Text(
                                                          '${prod.category}/${prod.subCategory1}/${prod.subCategory2}',
                                                          style: const TextStyle(
                                                            color: Colors.black87,
                                                            fontSize: 15,
                                                            fontFamily: 'comfort',
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                          maxLines: 2, // Set the maximum number of lines
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                      // SizedBox(height: 5,),
                                                      Text(
                                                        prod.productName,
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20,
                                                          fontFamily: 'comfart',
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: (){
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) => GlobalProductScreen(
                                                                      prod: prod, productId: prod.id)));
                                                        },
                                                        child: const Text(
                                                          'See Product Detail',
                                                          style: TextStyle(
                                                            decoration: TextDecoration.underline,
                                                            color: Colors.blueAccent,
                                                            fontSize: 15,
                                                            fontFamily: 'comfart',
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: 8,),
                                                      Container(
                                                        width: 220,
                                                        height: 40,
                                                        child: MaterialButton(
                                                          color: Colors.lightBlue.shade400,
                                                          onPressed: () {
                                                            ProductId.cat=prod.category;
                                                            ProductId.subCat1=prod.subCategory1;
                                                            ProductId.subCat2=prod.subCategory2;
                                                            ProductId.categoryCheck=true;
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) => AddProduct(
                                                                    productName: prod.productName,
                                                                    productDescription: prod.description, productDetails: [], itemOptions: [],
                                                                  ),
                                                                ));
                                                          },
                                                          child: const Text(
                                                            'Add This Product',
                                                            style: TextStyle(
                                                              color: Colors.white,
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
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
                    );
                  },
                );
              }
              },
            )
          ),
        ],
      ),

      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: 65.0,
            width: 270.0,
            child: FloatingActionButton(
              onPressed: () {
                scanBarcodeNormal();
              },
              backgroundColor: Colors.blue,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add,
                    size: 17,
                    color: Colors.white,
                  ),
                  SizedBox(width: 5), // Add some spacing between icon and text
                  Text(
                    'Add New Product by Barcode',
                    style: TextStyle(fontSize: 17, color: Colors.white),
                  ),
                ],
              ), // Customize the color as needed
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 65.0,
            width: 250.0,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddProduct(
                        productName: '',
                        productDescription: '',
                        productDetails: const [],
                        itemOptions: const [],
                      ),
                    ));
              },
              backgroundColor: Colors.blue,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add,
                    size: 17,
                    color: Colors.white,
                  ),
                  SizedBox(width: 5), // Add some spacing between icon and text
                  Text(
                    'Add New Product',
                    style: TextStyle(fontSize: 17, color: Colors.white),
                  ),
                ],
              ), // Customize the color as needed
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}


