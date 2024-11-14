

import 'dart:io';

class Product {
  final String name;
  final String description;
  final num quantity;
  final List<File> images;
  final String category;
  final num price;
  String? storeName;
  final String? id;
  final String? userId;
  final String? location;
  Product({
    required this.name,
    required this.description,
    required this.quantity,
    required this.images,
    required this.category,
    required this.price,
    required this.location,
    required this.storeName,
    this.id,
    this.userId
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "description": description,
      "images": images.map((x) => x).toList(),
      "quantity": quantity,
      "price": price,
      "category": category,
      "storeName":storeName,
      "userId": userId,
      "location":location,
      "_id": id,
    };
  }

  factory Product.fromJson(Map<String, dynamic> map) {
    return Product(
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      quantity: map['quantity']?.toDouble() ?? 0.0,
     images: map['images'].map<File>((path) => File(path)).toList(),
 //     images: map["images"] == null ? [] : List<File>.from(map["images"]!.map((x) => x)),
      category: map['category'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
        storeName:map['storeName'],
      id: map['_id'],
        location:map['location'],
     userId: map['userId']
    );
  }


  Product copyWith({
    String? id,
    String? name,
    String? description,
    List<File>? images,
    num? quantity,
    num? price,
    String? category,
    String? userId,
    String? storeName,
    String? location
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      images: images ?? this.images,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      category: category ?? this.category,
      userId: userId ?? this.userId,
      storeName: storeName ?? this.storeName,
      location: location ?? this.location,
    );
  }




}


class Root {
  Product? product;
  String? id;

  Root({this.product, this.id});

  Root.fromJson(Map<String, dynamic> json) {
    product = json['product'] != null ? Product?.fromJson(json['product']) : null;
    id = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['product'] = product!.toJson();
    data['_id'] = id;
    return data;
  }
}

