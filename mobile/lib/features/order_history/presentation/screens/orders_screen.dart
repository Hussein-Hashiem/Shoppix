import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/routing/routes.dart';
import 'package:mobile/core/utils/constants/colors.dart';
import 'package:mobile/core/utils/responsive/responsive.dart';
import 'package:mobile/core/utils/constants/style.dart';
import 'package:mobile/features/order/domain/entities/order_entity.dart';
import 'package:mobile/features/order/presentation/viewmodel/orders_cubit.dart';
import 'package:mobile/features/order/presentation/viewmodel/orders_state.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  _OrderFilter _selectedFilter = _OrderFilter.all;

  List<OrderEntity> _visibleOrders(List<OrderEntity> orders) {
    if (_selectedFilter == _OrderFilter.all) return orders;
    return orders
        .where((order) => _statusFor(order) == _selectedFilter)
        .toList();
  }

  int _countFor(List<OrderEntity> orders, _OrderFilter filter) {
    if (filter == _OrderFilter.all) return orders.length;
    return orders.where((order) => _statusFor(order) == filter).length;
  }

  _OrderFilter _statusFor(OrderEntity order) {
    final status = order.status?.toLowerCase().trim();
    return status == 'delivered' ||
            status == 'complete' ||
            status == 'completed'
        ? _OrderFilter.delivered
        : _OrderFilter.processing;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrdersCubit, OrdersState>(
      listener: (context, state) {
        if (state is OrdersFailure && _isAuthenticationFailure(state.message)) {
          context.go(Routes.login);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFAFAFA),
        appBar: AppBar(
          title: Text(
            "SHOPPPIX / ORDERS",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          centerTitle: false,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: BlocBuilder<OrdersCubit, OrdersState>(
                  builder: (context, state) {
                    if (state is OrdersLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is OrdersFailure) {
                      return _buildError(state.message);
                    }

                    if (state is OrdersSuccess) {
                      return _buildOrders(state.orders);
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.w(20),
        vertical: Responsive.h(16),
      ),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: Row(
        children: [
          Text(
            'SHOPPIX  /  ORDERS',
            style: TextStyle(
              fontSize: Responsive.sp(15),
              fontWeight: FontWeight.w700,
              letterSpacing: Responsive.w(1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrders(List<OrderEntity> orders) {
    final visibleOrders = _visibleOrders(orders);
    return RefreshIndicator(
      color: Colors.black,
      onRefresh: () => context.read<OrdersCubit>().getOrders(),
      child: ListView(
        padding: EdgeInsets.fromLTRB(
          Responsive.w(20),
          Responsive.h(24),
          Responsive.w(20),
          Responsive.h(36),
        ),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  'My Orders',
                  style: TextStyle(
                    fontSize: Responsive.sp(28),
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.8,
                  ),
                ),
              ),
              Text(
                '${orders.length} RECORDS',
                style: TextStyle(
                  fontSize: Responsive.sp(10),
                  fontWeight: FontWeight.w600,
                  letterSpacing: Responsive.w(0.6),
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
          SizedBox(height: Responsive.h(6)),
          Text(
            'Review your orders and their current status.',
            style: TextStyle(
              fontSize: Responsive.sp(13),
              color: Colors.grey.shade700,
            ),
          ),
          SizedBox(height: Responsive.h(22)),
          _buildFilters(orders),
          SizedBox(height: Responsive.h(22)),
          if (visibleOrders.isEmpty)
            _buildEmptyState(orders.isEmpty)
          else
            ...visibleOrders.map(
              (order) => Padding(
                padding: EdgeInsets.only(bottom: Responsive.h(14)),
                child: _buildOrderCard(order),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFilters(List<OrderEntity> orders) {
    return Row(
      children: [
        for (final filter in _OrderFilter.values) ...[
          if (filter != _OrderFilter.all) SizedBox(width: Responsive.w(6)),
          Expanded(
            child: InkWell(
              onTap: () => setState(() => _selectedFilter = filter),
              child: Container(
                height: Responsive.h(34),
                alignment: Alignment.center,
                color: _selectedFilter == filter
                    ? Colors.black
                    : const Color(0xFFEFEFEF),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: Responsive.w(5)),
                    child: Text(
                      '${filter.label} (${_countFor(orders, filter)})',
                      style: TextStyle(
                        fontSize: Responsive.sp(10),
                        fontWeight: FontWeight.w600,
                        color: _selectedFilter == filter
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildOrderCard(OrderEntity order) {
    final filter = _statusFor(order);
    final status = order.status?.trim();
    return Container(
      padding: EdgeInsets.all(Responsive.w(18)),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  order.id == null ? 'Order' : 'Order #${order.id}',
                  style: TextStyle(
                    fontSize: Responsive.sp(17),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Responsive.w(10),
                  vertical: Responsive.h(5),
                ),
                color: const Color(0xFFEFEFEF),
                child: Text(
                  status?.isNotEmpty == true ? status!.toUpperCase() : 'NEW',
                  style: TextStyle(
                    fontSize: Responsive.sp(9),
                    fontWeight: FontWeight.w600,
                    letterSpacing: Responsive.w(0.4),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: Responsive.h(10)),
          Text(
            'Placed ${_formatDate(order.orderDate)}',
            style: TextStyle(
              fontSize: Responsive.sp(12),
              color: Colors.grey.shade700,
            ),
          ),
          SizedBox(height: Responsive.h(18)),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ORDER TOTAL',
                      style: TextStyle(
                        fontSize: Responsive.sp(9),
                        color: Colors.grey.shade700,
                        letterSpacing: Responsive.w(0.5),
                      ),
                    ),
                    SizedBox(height: Responsive.h(3)),
                    Text(
                      order.totalPrice == null
                          ? '—'
                          : '\$${order.totalPrice!.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: Responsive.sp(18),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => _showOrderDetails(order, filter),
                child: Text(
                  'VIEW DETAILS',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: Responsive.sp(15),
                    fontWeight: FontWeight.w700,
                    letterSpacing: Responsive.w(1),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool noOrders) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Responsive.h(48)),
      child: Column(
        children: [
          Icon(
            noOrders ? Icons.receipt_long_outlined : Icons.filter_list_off,
            size: Responsive.sp(40),
            color: Colors.grey.shade600,
          ),
          SizedBox(height: Responsive.h(12)),
          Text(
            noOrders ? 'No orders yet' : 'No orders match this filter',
            style: TextStyle(
              fontSize: Responsive.sp(17),
              fontWeight: FontWeight.w600,
            ),
          ),
          if (noOrders) ...[
            SizedBox(height: Responsive.h(8)),
            Text(
              'Your completed purchases will appear here.',
              style: TextStyle(
                fontSize: Responsive.sp(13),
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildError(String message) {
    final authenticationFailure = _isAuthenticationFailure(message);
    return Center(
      child: Padding(
        padding: EdgeInsets.all(Responsive.w(24)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            SizedBox(height: Responsive.h(16)),
            ElevatedButton(
              onPressed: authenticationFailure
                  ? () => context.go(Routes.login)
                  : () => context.read<OrdersCubit>().getOrders(),
              child: Text(authenticationFailure ? 'SIGN IN' : 'TRY AGAIN'),
            ),
          ],
        ),
      ),
    );
  }

  void _showOrderDetails(OrderEntity order, _OrderFilter filter) {
    final total = order.totalPrice == null
        ? '—'
        : '\$${order.totalPrice!.toStringAsFixed(2)}';
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(color: AppColors.border),
        ),
        titleTextStyle: AppTextStyles.titleLarge,
        contentTextStyle: AppTextStyles.bodyLarge,
        title: Text(order.id == null ? 'Order details' : 'Order #${order.id}'),
        content: Text(
          'Status: ${order.status ?? filter.label}\n'
          'Date: ${_formatDate(order.orderDate)}\n'
          'Total: $total',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.button,
              textStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.button,
                fontWeight: FontWeight.w600,
              ),
            ),
            child: const Text('CLOSE'),
          ),
        ],
      ),
    );
  }

  bool _isAuthenticationFailure(String message) {
    final normalized = message.toLowerCase();
    return normalized.contains('sign in') || normalized.contains('session');
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'date unavailable';
    final local = date.toLocal();
    return '${local.year}-${local.month.toString().padLeft(2, '0')}-'
        '${local.day.toString().padLeft(2, '0')}';
  }
}

enum _OrderFilter {
  all('ALL'),
  processing('PROCESSING'),
  delivered('DELIVERED');

  const _OrderFilter(this.label);

  final String label;
}
