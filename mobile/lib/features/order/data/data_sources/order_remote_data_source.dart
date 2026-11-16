import 'package:mobile/core/network/api_client.dart';
import 'package:mobile/core/utils/constants/endpoints.dart';
import 'package:mobile/features/order/data/models/create_order_item_model.dart';
import 'package:mobile/features/order/data/models/order_model.dart';

abstract class OrderRemoteDataSource {
  Future<OrderModel> createOrder(
    List<CreateOrderItemModel> items, {
    required String token,
  });
  Future<List<OrderModel>> getMyOrders({required String token});
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final ApiClient apiClient;
  OrderRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<OrderModel> createOrder(
    List<CreateOrderItemModel> items, {
    required String token,
  }) async {
    final response = await apiClient.post(
      ApiEndpoints.orders,
      data: {'items': items.map((e) => e.toJson()).toList()},
      token: token,
    );
    return OrderModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<List<OrderModel>> getMyOrders({required String token}) async {
    final response = await apiClient.get(ApiEndpoints.orders, token: token);
    return (response.data as List)
        .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
