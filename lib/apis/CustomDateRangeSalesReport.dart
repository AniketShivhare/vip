class TotalOrder {
  List<OrderInfo> totalOrders;

  TotalOrder({required this.totalOrders});

  factory TotalOrder.fromJson(Map<String, dynamic> json) {
    var totalOrdersList = json['totalOrders'] as List;
    List<OrderInfo> orders = totalOrdersList.map((order) => OrderInfo.fromJson(order)).toList();

    return TotalOrder(totalOrders: orders);
  }
}

class OrderInfo {
  int totalOrders;
  double totalAmount;
  double avgOrderValue;
  int deliveredOrders;
  String sellerID;

  OrderInfo({
    required this.totalOrders,
    required this.totalAmount,
    required this.avgOrderValue,
    required this.deliveredOrders,
    required this.sellerID,
  });

  factory OrderInfo.fromJson(Map<String, dynamic> json) {
    return OrderInfo(
      totalOrders: json['totalOrders'],
      totalAmount: (json['totalAmount'] as num).toDouble(),
      avgOrderValue: (json['avgOrderValue'] as num).toDouble(),
      deliveredOrders: json['deliveredOrders'],
      sellerID: json['sellerID'],
    );
  }
}
