import 'package:izees/models/product_model.dart';

class Cart {
  Cart({
    required this.product,
    required this.quantity,
    required this.id,
    required this.colorName,
  required this.image
  });

  final Product? product;
  final int? quantity;
  final String? id;
  final String? colorName;
  final String image;

  Cart copyWith({
    Product? product,
    int? quantity,
    String? id,
    String? colorName,
    String? image,
  }) {
    return Cart(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      id: id ?? this.id,
      colorName: colorName?? this.colorName,
      image: image ?? this.image
    );
  }

  factory Cart.fromJson(Map<String, dynamic> json){
    return Cart(
      product: json['product'] != null ? Product?.fromJson(json['product']) : null,
      quantity: json["quantity"],
      id: json["_id"],
      colorName: json["colorName"],
      image: json["image"]
    );
  }

  Map<String, dynamic> toJson() => {
    "quantity": quantity,
    "product": product?.toJson(),
    "_id": id,
    "colorName":colorName,
    "image":image
  };

}