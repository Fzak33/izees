class ColorModel {
  final String id;
  final String name;
  final int quantity;
  final String image;
final int? colorValue;

  ColorModel({
    required this.id,
    required this.name,
    required this.quantity,
    required this.image,
    required this.colorValue,
  });

  factory ColorModel.fromJson(Map<String, dynamic> json) {
    return ColorModel(
      id: json['_id'],
      name: json['name'] ?? 'Default',
      quantity: json['quantity'],
      image: json['image'],
        colorValue: json['colorValue']
    );
  }

  Map<String, dynamic> toJson() => {
    '_id':id,
    'name': name,
    'quantity': quantity,
    'image': image,
    'colorValue':colorValue
  };


  ColorModel copyWith({
    String? id,
    String? name,
    int? quantity,
    String? image,
    int? colorValue,
  }) {
    return ColorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      image: image ?? this.image,
      colorValue: colorValue ?? this.colorValue,
    );
  }
}
