import 'package:mobile/features/product/domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.description,
    required super.name,
    required super.price,
    required super.stockQuantity,
    required super.imageUrl,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      description: json['description'],
      name: json['name'],
      price: json['price'],
      stockQuantity: json['stockQuantity'],
      imageUrl: json['imageUrl'],
    );
  }
}
