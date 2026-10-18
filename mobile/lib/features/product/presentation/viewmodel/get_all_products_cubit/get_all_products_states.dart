import 'package:equatable/equatable.dart';
import 'package:mobile/features/product/domain/entities/product_entity.dart';

abstract class GetAllProductsStates extends Equatable {
  @override
  List<Object?> get props => [];
}

class SuccessGetAllProductState extends GetAllProductsStates {
  final List<ProductEntity> products;

  new({required this.products});

  @override
  List<Object?> get props => [...super.props, products];
}

class FailGetAllProductState extends GetAllProductsStates {
  final String message;

  new({required this.message});

  @override
  List<Object?> get props => [message];
}

class LoadingGetAllProductState extends GetAllProductsStates {}

class InitialGetAllProductState extends GetAllProductsStates {}
