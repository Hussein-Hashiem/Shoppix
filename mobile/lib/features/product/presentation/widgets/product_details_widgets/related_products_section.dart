import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/routing/routes.dart';
import 'package:mobile/core/utils/constants/colors.dart';
import 'package:mobile/core/utils/responsive/responsive.dart';
import 'package:mobile/features/product/domain/entities/product_entity.dart';
import 'package:mobile/features/product/presentation/viewmodel/get_related_products_cubit/get_related_products_cubit.dart';
import 'package:mobile/features/product/presentation/viewmodel/get_related_products_cubit/get_related_products_states.dart';

class RelatedProductsSection extends StatelessWidget {
  final int productId;

  const RelatedProductsSection({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetRelatedProductsCubit, GetRelatedProductsStates>(
      builder: (context, state) {
        if (state is InitialGetRelatedProductsState) {
          return const SizedBox.shrink();
        }
        if (state is SuccessGetRelatedProductsState && state.products.isEmpty) {
          return const SizedBox.shrink();
        }

        final products = state is SuccessGetRelatedProductsState
            ? state.products
            : const <ProductEntity>[];

        return Padding(
          padding: EdgeInsets.only(top: Responsive.h(24)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'YOU MIGHT ALSO LIKE',
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(fontSize: Responsive.sp(18)),
                    ),
                  ),
                  if (state is SuccessGetRelatedProductsState)
                    Text(
                      '${products.length} PIECES',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                ],
              ),
              SizedBox(height: Responsive.h(12)),
              if (state is LoadingGetRelatedProductsState)
                SizedBox(
                  height: Responsive.h(220),
                  child: const Center(child: CircularProgressIndicator()),
                )
              else if (state is FailGetRelatedProductsState)
                SizedBox(
                  height: Responsive.h(120),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          state.message,
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                        TextButton(
                          onPressed: () => context
                              .read<GetRelatedProductsCubit>()
                              .getRelatedProducts(productId),
                          child: const Text('TRY AGAIN'),
                        ),
                      ],
                    ),
                  ),
                )
              else
                SizedBox(
                  height: Responsive.h(280),
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: products.length,
                    separatorBuilder: (context, index) =>
                        SizedBox(width: Responsive.w(10)),
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return _RelatedProductCard(product: product);
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _RelatedProductCard extends StatelessWidget {
  final ProductEntity product;

  const _RelatedProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final cardWidth = Responsive.w(173);

    return SizedBox(
      width: cardWidth,
      child: InkWell(
        onTap: () => context.pushNamed(
          Routes.productDetails,
          pathParameters: {'id': product.id.toString()},
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: cardWidth,
              height: cardWidth,
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Icon(Icons.image_not_supported_outlined, size: 40),
                ),
              ),
            ),
            SizedBox(height: Responsive.h(10)),
            Text(
              product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyLarge
                  ?.copyWith(color: AppColors.title),
            ),
            SizedBox(height: Responsive.h(2)),
            Text(
              'RELATED PRODUCT',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: Responsive.sp(20),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
