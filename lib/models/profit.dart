class Profit {
  Profit({
    required this.productId,
    required this.storeName,
    required this.userId,
    required this.price,
    required this.quantity,
    required this.status,
    required this.orderId,
    required this.category,
    required this.createdAt,
  });

  final String? productId;
  final String? storeName;
  final String? userId;
  final num? price;
  final num? quantity;
  final num? status;
  final String? orderId;
  final String? category;
  final DateTime? createdAt;

  Profit copyWith({
    String? productId,
    String? storeName,
    String? userId,
    num? price,
    num? quantity,
    num? status,
    String? orderId,
    String? category,
    DateTime? createdAt,
  }) {
    return Profit(
      productId: productId ?? this.productId,
      storeName: storeName ?? this.storeName,
      userId: userId ?? this.userId,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      status: status ?? this.status,
      orderId: orderId ?? this.orderId,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt
    );
  }

  factory Profit.fromJson(Map<String, dynamic> json){
    return Profit(
      productId: json["productId"],
      storeName: json["storeName"],
      userId: json["userId"],
      price: json["price"],
      quantity: json["quantity"],
      status: json["status"],
      orderId: json["orderId"],
      category: json["category"],
      createdAt: DateTime.parse(json['createdAt'])
    );
  }

  Map<String, dynamic> toJson() => {
    "productId": productId,
    "storeName": storeName,
    "userId": userId,
    "price": price,
    "quantity": quantity,
    "status": status,
    "orderId": orderId,
    "category": category,
    'createdAt': createdAt?.toIso8601String(),
  };

}
