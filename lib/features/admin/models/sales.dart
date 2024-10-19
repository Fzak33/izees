import '../../../models/product_model.dart';

class Sales {
  final String label;
  final num earning;

  Sales(this.label, this.earning);
}


class ProductProfit {
  ProductProfit({
    required this.product,
    required this.totalQuantity,
    required this.totalPrice,
  });

  final Product? product;
  final num? totalQuantity;
  final num? totalPrice;

  ProductProfit copyWith({
    Product? product,
    num? totalQuantity,
    num? totalPrice,
  }) {
    return ProductProfit(
      product: product ?? this.product,
      totalQuantity: totalQuantity ?? this.totalQuantity,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }

  factory ProductProfit.fromJson(Map<String, dynamic> json){
    return ProductProfit(
      product: json["product"] == null ? null : Product.fromJson(json["product"]),
      totalQuantity: json["totalQuantity"],
      totalPrice: json["totalPrice"],
    );
  }

  Map<String, dynamic> toJson() => {
    "product": product?.toJson(),
    "totalQuantity": totalQuantity,
    "totalPrice": totalPrice,
  };

}
