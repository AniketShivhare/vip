class Order {
  String id;
  Customer customer;
  String sellerID;
  List<Product1> productList;
  String productShowOnOrder = 'No products';
  String orderStatus;
  DateTime createdAt;
  DateTime updatedAt;
  ShippedBy shippedBy;
  Payment payment;

  void getProductListString() {
    if (productList.length <= 3) {
      // If there are 3 or fewer products, display all of them
      productShowOnOrder = productList
          .map((product) => '${product.quantity} ${product.unit} ${product.productName}')
          .join(', ');
    } else {
      // If there are more than 3 products, display the first 3 with an ellipsis
      final firstThreeProducts = productList.sublist(0, 3);
      final firstThreeProductsString =
      firstThreeProducts.map((product) => '${product.quantity} ${product.unit} ${product.productName}').join(', ');

      productShowOnOrder = '$firstThreeProductsString ...';
    }
  }
  Order({
    required this.id,
    required this.customer,
    required this.sellerID,
    required this.productList,
    required this.orderStatus,
    required this.createdAt,
    required this.updatedAt,
    required this.shippedBy,
    required this.payment,
    required this.productShowOnOrder,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      productShowOnOrder:'',
      id: json['_id'] ?? '',
      customer: Customer.fromJson(json['customerID'] ?? {}),
      sellerID: json['sellerID'] ?? '',
      productList: (json['productList'] as List? ?? [])
          .map((productJson) => Product1.fromJson(productJson ?? {}))
          .toList(),
      orderStatus: json['orderStatus'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? ''),
      updatedAt: DateTime.parse(json['updatedAt'] ?? ''),
      shippedBy: ShippedBy.fromJson(json['shippedBy'] ?? {}),
      payment: Payment.fromJson(json['payment'] ?? {}),
    );
  }
}

class Customer {
  String id;
  String name;
  String phone;
  List<dynamic> address;

  Customer({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? [],
    );
  }
}

class Product1 {
  String id;
  String productName;
  int quantity;
  int mrpPrice;
  int offerPrice;
  String unit;

  Product1({
    required this.id,
    required this.productName,
    required this.quantity,
    required this.mrpPrice,
    required this.offerPrice,
    required this.unit,
  });

  factory Product1.fromJson(Map<String, dynamic> json) {
    return Product1(
      id: json['_id'] ?? '',
      productName: json['productName'] ?? '',
      quantity: json['quantity'] ?? 0,
      mrpPrice: json['mrpPrice'] ?? 0,
      offerPrice: json['offerPrice'] ?? 0,
      unit: json['unit'] ?? '',
    );
  }
}

class ShippedBy {
  String name;
  int phoneNumber;

  ShippedBy({
    required this.name,
    required this.phoneNumber,
  });

  factory ShippedBy.fromJson(Map<String, dynamic> json) {
    return ShippedBy(
      name: json['name'] ?? '',
      phoneNumber: json['phoneNumber'] ?? 0,
    );
  }
}

class Payment {
  String paymentMode;
  String paymentStatus;
  String paymentDate;
  int paymentAmount;

  Payment({
    required this.paymentMode,
    required this.paymentStatus,
    required this.paymentDate,
    required this.paymentAmount,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      paymentMode: json['paymentMode'] ?? '',
      paymentStatus: json['paymentStatus'] ?? '',
      paymentDate: json['paymentDate'] ?? '',
      paymentAmount: json['paymentAmount'] ?? 0,
    );
  }
}
