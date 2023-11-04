class Payment {
  String? paymentMode;
  String? paymentStatus;
  String? paymentDate;
  int? paymentAmount;

  Payment({
    this.paymentMode,
    this.paymentStatus,
    this.paymentDate,
    this.paymentAmount,
  });

  Map<String, dynamic> toJson() {
    return {
      'paymentMode': paymentMode,
      'paymentStatus': paymentStatus,
      'paymentDate': paymentDate,
      'paymentAmount': paymentAmount,
    };
  }

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      paymentMode: json['paymentMode'],
      paymentStatus: json['paymentStatus'],
      paymentDate: json['paymentDate'],
      paymentAmount: json['paymentAmount'],
    );
  }
}

class Order {
  String? id;
  String? customerID;
  String? sellerID;
  List<String>? productList;
  Map<String, dynamic>? shippedBy;
  String? orderStatus;
  Payment? payment;
  DateTime? createdAt;
  DateTime? updatedAt;

  Order({
    this.id,
    this.customerID,
    this.sellerID,
    this.productList,
    this.shippedBy,
    this.orderStatus,
    this.payment,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerID': customerID,
      'sellerID': sellerID,
      'productList': productList,
      'shippedBy': shippedBy,
      'orderStatus': orderStatus,
      'payment': payment?.toJson(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      customerID: json['customerID'],
      sellerID: json['sellerID'],
      productList: List<String>.from(json['productList']),
      shippedBy: json['shippedBy'],
      orderStatus: json['orderStatus'],
      payment: Payment.fromJson(json['payment']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
