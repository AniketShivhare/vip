class ProductInfo {
  final String id;
  final String sellerID;
  final String globalProductID;
  final List<String> ratingIDs;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;
  final double avgRating;
  final String replacementStatus;
  final String returnStatus;
  final String productName;
  final List<GlobalProductInfo> globalProductInfo;
  final int ratingCount;

  ProductInfo({
    required this.id,
    required this.sellerID,
    required this.globalProductID,
    required this.ratingIDs,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.avgRating,
    required this.replacementStatus,
    required this.returnStatus,
    required this.productName,
    required this.globalProductInfo,
    required this.ratingCount,
  });

  factory ProductInfo.fromJson(Map<String, dynamic> json) {
    return ProductInfo(
      id: json['_id'] ?? '',
      sellerID: json['sellerID'] ?? '',
      globalProductID: json['globalProductID'] ?? '',
      ratingIDs: List<String>.from(json['ratingIDs'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'] ?? 0,
      avgRating: (json['avgRating'] as num?)?.toDouble() ?? 0.0,
      replacementStatus: json['replacementStatus'] ?? '',
      returnStatus: json['returnStatus'] ?? '',
      productName: json['productName'] ?? '',
      globalProductInfo: List<GlobalProductInfo>.from(
        (json['globalProductInfo'] as List<dynamic>?)
            ?.map((info) => GlobalProductInfo.fromJson(info)) ??
            [],
      ),
      ratingCount: json['ratingCount'] ?? 0,
    );
  }
}

class GlobalProductInfo {
  final String id;
  final String productName;
  final String category;
  final String subCategory1;
  final String subCategory2;
  final List<String> images;
  final bool hasImage;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;
  final double avgRating;

  GlobalProductInfo({
    required this.id,
    required this.productName,
    required this.category,
    required this.subCategory1,
    required this.subCategory2,
    required this.images,
    required this.hasImage,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.avgRating,
  });

  factory GlobalProductInfo.fromJson(Map<String, dynamic> json) {
    return GlobalProductInfo(
      id: json['_id'] ?? '',
      productName: json['productName'] ?? '',
      category: json['category'] ?? '',
      subCategory1: json['subCategory1'] ?? '',
      subCategory2: json['subCategory2'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      hasImage: json['hasImage'] ?? false,
      description: json['description'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'] ?? 0,
      avgRating: (json['avgRating'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
