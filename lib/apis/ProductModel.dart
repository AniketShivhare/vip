class QuantityPricing {
  double offerPrice;
  double quantity;
  double mrpPrice;
  String unit;
  bool inStock;
  double maxOrderQuantity;

  QuantityPricing({
    required this.offerPrice,
    required this.quantity,
    required this.mrpPrice,
    required this.unit,
    required this.inStock,
    required this.maxOrderQuantity
  });

  factory QuantityPricing.fromJson(Map<String, dynamic> json) {
    return QuantityPricing(
      offerPrice:
          (json['offerPrice'] != null) ? json['offerPrice'].toDouble() : 0.0,
      quantity: (json['quantity'] != null) ? json['quantity'].toDouble() : 0.0,
      unit: json['unit'] ?? 'kg',
      mrpPrice: (json['mrpPrice'] != null) ? json['mrpPrice'].toDouble() : 0.0,
      inStock: true,
      maxOrderQuantity: (json['maxOrderQuantity'] != null) ? json['maxOrderQuantity'].toDouble() : 0.0,

    );
  }
  Map<String, dynamic> toJson() {
    return {
      'offerPrice': offerPrice,
      'quantity': quantity,
      'mrpPrice': mrpPrice,
      'unit': unit,
      'inStock': inStock,
      'maxOrderQuantity':maxOrderQuantity
    };
  }
}

class Product {
  String id;
  String sellerID;
  String productName;
  GlobalProductID globalProductID;
  bool inStock;
  List<QuantityPricing> productDetails;
  // DateTime createdAt;
  // DateTime updatedAt;
  double minMrpPrice;

  Product({
    required this.id,
    required this.sellerID,
    required this.productName,
    required this.globalProductID,
    required this.inStock,
    required this.productDetails,
    // required this.createdAt,
    // required this.updatedAt,
    required this.minMrpPrice,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] ?? '',
      sellerID: json['sellerID'] ?? '',
      productName: json['productName'] ?? 'd',
      globalProductID: (json['globalProductInfo'] != null &&
              json['globalProductInfo'].length > 0)
          ? GlobalProductID.fromJson(json['globalProductInfo'][0])
          : GlobalProductID(
              id: "657939947955a237931d8622",
              productName: "",
              category: "",
              subCategory1: "",
              subCategory2: "",
              images: [],
              description: "",
            ),
      inStock: json['inStock'] ?? false,
      productDetails: (json['productDetails'] == null)
          ? []
          : List<QuantityPricing>.from(
              json['productDetails'].map((x) => QuantityPricing.fromJson(x))),
      // createdAt: DateTime.parse(json['createdAt']),
      // updatedAt: DateTime.parse(json['updatedAt']),
      minMrpPrice: (json['minMrpPrice'] != null)
          ? ((json['minMrpPrice'] is int)
              ? (json['minMrpPrice'] as int).toDouble()
              : json['minMrpPrice'].toDouble())
          : 0,
    );
  }
}

class GlobalProductID {
  String id;
  String productName;
  String category;
  String subCategory1;
  String subCategory2;
  List<String> images;
  String description;
  // DateTime createdAt;
  // DateTime updatedAt;

  GlobalProductID({
    required this.id,
    required this.productName,
    required this.category,
    required this.subCategory1,
    required this.subCategory2,
    required this.images,
    required this.description,
    // required this.createdAt,
    // required this.updatedAt,
  });

  factory GlobalProductID.fromJson(Map<String, dynamic> json) {
    return GlobalProductID(
      id: json['_id'] ?? '',
      productName: json['productName'] ?? '',
      category: json['category'] ?? '',
      subCategory1: json['subCategory1'] ?? '',
      subCategory2: json['subCategory2'] ?? '',
      images: (json['images'] != null) ? List<String>.from(json['images']) : [],
      description: json['description'] ?? '',
      // createdAt: DateTime.parse(json['createdAt']),
      // updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
