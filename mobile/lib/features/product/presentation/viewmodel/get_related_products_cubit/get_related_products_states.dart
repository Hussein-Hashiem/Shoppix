import 'package:equatable/equatable.dart';
import 'package:mobile/features/product/domain/entities/product_entity.dart';

abstract class GetRelatedProductsStates extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialGetRelatedProductsState extends GetRelatedProductsStates {}

class LoadingGetRelatedProductsState extends GetRelatedProductsStates {}

class SuccessGetRelatedProductsState extends GetRelatedProductsStates {
  final List<ProductEntity> products;

  SuccessGetRelatedProductsState({required this.products});

  @override
  List<Object?> get props => [products];
}

class FailGetRelatedProductsState extends GetRelatedProductsStates {
  final String message;

  FailGetRelatedProductsState({required this.message});

  @override
  List<Object?> get props => [message];
}
