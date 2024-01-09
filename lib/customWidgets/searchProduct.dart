import 'package:e_commerce/DataSaveClasses/ProductId.dart';
import 'package:e_commerce/globalProductDescription.dart';
import 'package:flutter/material.dart';
import '../add_product.dart';
import '../apis/ProductSearchModel.dart';

class SearchProduct extends StatefulWidget {
  final List<Product2> products;
  const SearchProduct({super.key, required this.products});
  @override
  State<SearchProduct> createState() => _RecentAddedProductState();
}

class _RecentAddedProductState extends State<SearchProduct> {
  @override
  Widget build(BuildContext context) {
    List<Product2> prods=widget.products;
    return (prods.length==0) ? Center(child: Text("Search products"),) :SingleChildScrollView(
      child: Column(
        children: [
          ListView.builder(
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
                                                  child: Container(
                                                    child: Text(
                                                      'See Product Detail',
                                                      style: const TextStyle(
                                                        decoration: TextDecoration.underline,
                                                        color: Colors.blueAccent,
                                                        fontSize: 15,
                                                        fontFamily: 'comfart',
                                                        fontWeight: FontWeight.bold,
                                                      ),
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
                                                                productDescription: prod.description, productDetails: [], itemOptions: [], barCodeNumber: prod.barCodeNumber,
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
          ),
          SizedBox(height: 80),
        ],
      ),
    );
  }
}
