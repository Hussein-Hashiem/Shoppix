import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/utils/constants/colors.dart';
import 'package:mobile/core/utils/responsive/responsive.dart';
import 'package:mobile/features/cart/presentation/viewmodel/cart_cubit.dart';
import 'package:mobile/features/product/domain/entities/product_entity.dart';
import 'package:mobile/features/product/presentation/viewmodel/get_product_by_id_cubit/get_product_by_id_cubit.dart';
import 'package:mobile/features/product/presentation/viewmodel/get_product_by_id_cubit/get_product_by_id_states.dart';

class ProductDetailsScreen extends StatefulWidget {
  final int productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int quantity = 1;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<GetProductByIdCubit>().getProductById(widget.productId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text('Shoppix', style: Theme.of(context).textTheme.titleMedium),
        centerTitle: false,
      ),
      body: BlocBuilder<GetProductByIdCubit, GetProductByIdStates>(
        builder: (context, state) {
          if (state is LoadingGetProductByIdStates) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is FailGetProductByIdStates) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(Responsive.w(16)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    SizedBox(height: Responsive.h(16)),
                    ElevatedButton(
                      onPressed: () {
                        context.read<GetProductByIdCubit>().getProductById(
                          widget.productId,
                        );
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is SuccessGetProductByIdStates) {
            return _buildProductDetails(state.products);
          }

          return const Center(child: Text('Preparing product...'));
        },
      ),
    );
  }

  Widget _buildProductDetails(ProductEntity product) {
    final maxQuantity = product.stockQuantity;
    final total = product.price * quantity;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(Responsive.w(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'COLLECTION 10 / 2026',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  'PRODUCT DETAILS',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: Responsive.h(16)),

                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: Responsive.h(340),
                      color: AppColors.background,
                      alignment: Alignment.center,
                      child: Image.network(
                        product.imageUrl,
                        width: double.infinity,
                        height: Responsive.h(340),
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;

                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              size: 48,
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      top: Responsive.h(8),
                      right: Responsive.w(8),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Responsive.w(10),
                          vertical: Responsive.h(6),
                        ),
                        color: AppColors.background,
                        child: Text(
                          product.stockQuantity > 0 ? 'IN STOCK' : 'SOLD OUT',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: Responsive.h(20)),

                Text(
                  product.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),

                SizedBox(height: Responsive.h(8)),

                Text(
                  '\$ ${product.price.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),

                SizedBox(height: Responsive.h(16)),

                Text(
                  product.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),

                SizedBox(height: Responsive.h(24)),

                // Quantity selector
                Text(
                  'QUANTITY',
                  style: Theme.of(context).textTheme.titleMedium,
                ),

                SizedBox(height: Responsive.h(8)),

                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Available: $maxQuantity',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    IconButton(
                      onPressed: quantity > 1
                          ? () {
                              setState(() => quantity--);
                            }
                          : null,
                      icon: const Icon(Icons.remove),
                    ),
                    Text(
                      '$quantity',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    IconButton(
                      onPressed: quantity < maxQuantity
                          ? () {
                              setState(() => quantity++);
                            }
                          : null,
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),

                SizedBox(height: Responsive.h(24)),

                Text(
                  'PRODUCT INFORMATION',
                  style: Theme.of(context).textTheme.titleLarge,
                ),

                SizedBox(height: Responsive.h(12)),

                _infoRow('Product ID', '${product.id}'),
                _infoRow('Available stock', '$maxQuantity'),
                _infoRow(
                  'Price per item',
                  '\$ ${product.price.toStringAsFixed(2)}',
                ),
              ],
            ),
          ),
        ),

        // Bottom purchase bar
        SafeArea(
          top: false,
          child: Container(
            padding: EdgeInsets.all(Responsive.w(16)),
            decoration: BoxDecoration(
              color: AppColors.background,
              border: Border(
                top: BorderSide(
                  color: AppColors.border,
                  width: Responsive.w(1),
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TOTAL',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      SizedBox(height: Responsive.h(4)),
                      Text(
                        '\$ ${total.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: Responsive.h(48),
                  child: ElevatedButton(
                    onPressed: maxQuantity > 0
                        ? () {
                            for (int i = 0; i < quantity; i++) {
                              context.read<CartCubit>().addProductToCart(
                                product.id,
                              );
                            }

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Product added to cart'),
                              ),
                            );
                          }
                        : null,
                    child: Text(
                      maxQuantity > 0 ? 'ADD TO CART' : 'OUT OF STOCK',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Responsive.h(8)),
      child: Row(
        children: [
          Expanded(
            child: Text(title, style: Theme.of(context).textTheme.bodyMedium),
          ),
          Text(value, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
