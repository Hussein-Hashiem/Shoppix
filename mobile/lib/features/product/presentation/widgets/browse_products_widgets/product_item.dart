import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile/core/utils/constants/colors.dart';
import 'package:mobile/core/utils/constants/icon_assets.dart';
import 'package:mobile/core/utils/responsive/responsive.dart';
import 'package:mobile/features/cart/presentation/viewmodel/cart_cubit.dart';
import 'package:mobile/features/product/domain/entities/product_entity.dart';

class ProductItem extends StatelessWidget {
  final ProductEntity product;
  const new({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(width: 0, color: AppColors.background),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Center(
                    child: Icon(Icons.image_not_supported_outlined),
                  ),
                ),
                Positioned(
                  bottom: Responsive.h(8),
                  right: Responsive.w(8),
                  child: InkWell(
                    onTap: () {
                      context.read<CartCubit>().addProductToCart(product.id);
                    },
                    child: Container(
                      width: Responsive.w(36),
                      height: Responsive.h(36),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.background,
                      ),
                      child: SvgPicture.asset(
                        IconAssets.plus,
                        width: Responsive.w(10),
                        height: Responsive.h(10),
                        fit: BoxFit.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: Responsive.h(8)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyLarge!
                  .copyWith(color: AppColors.title),
            ),
          ),
          SizedBox(height: Responsive.h(4)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              "\$ ${product.price.toStringAsFixed(2)}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge!
                  .copyWith(fontSize: Responsive.sp(18)),
            ),
          ),
        ],
      ),
    );
  }
}
