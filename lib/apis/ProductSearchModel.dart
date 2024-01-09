class Product2 {
  String id;
  String productName;
  String category;
  String subCategory1;
  String subCategory2;
  List<String> Url;
  String description;
  String returnPeriod;
  String replacementPeriod;
  String barCodeNumber;

  Product2({
    required this.id,
    required this.productName,
    required this.category,
    required this.Url,
    required this.subCategory1,
    required this.subCategory2,
    required this.description,
    required this.returnPeriod,
    required this.replacementPeriod,
    required this.barCodeNumber
  });

  factory Product2.fromJson(Map<String, dynamic> json) {
    return Product2(
      id: json['_id'] ?? "",
      productName: json['productName'] ?? "",
      Url: (json['images'] != null) ? List<String>.from(json['images']) : [],
      category: json['category'] ?? "",
      description: json['description'] ?? "",
      returnPeriod: json['returnPeriod'] ?? "",
      replacementPeriod: json['replacementPeriod'] ?? "",
      subCategory1: json['subCategory1'] ?? "",
      subCategory2: json['subCategory2'] ?? "",
      barCodeNumber: json['barCodeNumber'] ?? "",
    );
  }
}
