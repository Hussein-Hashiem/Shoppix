import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mobile/core/utils/responsive/responsive.dart';
import 'package:mobile/features/cart/domain/entities/cart_entity.dart';
import 'package:mobile/features/cart/presentation/viewmodel/cart_cubit.dart';
import 'package:mobile/features/cart/presentation/viewmodel/cart_state.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<CartCubit>().getCartProducts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: BlocBuilder<CartCubit, CartState>(
                builder: (context, state) {
                  if (state is CartLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.black),
                    );
                  }

                  if (state is CartFail) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(Responsive.w(24)),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              state.message,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: Responsive.sp(16)),
                            ),
                            SizedBox(height: Responsive.h(16)),
                            ElevatedButton(
                              onPressed: () {
                                context.read<CartCubit>().getCartProducts();
                              },
                              child: const Text('Try Again'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (state is CartSuccess) {
                    final cart = state.cart;

                    if (cart.items.isEmpty) {
                      return _buildEmptyCart();
                    }

                    return _buildCartContent(cart);
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
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
          Container(
            width: Responsive.w(42),
            height: Responsive.w(42),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: Responsive.r(1.5)),
            ),
            alignment: Alignment.center,
            child: Text(
              'M',
              style: TextStyle(
                fontSize: Responsive.sp(18),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: Responsive.w(12)),
          Text(
            'SHOPPIX',
            style: TextStyle(
              fontSize: Responsive.sp(18),
              fontWeight: FontWeight.w700,
              letterSpacing: Responsive.w(2),
            ),
          ),
          SizedBox(width: Responsive.w(18)),
          Text(
            '/',
            style: TextStyle(fontSize: Responsive.sp(20), color: Colors.grey),
          ),
          SizedBox(width: Responsive.w(18)),
          Text(
            'CART',
            style: TextStyle(
              fontSize: Responsive.sp(16),
              fontWeight: FontWeight.w600,
              letterSpacing: Responsive.w(1),
            ),
          ),
          const Spacer(),
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

  Widget _buildCartContent(CartEntity cart) {
    return ListView(
      padding: EdgeInsets.fromLTRB(
        Responsive.w(20),
        Responsive.h(24),
        Responsive.w(20),
        Responsive.h(28),
      ),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                'Shopping Cart',
                style: TextStyle(
                  fontSize: Responsive.sp(29),
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1,
                ),
              ),
            ),
            Text(
              '${cart.items.length} ITEMS',
              style: TextStyle(
                fontSize: Responsive.sp(12),
                color: Colors.grey.shade700,
                letterSpacing: Responsive.w(1),
              ),
            ),
          ],
        ),
        SizedBox(height: Responsive.h(8)),
        Text(
          'Review your selected pieces before secure checkout.',
          style: TextStyle(
            fontSize: Responsive.sp(14),
            color: Colors.grey.shade700,
          ),
        ),
        SizedBox(height: Responsive.h(24)),
        _buildShippingBanner(),
        SizedBox(height: Responsive.h(20)),
        ...cart.items.map(_buildCartItem),
        SizedBox(height: Responsive.h(20)),
        _buildSummary(cart),
        SizedBox(height: Responsive.h(20)),
        _buildBenefits(),
        SizedBox(height: Responsive.h(20)),
        SizedBox(
          height: Responsive.h(54),
          child: ElevatedButton(
            onPressed: () {
              // TODO: Navigate to the checkout page.
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Responsive.r(6)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Text(
                  'PROCEED TO CHECKOUT',
                  style: TextStyle(
                    fontSize: Responsive.sp(14),
                    fontWeight: FontWeight.w600,
                    letterSpacing: Responsive.w(1),
                  ),
                ),
                SizedBox(width: Responsive.w(8)),
                const Icon(Icons.arrow_forward),
                const Spacer(),
              ],
            ),
          ),
        ),
        SizedBox(height: Responsive.h(12)),
        Center(
          child: Text(
            'Encrypted & verified end-to-end transaction',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: Responsive.sp(11),
              color: Colors.grey.shade700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShippingBanner() {
    return Container(
      padding: EdgeInsets.all(Responsive.w(12)),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(Responsive.r(6)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.local_shipping_outlined, size: Responsive.sp(20)),
              SizedBox(width: Responsive.w(8)),
              Expanded(
                child: Text(
                  'COMPLIMENTARY SHIPPING UNLOCKED',
                  style: TextStyle(
                    fontSize: Responsive.sp(11),
                    fontWeight: FontWeight.w600,
                    letterSpacing: Responsive.w(0.4),
                  ),
                ),
              ),
              Text('100%', style: TextStyle(fontSize: Responsive.sp(11))),
            ],
          ),
          SizedBox(height: Responsive.h(8)),
          Container(
            height: Responsive.h(5),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(Responsive.r(10)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(CartItemEntity item) {
    final product = item.product;

    return Container(
      padding: EdgeInsets.symmetric(vertical: Responsive.h(18)),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE5E5E5))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: Responsive.w(92),
            height: Responsive.h(112),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(Responsive.r(6)),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Icon(
                  Icons.image_not_supported_outlined,
                  color: Colors.grey,
                  size: Responsive.sp(28),
                );
              },
            ),
          ),
          SizedBox(width: Responsive.w(14)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        product.name,
                        style: TextStyle(
                          fontSize: Responsive.sp(16),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(width: Responsive.w(4)),
                    InkWell(
                      onTap: () {
                        context.read<CartCubit>().deleteProductFromCart(
                          product.id,
                        );
                      },
                      child: Icon(
                        Icons.close,
                        size: Responsive.sp(22),
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Responsive.h(12)),
                Text(
                  'Quantity: ${item.quantity}',
                  style: TextStyle(
                    fontSize: Responsive.sp(12),
                    color: Colors.grey.shade700,
                  ),
                ),
                SizedBox(height: Responsive.h(12)),
                Container(
                  height: Responsive.h(36),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F2F2),
                    borderRadius: BorderRadius.circular(Responsive.r(6)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _quantityButton(
                        icon: Icons.remove,
                        onTap: () {
                          context.read<CartCubit>().decreaseProductQuantity(
                            product.id,
                          );
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Responsive.w(8),
                        ),
                        child: Text(
                          '${item.quantity}',
                          style: TextStyle(
                            fontSize: Responsive.sp(13),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      _quantityButton(
                        icon: Icons.add,
                        onTap: () {
                          context.read<CartCubit>().addProductToCart(
                            product.id,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: Responsive.h(12)),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '\$${item.cartItemTotal.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: Responsive.sp(17),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _quantityButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: Responsive.w(32),
        height: Responsive.h(36),
        child: Icon(icon, size: Responsive.sp(17)),
      ),
    );
  }

  Widget _buildSummary(CartEntity cart) {
    return Container(
      padding: EdgeInsets.all(Responsive.w(16)),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(Responsive.r(6)),
      ),
      child: Column(
        children: [
          _summaryRow('Subtotal', '\$${cart.subtotal.toStringAsFixed(2)}'),
          SizedBox(height: Responsive.h(16)),
          _summaryRow('Estimated Shipping', 'COMPLIMENTARY'),
          SizedBox(height: Responsive.h(16)),
          _summaryRow(
            'Estimated Sales Tax',
            '\$${cart.salesTax.toStringAsFixed(2)}',
          ),
          SizedBox(height: Responsive.h(16)),
          const Divider(color: Color(0xFFDDDDDD)),
          SizedBox(height: Responsive.h(8)),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Total',
                  style: TextStyle(
                    fontSize: Responsive.sp(20),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                '\$${cart.total.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: Responsive.sp(25),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          SizedBox(height: Responsive.h(6)),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Includes applicable taxes',
              style: TextStyle(
                fontSize: Responsive.sp(11),
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String title, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: Responsive.sp(13),
              color: Colors.grey.shade700,
            ),
          ),
        ),
        SizedBox(width: Responsive.w(8)),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: Responsive.sp(13),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBenefits() {
    return Row(
      children: [
        Expanded(
          child: _benefitItem(
            Icons.verified_user_outlined,
            'Carbon Neutral\nFulfillment',
          ),
        ),
        SizedBox(width: Responsive.w(10)),
        Expanded(
          child: _benefitItem(
            Icons.recycling_outlined,
            '30-Day Effortless\nReturns',
          ),
        ),
      ],
    );
  }

  Widget _benefitItem(IconData icon, String title) {
    return Container(
      padding: EdgeInsets.all(Responsive.w(12)),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(Responsive.r(6)),
      ),
      child: Row(
        children: [
          Icon(icon, size: Responsive.sp(20), color: Colors.grey.shade700),
          SizedBox(width: Responsive.w(8)),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: Responsive.sp(11),
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(Responsive.w(24)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: Responsive.sp(64),
              color: Colors.grey,
            ),
            SizedBox(height: Responsive.h(16)),
            Text(
              'Your cart is empty',
              style: TextStyle(
                fontSize: Responsive.sp(22),
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: Responsive.h(8)),
            Text(
              'Add some products to see them here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: Responsive.sp(14),
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
