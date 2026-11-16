import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/routing/routes.dart';
import 'package:mobile/core/utils/responsive/responsive.dart';
import 'package:mobile/features/cart/domain/entities/cart_entity.dart';
import 'package:mobile/features/order/domain/entities/order_entity.dart';
import 'package:mobile/layout/presentation/cubit/layout_cubit.dart';

class OrderSummaryData {
  const OrderSummaryData({required this.cart, required this.order});

  final CartEntity cart;
  final OrderEntity order;
}

class OrderSummaryScreen extends StatelessWidget {
  const OrderSummaryScreen({super.key, required this.data});

  final OrderSummaryData data;

  @override
  Widget build(BuildContext context) {
    final cart = data.cart;
    final itemCount = cart.items.fold<int>(
      0,
      (total, item) => total + item.quantity,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: Text(
          "SHOPPPIX / ORDER SUMMARY",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                  Responsive.w(20),
                  Responsive.h(30),
                  Responsive.w(20),
                  Responsive.h(28),
                ),
                children: [
                  _buildConfirmation(),
                  SizedBox(height: Responsive.h(32)),
                  _buildOrderDetails(itemCount),
                  SizedBox(height: Responsive.h(20)),
                  _buildItemsHeading(itemCount),
                  SizedBox(height: Responsive.h(12)),
                  _buildItems(),
                  SizedBox(height: Responsive.h(28)),
                  SizedBox(
                    height: Responsive.h(56),
                    child: OutlinedButton(
                      onPressed: () {
                        context.read<LayoutCubit>().changeBottomNavIndex(0);
                        context.go('/');
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        side: const BorderSide(color: Colors.black),
                        shape: const RoundedRectangleBorder(),
                      ),
                      child: Text(
                        'BACK TO HOME',
                        style: TextStyle(
                          fontSize: Responsive.sp(14),
                          fontWeight: FontWeight.w600,
                          letterSpacing: Responsive.w(1),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: Responsive.h(12)),
                  SizedBox(
                    height: Responsive.h(56),
                    child: ElevatedButton(
                      onPressed: () => context.go(Routes.orderHistory),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(),
                      ),
                      child: Text(
                        'VIEW MY ORDERS',
                        style: TextStyle(
                          fontSize: Responsive.sp(14),
                          fontWeight: FontWeight.w600,
                          letterSpacing: Responsive.w(1),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          SizedBox(width: Responsive.w(18)),
          Container(
            width: Responsive.w(40),
            height: Responsive.w(40),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: Responsive.r(1.5)),
            ),
            alignment: Alignment.center,
            child: Text(
              'M',
              style: TextStyle(
                fontSize: Responsive.sp(16),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: Responsive.w(12)),
          Expanded(
            child: Text(
              'ORDER SUMMARY',
              style: TextStyle(
                fontSize: Responsive.sp(15),
                fontWeight: FontWeight.w700,
                letterSpacing: Responsive.w(1.5),
              ),
            ),
          ),
          CircleAvatar(
            radius: Responsive.r(20),
            backgroundColor: const Color(0xFFE8E8E8),
            child: Icon(
              Icons.person_outline,
              color: Colors.black,
              size: Responsive.sp(24),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmation() {
    return Column(
      children: [
        Container(
          width: Responsive.w(84),
          height: Responsive.w(84),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFD0D0D0),
          ),
          child: Icon(
            Icons.check_circle_outline,
            size: Responsive.sp(44),
            color: Colors.black,
          ),
        ),
        SizedBox(height: Responsive.h(24)),
        Text(
          'CONFIRMATION',
          style: TextStyle(
            fontSize: Responsive.sp(13),
            color: Colors.grey.shade700,
            letterSpacing: Responsive.w(1),
          ),
        ),
        SizedBox(height: Responsive.h(4)),
        Text(
          'Order Placed',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: Responsive.sp(30),
            fontWeight: FontWeight.w500,
            letterSpacing: -1,
          ),
        ),
        SizedBox(height: Responsive.h(8)),
        Text(
          'Thank you for your order. Here is a summary of the items in your cart.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: Responsive.sp(16),
            height: 1.6,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildOrderDetails(int itemCount) {
    final cart = data.cart;
    final order = data.order;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.w(24),
        vertical: Responsive.h(20),
      ),
      color: Colors.white,
      child: Column(
        children: [
          _detailRow('Order ID', order.id == null ? '—' : '#${order.id}'),
          _detailRow(
            'Date',
            order.orderDate == null ? '—' : _formatDate(order.orderDate!),
          ),
          _detailRow('Status', order.status ?? 'Confirmed'),
          _detailRow('Items', '$itemCount'),
          Padding(
            padding: EdgeInsets.only(top: Responsive.h(8)),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    order.totalPrice == null
                        ? 'Estimated total'
                        : 'Order total',
                    style: TextStyle(
                      fontSize: Responsive.sp(16),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  '\$${(order.totalPrice ?? cart.total).toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: Responsive.sp(21),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    final localDate = date.toLocal();
    return '${months[localDate.month - 1]} ${localDate.day}, ${localDate.year}';
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Responsive.h(11)),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: Responsive.sp(15),
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: Responsive.sp(15),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsHeading(int itemCount) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'ITEMS IN THIS PACKAGE ($itemCount)',
            style: TextStyle(
              fontSize: Responsive.sp(13),
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
              letterSpacing: Responsive.w(0.5),
            ),
          ),
        ),
        Text(
          'Standard dispatch',
          style: TextStyle(
            fontSize: Responsive.sp(12),
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildItems() {
    final cart = data.cart;
    return GridView.builder(
      itemCount: cart.items.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: Responsive.w(12),
        mainAxisSpacing: Responsive.h(12),
        childAspectRatio: 0.69,
      ),
      itemBuilder: (context, index) => _OrderItemCard(item: cart.items[index]),
    );
  }
}

class _OrderItemCard extends StatelessWidget {
  const _OrderItemCard({required this.item});

  final CartItemEntity item;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(Responsive.w(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  item.product.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    color: const Color(0xFFF0F0F0),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      color: Colors.grey,
                      size: Responsive.sp(28),
                    ),
                  ),
                ),
                Positioned(
                  top: Responsive.h(6),
                  right: Responsive.w(6),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Responsive.w(7),
                      vertical: Responsive.h(4),
                    ),
                    color: const Color(0xFFE8E8E8),
                    child: Text(
                      'Qty ${item.quantity}',
                      style: TextStyle(
                        fontSize: Responsive.sp(11),
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: Responsive.h(10)),
          Text(
            item.product.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: Responsive.sp(14),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: Responsive.h(5)),
          Text(
            '\$${item.cartItemTotal.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: Responsive.sp(13),
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
