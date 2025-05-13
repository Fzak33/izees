import '../../../models/product_model.dart';

class Sales {
  final String label;
  final num earning;

  Sales(this.label, this.earning);
}


class ProductProfit {
  ProductProfit({
    required this.id,
    required this.product,
    required this.totalQuantity,
    required this.totalPrice,
  });

  final String? id;
  final Product? product;
  final num? totalQuantity;
  final num? totalPrice;

  ProductProfit copyWith({
    String? id,
    Product? product,
    num? totalQuantity,
    num? totalPrice,
  }) {
    return ProductProfit(
      id: id ?? this.id,
      product: product ?? this.product,
      totalQuantity: totalQuantity ?? this.totalQuantity,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }

  factory ProductProfit.fromJson(Map<String, dynamic> json){
    return ProductProfit(
      id: json["id"],
      product: json["product"] == null ? null : Product.fromJson(json["product"]),
      totalQuantity: json["totalQuantity"],
      totalPrice: json["totalPrice"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id":id,
    "product": product?.toJson(),
    "totalQuantity": totalQuantity,
    "totalPrice": totalPrice,
  };

}
