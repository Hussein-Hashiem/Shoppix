import 'package:flutter/material.dart';
import 'package:mobile/core/utils/responsive/responsive.dart';
import 'package:mobile/features/cart/domain/entities/cart_entity.dart';
import 'package:mobile/features/cart/presentation/widgets/cart_widgets/benefits.dart';
import 'package:mobile/features/cart/presentation/widgets/cart_widgets/cart_item.dart';
import 'package:mobile/features/cart/presentation/widgets/cart_widgets/shipping_banner.dart';
import 'package:mobile/features/cart/presentation/widgets/cart_widgets/summary.dart';

class CartContent extends StatelessWidget {
  const CartContent({super.key, required this.cart});
  final CartEntity cart;
  @override
  Widget build(BuildContext context) {
    return  ListView(
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
        ShippingBanner(),
        SizedBox(height: Responsive.h(20)),
        ...cart.items.map((item) => CartItem(item: item)),
        SizedBox(height: Responsive.h(20)),
        Summary(cart: cart,),
        SizedBox(height: Responsive.h(20)),
        Benefits(),
        SizedBox(height: Responsive.h(20)),
        SizedBox(
          height: Responsive.h(54),
          child: ElevatedButton(
            onPressed: () {
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
}