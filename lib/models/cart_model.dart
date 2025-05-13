import 'package:izees/models/product_model.dart';

class Cart {
  Cart({
    required this.product,
    required this.quantity,
    required this.id
  });

  final Product? product;
  final int? quantity;
  final String? id;

  Cart copyWith({
    Product? product,
    int? quantity,
    String? id,
  }) {
    return Cart(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      id: id ?? this.id,
    );
  }

  factory Cart.fromJson(Map<String, dynamic> json){
    return Cart(
      product: json['product'] != null ? Product?.fromJson(json['product']) : null,
      quantity: json["quantity"],
      id: json["_id"],
    );
  }

  Map<String, dynamic> toJson() => {
    "quantity": quantity,
    "product": product?.toJson(),
    "_id": id,
  };

}