

class AuthModel {
  String? id;
  String? name;
  String? email;
  String? password;
  String? phoneNumber;
  String? token;
  String? address;
  String? city;
  String? role;
  List<dynamic>? cart;
  AuthModel({this.id, this.name, this.email, this.password,this.address,this.city, this.role, this.token,  this.cart, this.phoneNumber});


  AuthModel copyWith({
    String? token,
    String? id,
    String? email,
    String? password,
    String? address,
    String? city,
    String? phoneNumber,
    String? name,
    String? role,
    List<dynamic>? cart,
  }) {
    return AuthModel(
      token: token ?? this.token,
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      address: address ?? this.address,
      city:city ?? this.city,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      name: name ?? this.name,
      role: role ?? this.role,
      cart: cart ?? this.cart,
    );
  }

 factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
    id : json['_id'],
    name : json['name'],
    email : json['email'],
    password : json['password'],
    address : json['address'],
      city : json['city'],
      phoneNumber: json['phoneNumber'],
    role : json['role'],
    token : json['token'],
    cart:  List<Map<String, dynamic>>.from(
      json['cart']?.map(
            (x) => Map<String, dynamic>.from(x),
      ),
    ),
    ); }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phoneNumber'] = phoneNumber;
    data['address'] = address;
    data['city'] = city;
    data['password'] = password;
    data['role'] = role;
    data['token'] = token;
    data['cart'] = cart;
    return data;
  }






}
