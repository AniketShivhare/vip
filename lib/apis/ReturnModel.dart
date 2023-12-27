class Return {
  final String? id;
  final String? customerID;
  final String? sellerID;
  final String? orderID;
  final String? notes;
  final ProductInstance? productInstance;
  final String? status;
  final bool? isComplete;
  final ShippedBy? shippedBy;
  final String? reasons;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Return({
    this.id,
    this.customerID,
    this.sellerID,
    this.orderID,
    this.notes,
    this.productInstance,
    this.status,
    this.isComplete,
    this.shippedBy,
    this.reasons,
    this.createdAt,
    this.updatedAt,
  });

  factory Return.fromJson(Map<String, dynamic> json) {
    return Return(
      id: json['_id'],
      customerID: json['customerID'],
      sellerID: json['sellerID'],
      orderID: json['orderID'],
      notes: json['notes'],
      productInstance: json['productInstance'] != null
          ? ProductInstance.fromJson(json['productInstance'])
          : null,
      status: json['Status'],
      isComplete: json['isComplete'],
      shippedBy: json['shippedBy'] != null
          ? ShippedBy.fromJson(json['shippedBy'])
          : null,
      reasons: json['reasons'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }
}

class ProductInstance {
  final String? productID;
  final String? productName;
  final int? quantity;
  final double? mrpPrice;
  final double? offerPrice;
  final String? unit;

  ProductInstance({
    this.productID,
    this.productName,
    this.quantity,
    this.mrpPrice,
    this.offerPrice,
    this.unit,
  });

  factory ProductInstance.fromJson(Map<String, dynamic> json) {
    return ProductInstance(
      productID: json['productID'],
      productName: json['productName'],
      quantity: json['quantity'],
      mrpPrice: double.parse(json['mrpPrice'].toString()),
      offerPrice: double.parse(json['offerPrice'].toString()),
      unit: json['unit'],
    );
  }
}

class ShippedBy {
  final String? name;
  final int? phoneNumber;

  ShippedBy({this.name, this.phoneNumber});

  factory ShippedBy.fromJson(Map<String, dynamic> json) {
    return ShippedBy(
      name: json['name'],
      phoneNumber: json['phoneNumber'],
    );
  }
}
