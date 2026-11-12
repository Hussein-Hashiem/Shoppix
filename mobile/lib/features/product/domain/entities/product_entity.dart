import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final int id;
  final String description;
  final String name;
  final double price;
  final int stockQuantity;
  final String imageUrl;

  const ProductEntity({
    required this.id,
    required this.description,
    required this.name,
    required this.price,
    required this.stockQuantity,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [
    description,
    name,
    price,
    stockQuantity,
    imageUrl,
    id,
  ];
}
