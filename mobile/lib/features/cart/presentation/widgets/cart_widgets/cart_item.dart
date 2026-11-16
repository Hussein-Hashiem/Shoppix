import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/utils/responsive/responsive.dart';
import 'package:mobile/features/cart/domain/entities/cart_entity.dart';
import 'package:mobile/features/cart/presentation/viewmodel/cart_cubit.dart';
import 'package:mobile/features/cart/presentation/widgets/cart_widgets/quantity_button.dart';

class CartItem extends StatelessWidget {
  const CartItem({super.key, required this.item});
final CartItemEntity item;
  @override
  Widget build(BuildContext context) {
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
              errorBuilder: (_, _, _) {
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
                      QuantityButton(
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
                      QuantityButton(
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
}