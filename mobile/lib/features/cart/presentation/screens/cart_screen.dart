import 'package:flutter/material.dart';
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
      appBar: AppBar(
        title: Text(
          "Shoppix / Cart",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
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
                      return EmptyCart();
                    }

                    return CartContent(cart: cart);
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
}
