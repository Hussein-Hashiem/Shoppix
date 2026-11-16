import 'package:equatable/equatable.dart';
import 'package:mobile/features/product/domain/entities/product_entity.dart';

abstract class GetProductByIdStates extends Equatable {
  @override
  List<Object?> get props => [];
}

class SuccessGetProductByIdStates extends GetProductByIdStates {
  final ProductEntity products;

   SuccessGetProductByIdStates({required this.products});

  @override
  List<Object?> get props => [...super.props, products];
}

class FailGetProductByIdStates extends GetProductByIdStates {
  final String message;

  FailGetProductByIdStates({required this.message});

  @override
  List<Object?> get props => [message];
}

class LoadingGetProductByIdStates extends GetProductByIdStates {}

class InitialGetProductByIdStates extends GetProductByIdStates {}
