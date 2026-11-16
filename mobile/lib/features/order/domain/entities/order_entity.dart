import 'package:equatable/equatable.dart';

class OrderEntity extends Equatable {
  final int? id;
  final DateTime? orderDate;
  final double? totalPrice;
  final String? status;

  const OrderEntity({this.id, this.orderDate, this.totalPrice, this.status});

  @override
  List<Object?> get props => [id, orderDate, totalPrice, status];
}
