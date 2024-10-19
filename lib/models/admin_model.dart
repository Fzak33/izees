import 'package:izees/models/auth_model.dart';
import 'package:izees/models/product_model.dart';

import 'cart_model.dart';

class AdminModel extends AuthModel{
  String? storeName;
  List<Product?>? product;
  List<String?>? branches;

  AdminModel({

    String? id,
    String? name,
    String? email,
    String? password,
    String? phoneNumber,
    String? address,
    String? token,
    List<dynamic?>? cart,
    String? role = 'admin',
    this.storeName,
    this.product,
    this.branches}):super(id:id,name: name, email: email,password: password,address: address,token: token,role: role,cart: cart, phoneNumber: phoneNumber);

 factory AdminModel.fromJson(Map<String, dynamic> json) {
   return AdminModel(
    id : json['_id'],
    name : json['name'],
    email : json['email'],
    password : json['password'],
     phoneNumber: json['phoneNumber'],
     address : json['address'],
    cart: List<Map<String, dynamic>>.from(
      json['cart']?.map(
            (x) => Map<String, dynamic>.from(x),
      ),
    ),
    role : json['role'],
    token : json['token'],

    storeName : json['storeName'],
     //  product: json["myProduct"] == null ? [] : List<Product>.from(json["myProduct"]!.map((x) => Product.fromJson(x))),
      branches:  List<String>.from(
        json['branches']?.map(
              (x) => x['branches'],
        ),
      ),



   );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['password'] = password;
    data['address'] = address;
    data['cart'] = cart;
    data['role'] = role;
    data['phoneNumber'] = phoneNumber;
    data['token'] = token;
    data['storeName'] = storeName;
    data['product'] =
    product != null ? product!.map((v) => v?.toJson()).toList() : null;
    data['branches'] =
    branches != null ? branches!.map((v) => v).toList() : null;

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
    String? phoneNumber,
    String? password,
    String? token,
    List<dynamic>? cart,
    String? role = 'admin',
    List<Product?>? product,
    List<String?>? branches,

  }){
    return AdminModel(
      id: this.id,
      storeName: this.storeName,
      name: name ?? this.name,
      email: this.email,
      password: this.password,
        address: address ?? this.address,
      token: token ?? this.token,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      cart: cart ?? this.cart,
      role: this.role,
      product: product ?? this.product,
      branches: branches ?? this.branches
    );
}

}
