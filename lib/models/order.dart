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
    required this.driverPrice,
    required this.userPhoneNumber,
    required this.storePhoneNumber,
  });

  final List<Cart> products;
  final num? totalPrice;
  final String? address;
  final String? userId;
  final String? orderedAt;
  final num? status;
  final num? driverPrice;
  final String? id;
  final String? userName;
  final String? userPhoneNumber;
  final List<String> storePhoneNumber;

  Order copyWith({
    List<Cart>? products,
    num? totalPrice,
    String? address,
    String? userId,
    String? userName,
    String? orderedAt,
    num? driverPrice,
    num? status,
    String? id,
    String? userPhoneNumber,
    List<String>? storePhoneNumber,
  }) {
    return Order(
      products: products ?? this.products,
      totalPrice: totalPrice ?? this.totalPrice,
      address: address ?? this.address,
      userId: userId ?? this.userId,
      userName:userName ?? this.userName,
      orderedAt: orderedAt ?? this.orderedAt,
      driverPrice: driverPrice ?? this.driverPrice,
      status: status ?? this.status,
      id: id ?? this.id,
      userPhoneNumber: userPhoneNumber ?? this.userPhoneNumber,
      storePhoneNumber: storePhoneNumber ?? this.storePhoneNumber,
    );
  }

  factory Order.fromJson(Map<String, dynamic> json){
    return Order(
      products: json["products"] == null ? [] : List<Cart>.from(json["products"]!.map((x) => Cart.fromJson(x))),
      totalPrice: json["totalPrice"],
      address: json["address"],
      userId: json["userId"],
      userName: json["userName"],
      driverPrice: json['driverPrice'],
      orderedAt: json["orderedAt"],
      status: json["status"],
      id: json["_id"],
      userPhoneNumber: json["userPhoneNumber"],
      storePhoneNumber: json["storePhoneNumber"] == null ? [] : List<String>.from(json["storePhoneNumber"]!.map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
    "products": products.map((x) => x.toJson()).toList(),
    "totalPrice": totalPrice,
    "address": address,
    "userId": userId,
    "userName":userName,
    "orderedAt": orderedAt,
    "driverPrice":"driverPrice",
    "status": status,
    "_id": id,
    "userPhoneNumber": userPhoneNumber,
    "storePhoneNumber": storePhoneNumber.map((x) => x).toList(),
  };

}
