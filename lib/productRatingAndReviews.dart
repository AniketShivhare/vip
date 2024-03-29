import 'package:e_commerce/services/User_api.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:readmore/readmore.dart';

import 'apis/ProductRatingAndReviews.dart';
import 'apis/RatingReviewProduct.dart';

class productRatingAndReview extends StatefulWidget {
  const productRatingAndReview({super.key});

  @override
  State<productRatingAndReview> createState() => _productRatingAndReviewState();
}

class _productRatingAndReviewState extends State<productRatingAndReview> {
  get buildContext => null;

  List<ProductInfo> data = [];

  @override
  void initState() {
    super.initState();
    CallFetchFunction();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text("Products Review's and Rating's"),
        backgroundColor: Colors.blue.shade200,
      ),
      body: (data.isNotEmpty) ? ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => customerRatingReviews(Pid:data[index].id)));
              },
              child: Card(
                color: Colors.white,
                margin: EdgeInsets.all(8),
                child: Row(
                  children: [
                    SizedBox(
                      width: 5,
                    ),
                  (data[index].globalProductInfo[0].images.length>0) ?
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(data[index].globalProductInfo[0].images[0]),
                    ) :
                    CircleAvatar(
                    radius: 50,
                      backgroundImage: AssetImage('assets/images/a1.jpg'),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data[index].productName,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('${buildStarString(data[index].avgRating)}'),
                        Text('Reviews: ${data[index].ratingCount}')
                      ],
                    )
                  ],
                ),
              ),
            );
          }) : Center(child: CircularProgressIndicator(),),
    );

  }

  void CallFetchFunction() {
    FetchRatingReviews();

  }
  Future<void> FetchRatingReviews() async{
    data = await UserApi.GetAllReviewAndRating();
    print(data);
    setState(() {
    });
  }

}

String buildStarString(double rating) {
  int numStars = rating.round();
  return 'Average Ratings: ${'⭐ ' * numStars}';
}

class customerRatingReviews extends StatefulWidget {
  final String Pid;
  const customerRatingReviews({super.key, required this.Pid});

  @override
  State<customerRatingReviews> createState() => _customerRatingReviewsState();
}

class _customerRatingReviewsState extends State<customerRatingReviews> {
  List<String> imgList =  [
    'https://live.staticflickr.com/65535/52776398922_7ccd356090_n.jpg',
    'https://live.staticflickr.com/2076/2035674949_387828bf5d_n.jpg',
    'https://live.staticflickr.com/7007/6445597257_01bc03ae16_n.jpg',
    'https://live.staticflickr.com/1111/883349109_9ab52e9e44_n.jpg',
    'https://live.staticflickr.com/2666/3936914188_a7549649ea_n.jpg'
  ];

  List<RatingReview> data = [];
  void showImageExpansion(int index) {
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

  String reviewContent =
      "Absolutely delightful experience with the Shahi Thali! Each dish is a burst of authentic flavors and aromatic spices. The diverse selection, coupled with impeccable presentation, makes it a truly royal culinary journey.";

  @override
  void initState() {
    super.initState();
    CallFetchFunction(widget.Pid);
  }

  @override
  Widget build(BuildContext context) {
    double ewidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(title: Text('Rating and reviews')),
      body: (data.isNotEmpty)? ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            RatingReview data1 = data[index];
            int? rating = data1.rating?.toInt();
            String starString = '⭐' * rating!;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.all(15),
                    width: ewidth * 0.94,
                    child: Card(
                      // margin: EdgeInsets.all(8),
                      color: Colors.white,
                      child: Container(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  data1.buyerInfo![0].name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                Text(
                                  formattedCreatedAt(data1.createdAt),
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(starString),
                                // Icon(
                                //   Icons.star_half_outlined,
                                //   color: Colors.amber.shade400,
                                // ),
                                Text(
                                  formattedCreated(data1.createdAt),
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: ReadMoreText(
                                '${data1.reviewContent} ',
                                trimLines: 3,
                                textAlign: TextAlign.justify,
                                trimMode: TrimMode.Line,
                                trimCollapsedText: 'Read More',
                                trimExpandedText: 'Read Less',
                                lessStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue),
                                moreStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue),
                              ),
                            ),
                            Container(
                              height: 120,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GridView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: imgList.length,
                                    gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 1,
                                        mainAxisSpacing: 5),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Stack(
                                        children: [
                                          Container(
                                            height: 100,
                                            width: 100,
                                            child: Hero(
                                              tag: 'image_$index',
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) {
                                                        return ImageDetailScreen(
                                                            imgList,
                                                            imgList[index]);
                                                      },
                                                    ),
                                                  );
                                                },
                                                child: Image.network(
                                                  imgList[index],
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                          // Positioned(
                                          //   top: -10,
                                          //   right: -5,
                                          //   child: IconButton(
                                          //     icon: Icon(
                                          //       Icons.cancel_outlined,
                                          //       color: Colors.cyanAccent,
                                          //     ),
                                          //     onPressed: () {
                                          //       showDeleteConfirmationDialog(
                                          //           index);
                                          //       // removeImage(index);
                                          //     },
                                          //   ),
                                          // ),
                                        ],
                                      );
                                    }),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(data1.buyerInfo![0].profileImage[0]),
                    ),
                  )
                ],
              ),
            );
          }) : Center(child: CircularProgressIndicator(),)
    );
  }
  Future<void> CallFetchFunction(String Pid) async{
    data = await UserApi.GetCustomerReviewAndRating(Pid);
    print(data);
    setState(() {

    });
  }

}

String formattedCreatedAt(createdAt) {
  return createdAt != null
      ? '${createdAt!.hour}:${createdAt!.minute} ${_getPeriod(createdAt!)}'
      : '';
}

String _getPeriod(DateTime dateTime) {
  return dateTime.hour < 12 ? 'AM' : 'PM';
}

String formattedCreated(createdAt) {
  return createdAt != null
      ? '${_getMonthAbbreviation(createdAt!)} ${createdAt!.day}, ${createdAt!.year}'
      : '';
}

String _getMonthAbbreviation(DateTime dateTime) {
  const List<String> months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  return months[dateTime.month - 1];
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
                          color: index == currentIndex
                              ? Colors.blue
                              : Colors.transparent,
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
