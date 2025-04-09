class TempAdmin {
  TempAdmin({
    required this.id,
    required this.userId,
    required this.storeName,
    required this.phoneNumber,
    required this.branches,
  });

  final String? id;
  final String? userId;
  final String? storeName;
  final String? phoneNumber;
  final List<Branch> branches;

  TempAdmin copyWith({
    String? id,
    String? userId,
    String? storeName,
    String? phoneNumber,
    List<Branch>? branches,
  }) {
    return TempAdmin(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      storeName: storeName ?? this.storeName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      branches: branches ?? this.branches,
    );
  }

  factory TempAdmin.fromJson(Map<String, dynamic> json){
    return TempAdmin(
      id: json["_id"],
      userId: json["userId"],
      storeName: json["storeName"],
      phoneNumber: json["phoneNumber"],
      branches: json["branches"] == null ? [] : List<Branch>.from(json["branches"]!.map((x) => Branch.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userId": userId,
    "storeName": storeName,
    "phoneNumber": phoneNumber,
    "branches": branches.map((x) => x?.toJson()).toList(),
  };

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
