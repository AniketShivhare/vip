import 'package:flutter/material.dart';

class RatingReview {
  final String reviewHeading;
  final String reviewContent;
  final String createdAt;

  RatingReview({
    required this.reviewHeading,
    required this.reviewContent,
    required this.createdAt,
  });

  factory RatingReview.fromJson(Map<String, dynamic> json) {
    return RatingReview(
      reviewHeading: json['reviewHeading'],
      reviewContent: json['reviewContent'],
      createdAt: json['createdAt'],
    );
  }
}

class ReviewListWidget extends StatelessWidget {
  final List<RatingReview> reviews;

  ReviewListWidget({required this.reviews});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final review = reviews[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: double.infinity,
            height: 180,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                left: BorderSide(
                  color: Colors.black.withOpacity(0.15),
                ),
                top: BorderSide(
                  color: Colors.black.withOpacity(0.15),
                ),
                right: BorderSide(
                  color: Colors.black.withOpacity(0.15),
                ),
                bottom: BorderSide(
                  width: 1,
                  color: Colors.black.withOpacity(0.15),
                ),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 16,
                        ),
                        SizedBox(width: 12,),
                        Text(
                          'John Doe',
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.800000011920929),
                            fontSize: 20,
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.w700,
                            height: 0.07,
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.more_vert),
                  ],
                ),
                SizedBox(height: 16,),
                Container(
                  child: Text(
                    'Lorem ipsum dolor sit amet consectetur.',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.8999999761581421),
                      fontSize: 16,
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.w400,

                    ),
                  ) ,
                ),
                SizedBox(height: 12,),
                Padding(
                  padding: const EdgeInsets.only(bottom: 0.0),
                  child: Container(
                    width: 40,
                    height: 27,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: ShapeDecoration(
                      color: Color(0xFF5E8726),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 0.0),
                          child: Container(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '5',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'Urbanist',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 2),
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: ShapeDecoration(
                                    color: Colors.white,
                                    shape: StarBorder(
                                      points: 5,
                                      innerRadiusRatio: 0.38,
                                      pointRounding: 0.50,
                                      valleyRounding: 0,
                                      rotation: 0,
                                      squash: 0,
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
                SizedBox(height: 5,),
                Text(
                  'Just now',
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.4000000059604645),
                    fontSize: 16,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}