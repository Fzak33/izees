import 'dart:io';

import 'package:izees/models/auth_model.dart';
import 'package:izees/models/product_model.dart';


class AdminModel extends AuthModel{
  String? storeName;
  bool? isSell;
  List<Product?>? product;
  List<Branch?>? branches;
  String? storeImage;
  AdminModel({

    String? id,
    String? name,
    String? email,
    String? password,
    String? phoneNumber,
    String? address,
    String? city,
    String? token,
    List<dynamic>? cart,
    String? role = 'admin',
    this.isSell = false,
    this.storeName,
    this.product,
    this.branches,
    this.storeImage
  }):super(id:id,name: name, email: email,password: password,address: address,city:city,token: token,role: role,cart: cart, phoneNumber: phoneNumber);

 factory AdminModel.fromJson(Map<String, dynamic> json) {
   final imageUrl = json['storeImage'];

   return AdminModel(
    id : json['_id'],
    name : json['name'],
    email : json['email'],
    password : json['password'],
     phoneNumber: json['phoneNumber'],
     address : json['address'],
     city : json['city'],
     isSell : json['isSell'],
    storeImage: json['storeImage'],

     cart: List<Map<String, dynamic>>.from(
      json['cart']?.map(
            (x) => Map<String, dynamic>.from(x),
      ),
    ),
    role : json['role'],
    token : json['token'],

    storeName : json['storeName'],
     //  product: json["myProduct"] == null ? [] : List<Product>.from(json["myProduct"]!.map((x) => Product.fromJson(x))),
     branches: json["branches"] == null ? [] : List<Branch>.from(json["branches"]!.map((x) => Branch.fromJson(x))),



   );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = id;
   data['storeImage']= storeImage;
    data['name'] = name;
    data['email'] = email;
    data['password'] = password;
    data['address'] = address;
    data['city'] = city;
    data['isSell']=isSell;
    data['cart'] = cart;
    data['role'] = role;
    data['phoneNumber'] = phoneNumber;
    data['token'] = token;
    data['storeName'] = storeName;
    data['product'] =
    product != null ? product!.map((v) => v?.toJson()).toList() : null;
    data['branches'] =
    branches?.map((x) => x?.toJson()).toList();

    return data;
  }
  Map<String, dynamic> toProduct() {
    final Map<String, dynamic> data = Map<String, dynamic>();

    data['product'] =
    product != null ? product!.map((v) => v?.toJson()).toList() : null;

    return data;
  }

  AdminModel copyWith({
    String? storeName,
    String? id,
    String? name,
    String? email,
    String? address,
    String? city,
    bool? isSell,
    String? phoneNumber,
    String? password,
    String? token,
    List<dynamic>? cart,
    String? role = 'admin',
    List<Product?>? product,
    List<Branch?>? branches,
    String? storeImage,

  }){
    return AdminModel(
      id: this.id,
      storeName: this.storeName,
      name: name ?? this.name,
      email: this.email,
      password: this.password,
        address: address ?? this.address,
        city: city ?? this.city,
        isSell: isSell,
        token: token ?? this.token,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      cart: cart ?? this.cart,
      role: this.role,
      product: product ?? this.product,
      branches: branches ?? this.branches,
     storeImage: storeImage ?? this.storeImage
    );
}

}


class Branch {
  Branch({
    required this.address,
    required this.cityStore,
  });

  final String? address;
  final String? cityStore;

  Branch copyWith({
    String? address,
    String? cityStore,
  }) {
    return Branch(
      address: address ?? this.address,
      cityStore: cityStore ?? this.cityStore,
    );
  }

  factory Branch.fromJson(Map<String, dynamic> json){
    return Branch(
      address: json["address"],
      cityStore: json["cityStore"],
    );
  }

  Map<String, dynamic> toJson() => {
    "address": address,
    "cityStore": cityStore,
  };

}