class OrderSummaryDaily {
  List<OrderDetail> todaysOrder;
  List<OrderDetail> yesterdayOrders;
  double? percentChangeInAmount;
  double? percentChangeInAvgOrdervalue;
  double? percentChangeInDeliveredOrders;

  OrderSummaryDaily({
    required this.todaysOrder,
    required this.yesterdayOrders,
    this.percentChangeInAmount,
    this.percentChangeInAvgOrdervalue,
    this.percentChangeInDeliveredOrders,
  });

  factory OrderSummaryDaily.fromJson(Map<String, dynamic> json) {
    return OrderSummaryDaily(
      todaysOrder: (json['todaysOrder'] as List<dynamic>?)?.map((order) => OrderDetail.fromJson(order))
          .toList() ?? [],
      yesterdayOrders: (json['yesterdayOrders'] as List<dynamic>?)
          ?.map((order) => OrderDetail.fromJson(order))
          .toList() ?? [],
      percentChangeInAmount: json['percentChangeInAmount']?.toDouble(),
      percentChangeInAvgOrdervalue: json['percentChangeInAvgOrdervalue']?.toDouble(),
      percentChangeInDeliveredOrders: json['percentChangeInDeliveredOrders']?.toDouble(),
    );
  }
}

class OrderDetail {
  int totalOrders;
  double totalAmount;
  String sellerID;
  int deliveredOrders;
  double avgOrderValue;

  OrderDetail({
    required this.totalOrders,
    required this.totalAmount,
    required this.sellerID,
    required this.deliveredOrders,
    required this.avgOrderValue,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      totalOrders: json['totalOrders'],
      totalAmount: json['totalAmount']?.toDouble() ?? 0.0,
      sellerID: (json['sellerID'] ),
      deliveredOrders: json['deliveredOrders'] ?? 0,
      avgOrderValue: json['avgOrderValue']?.toDouble() ?? 0.0,
    );
  }
}


