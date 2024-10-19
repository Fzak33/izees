import 'cart_model.dart';

class Order {
  Order({
    required this.products,
    required this.totalPrice,
    required this.address,
    required this.userId,
    required this.userName,
    required this.orderedAt,
    required this.status,
    required this.id,
  });

  final List<Cart> products;
  final num? totalPrice;
  final String? address;
  final String? userId;
  final String? orderedAt;
  final num? status;
  final String? id;
  final String? userName;

  Order copyWith({
    List<Cart>? products,
    num? totalPrice,
    String? address,
    String? userId,
    String? userName,
    String? orderedAt,
    num? status,
    String? id,
  }) {
    return Order(
      products: products ?? this.products,
      totalPrice: totalPrice ?? this.totalPrice,
      address: address ?? this.address,
      userId: userId ?? this.userId,
      userName:userName ?? this.userName,
      orderedAt: orderedAt ?? this.orderedAt,
      status: status ?? this.status,
      id: id ?? this.id,
    );
  }

  factory Order.fromJson(Map<String, dynamic> json){
    return Order(
      products: json["products"] == null ? [] : List<Cart>.from(json["products"]!.map((x) => Cart.fromJson(x))),
      totalPrice: json["totalPrice"],
      address: json["address"],
      userId: json["userId"],
      userName: json["userName"],
      orderedAt: json["orderedAt"],
      status: json["status"],
      id: json["_id"],
    );
  }

  Map<String, dynamic> toJson() => {
    "products": products.map((x) => x?.toJson()).toList(),
    "totalPrice": totalPrice,
    "address": address,
    "userId": userId,
    "userName":userName,
    "orderedAt": orderedAt,
    "status": status,
    "_id": id,
  };

}
