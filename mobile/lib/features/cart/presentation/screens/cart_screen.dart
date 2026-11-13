import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mobile/core/utils/responsive/responsive.dart';
import 'package:mobile/features/cart/presentation/viewmodel/cart_cubit.dart';
import 'package:mobile/features/cart/presentation/viewmodel/cart_state.dart';
import 'package:mobile/features/cart/presentation/widgets/cart_widgets/cart_content.dart';
import 'package:mobile/features/cart/presentation/widgets/cart_widgets/empty_cart.dart';

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
                    if (state.cart.items.isEmpty) {
                      return EmptyCart();
                    }

                    return CartContent(cart: state.cart);
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
}
