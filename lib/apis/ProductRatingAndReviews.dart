class RatingReview {
  final String id;
  final String productID;
  final String customerID;
  final List<String>? images;
  final String? reviewHeading;
  final String? reviewContent;
  final double? rating;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<BuyerInfo>? buyerInfo;

  RatingReview({
    required this.id,
    required this.productID,
    required this.customerID,
    this.images,
    this.reviewHeading,
    this.reviewContent,
    this.rating,
    this.createdAt,
    this.updatedAt,
    this.buyerInfo,
  });

  factory RatingReview.fromJson(Map<String, dynamic> json) {
    return RatingReview(
      id: json['_id'] ?? '',
      productID: json['productID'] ?? '',
      customerID: json['customerID'] ?? '',
      images: (json['images'] as List<dynamic>?)?.cast<String>(),
      reviewHeading: json['reviewHeading'] ?? '',
      reviewContent: json['reviewContent'] ?? '',
      rating: json['rating'] is int
          ? (json['rating'] as int).toDouble()
          : json['rating']?.toDouble(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      buyerInfo: (json['buyerInfo'] as List<dynamic>?)
          ?.map((buyer) => BuyerInfo.fromJson(buyer))
          .toList(),
    );
  }
}

class BuyerInfo {
  final String name;
  final List<String> profileImage;

  BuyerInfo({required this.name, required this.profileImage});

  factory BuyerInfo.fromJson(Map<String, dynamic> json) {
    return BuyerInfo(
      name: json['name'] ?? '',
      profileImage: (json['profileImage'] == null)
          ? ['https://live.staticflickr.com/65535/52776398922_7ccd356090_n.jpg']
          : (json['profileImage'] as List<dynamic>).cast<String>(),
    );
  }
}