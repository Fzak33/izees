

import 'dart:io';

import 'color_model.dart';

class Product {
  final String name;
  final String description;
  final num quantity;
  final List<String> images;
  final String category;
  final num price;
  String? storeName;
    String? storeImage;
  final String? id;
  final String? userId;
  final String? location;
  final List<ColorModel> colors;
  Product({
    required this.name,
    required this.description,
    required this.quantity,
    required this.images,
    required this.category,
    required this.price,
    required this.location,
    required this.storeName,
     this.storeImage,
    this.id,
    this.userId,
    required this.colors
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "description": description,
      "images": images.map((x) => x).toList(),
      "storeImage": storeImage,
      "quantity": quantity,
      "price": price,
      "category": category,
      "storeName":storeName,
      "userId": userId,
      "location":location,
      "_id": id,
      'colors': colors.map((x) => x.toJson()).toList(),
    };
  }

  factory Product.fromJson(Map<String, dynamic> map) {
   // final imageUrl = map['storeImage'];

    return Product(
      storeImage: map['storeImage'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      quantity: map['quantity']?.toDouble() ?? 0.0,
        images: map["images"] == null ? [] : List<String>.from(map["images"]!.map((x) => x)),

        //images: map['images'].map<File>((path) => File(path)).toList(),
 //   images: map["images"] == null ? [] : List<File>.from(map["images"]!.map((x) => x)),
      category: map['category'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
        storeName:map['storeName'],
      id: map['_id'],
        location:map['location'],
     userId: map['userId'],
      colors: map['colors'] != null
          ? List<ColorModel>.from(map['colors'].map((x) => ColorModel.fromJson(x)))
          : [],
    );
  }


  Product copyWith({
    String? id,
    String? name,
    String? description,
    List<String>? images,
    num? quantity,
    num? price,
    String? storeImage,
    String? category,
    String? userId,
    String? storeName,
    String? location,
    List<ColorModel>? colors,

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
     storeImage: storeImage ?? this.storeImage,
        colors: colors ?? this.colors,
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

