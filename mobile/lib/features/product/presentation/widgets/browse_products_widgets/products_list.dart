import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/routing/routes.dart';
import 'package:mobile/core/utils/responsive/responsive.dart';
import 'package:mobile/features/product/domain/entities/product_entity.dart';
import 'package:mobile/features/product/presentation/widgets/browse_products_widgets/product_item.dart';

// ignore: must_be_immutable
class ProductsList extends StatefulWidget {
  List<ProductEntity> products;
  new({super.key, required this.products});

  @override
  State<ProductsList> createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 3,
        crossAxisSpacing: Responsive.w(12),
        mainAxisSpacing: Responsive.h(40),
      ),
      itemCount: widget.products.length,
      itemBuilder: (context, index) {
        final product = widget.products[index];
        return InkWell(
          onTap: () {
            context.pushNamed(
              Routes.productDetails,
              pathParameters: {'id': product.id.toString()},
            );
          },
          child: ProductItem(product: product));
      },
    );
  }
}
