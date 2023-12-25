import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_commerce/googleFonts.dart';
import 'package:e_commerce/services/tokenId.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import '../../widgets/PopAppBarWithTitle.dart';
import 'add_product.dart';
import 'apis/ProductModel.dart';
import 'apis/ProductSearchModel.dart';
import 'customWidgets/reviewWidget.dart';
import 'package:http/http.dart' as http;
import 'googleFonts.dart';
import 'main_dashboard.dart';


List<RatingReview> parseReviews(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<RatingReview>((json) => RatingReview.fromJson(json)).toList();

}


class GlobalProductScreen extends StatefulWidget {
  final Product2 prod;
  final String productId;

  GlobalProductScreen({ required this.productId, required this.prod});

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<GlobalProductScreen> {


  int currentIndex = 0;
  late Product2 prod;

  late  List<String> imgList = [
    'https://media.istockphoto.com/id/1644722689/photo/autumn-decoration-with-leafs-on-rustic-background.jpg?s=2048x2048&w=is&k=20&c=dZFmEik-AnmQJum5Ve8GbQj-cjkPsFTJP26lPY5RTJg=',
    'https://media.istockphoto.com/id/1464561797/photo/artificial-intelligence-processor-unit-powerful-quantum-ai-component-on-pcb-motherboard-with.jpg?s=2048x2048&w=is&k=20&c=_h_lwe5-Xb4AK-w3nUfa0m3ZNPDZSqhQhkitrtdTpFQ=',
    'https://media.istockphoto.com/id/1486626509/photo/woman-use-ai-to-help-work-or-use-ai-everyday-life-at-home-ai-learning-and-artificial.jpg?s=2048x2048&w=is&k=20&c=I9i1MwJ29M2yQBC8BBLOfWyHJ3hlBpYoSmqSXAKFlZM=',
     ];

  @override
  void initState() {
    super.initState();
    prod = widget.prod;
    imgList = prod.Url;
    print("imgList");
    print(widget.prod.Url);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: true,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: PopAppBarWithTitle(title: 'Product Details'),
        ),
        body:  SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              (prod.Url.isNotEmpty)?
              Center(
                child: CarouselSlider(
                  items: imgList.map((url) {
                    return Builder(
                      builder: (BuildContext context) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) {
                                  return ImageDetailScreen(imgList, url);
                                },
                              ),
                            );
                          },
                          child: Hero(
                            tag: url, // Unique hero tag for each image
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(horizontal: 5.0),
                              decoration: BoxDecoration(
                                color: Colors.grey,
                              ),
                              child: Image.network(
                                url,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                  options: CarouselOptions(

                    autoPlay: false,
                    enlargeCenterPage: true,
                    height: 300,
                    enableInfiniteScroll: true,
                    viewportFraction: 0.8,
                    onPageChanged: (index, reason) {
                      // Handle indicator changes if needed
                      setState(() {
                        currentIndex = index;
                      });
                    },


                  ),
                ),
              ):Container(),
              SizedBox(height: 10,),
              (prod.Url.isNotEmpty)?CustomDotsIndicator(
                itemCount: imgList.length,
                currentIndex: currentIndex,
                dotSize: 8.0,
                dotSpacing: 8.0,
                dotColor: Colors.grey,
                activeDotColor: Colors.orangeAccent,
              ):Container(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Product Name: ',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${prod.productName}',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),


                    SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Product Category: ',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: Text(
                              '${prod.category}/${prod.subCategory1}/${prod.subCategory2}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontFamily: 'comfort',
                                fontWeight: FontWeight.w400,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      )

                    ),
                  ],
                ),
              ),
              (prod.description.isNotEmpty)?
              Divider(
                thickness: 1,
                color: Colors.grey[300],
              ):Container(),
              (prod.description.isNotEmpty)?
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Product Description: ',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Text(
                        '${prod.description}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontFamily: 'comfort',
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                )

              ):Container(),
              Divider(
                thickness: 1,
                color: Colors.grey[300],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Image.asset("assets/images/product-return.png",
                        height:35,
                      ),
                      SizedBox(height: 5,),
                      Text("0 days"),
                      Text("Return")
                    ],
                  ),

                  Column(
                    children: [
                      Image.asset("assets/images/product-replacement-icon.png",height: 35,),
                      SizedBox(height: 5,),
                      Text("0 days"),
                      Text("Replacement")
                    ],
                  )
                ],
              ),

              Divider(
                thickness: 1,
                color: Colors.grey[300],
              ),
              SizedBox(height: 100,),
            ],
          ),
        ),
        floatingActionButton: Container(
          height: 65.0,
          width: 250.0,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddProduct(
                      productName: '',
                      productDescription: '', productDetails:  [], itemOptions: [],
                    ),
                  ));
            },
            child: Container(
              // constraints: BoxConstraints(minWidth: 100), // Adjust the minimum width as needed
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add,size: 17,color: Colors.white,),
                  SizedBox(width: 5), // Add some spacing between icon and text
                  Text('Add New Product',style: TextStyle(fontSize: 17,color: Colors.white),),
                ],
              ),
            ),
            backgroundColor: Colors.blue, // Customize the color as needed
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}


class CustomDotsIndicator extends StatelessWidget {
  final int itemCount;
  final int currentIndex;
  final double dotSize;
  final double dotSpacing;
  final Color dotColor;
  final Color activeDotColor;

  CustomDotsIndicator({
    required this.itemCount,
    required this.currentIndex,
    this.dotSize = 8.0,
    this.dotSpacing = 8.0,
    this.dotColor = Colors.grey,
    this.activeDotColor = Colors.orangeAccent,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        return Container(
          width: dotSize,
          height: dotSize,
          margin: EdgeInsets.symmetric(horizontal: dotSpacing / 2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == currentIndex ? activeDotColor : dotColor,
          ),
        );
      }),
    );
  }
}


class ImageDetailScreen extends StatefulWidget {
  final List<String> imageUrls;
  final String selectedImageUrl;

  ImageDetailScreen(this.imageUrls, this.selectedImageUrl);

  @override
  _ImageDetailScreenState createState() => _ImageDetailScreenState();
}
class _ImageDetailScreenState extends State<ImageDetailScreen> {
  late PageController _pageController;
  int currentIndex = 0;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.imageUrls.indexOf(widget.selectedImageUrl);
    _pageController = PageController(initialPage: currentIndex);
    _scrollController = ScrollController();
    _pageController.addListener(_pageControllerListener);
  }

  void _pageControllerListener() {
    // Calculate the scroll offset based on the PageView's position
    double offset = _pageController.page! * 85.0;

    // Ensure the calculated offset is within the bounds of the scrollable area
    offset = offset.clamp(0, (_scrollController.position.maxScrollExtent));

    // Scroll the GridView without animation
    _scrollController.jumpTo(offset);
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Detail'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: PhotoViewGallery.builder(
              backgroundDecoration: BoxDecoration(color: Colors.white),
              itemCount: widget.imageUrls.length,
              pageController: _pageController,
              onPageChanged: onPageChanged,
              builder: (context, index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: NetworkImage(widget.imageUrls[index]),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 2,
                );
              },

            ),
          ),
          Container(
            height: 85,
            child: Center(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                controller: _scrollController,
                itemCount: widget.imageUrls.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      _pageController.animateToPage(
                        index,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Container(
                      width: 80,
                      height: 80,
                      margin: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: index == currentIndex ? Colors.blue : Colors.transparent,
                          width: 2.0,
                        ),
                      ),
                      child: Image.network(
                        widget.imageUrls[index],
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}