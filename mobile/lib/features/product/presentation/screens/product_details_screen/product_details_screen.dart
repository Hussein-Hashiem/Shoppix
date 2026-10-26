import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/cart/presentation/viewmodel/cart_cubit.dart';
import 'package:mobile/features/product/domain/entities/product_entity.dart';
import 'package:mobile/features/product/presentation/viewmodel/get_product_by_id_cubit/get_product_by_id_cubit.dart';
import 'package:mobile/features/product/presentation/viewmodel/get_product_by_id_cubit/get_product_by_id_states.dart';

class ProductDetailsScreen extends StatefulWidget {
  final int productId;
  final void Function(ProductEntity product, int quantity)? onAddToCart;

  const ProductDetailsScreen({
    super.key,
    required this.productId,
    this.onAddToCart,
  });

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
      backgroundColor: const Color(0xFFF8F8F8),
      body: BlocBuilder<GetProductByIdCubit, GetProductByIdStates>(
        builder: (context, state) {
          if (state is LoadingGetProductByIdStates) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.black),
            );
          }

          if (state is FailGetProductByIdStates) {
            return _buildError(state.message);
          }

          if (state is SuccessGetProductByIdStates) {
            return _buildProductDetails(state.products);
          }

          return const Center(child: Text('Loading product...'));
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
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHeader()),
              SliverToBoxAdapter(child: _buildProductImage(product)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProductTitle(product),
                      const SizedBox(height: 12),
                      _buildPrice(product),
                      const SizedBox(height: 18),
                      Text(
                        product.description,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.6,
                          color: Color(0xFF666666),
                        ),
                      ),
                      const SizedBox(height: 26),
                      _buildQuantitySelector(maxQuantity),
                      const SizedBox(height: 28),
                      _buildProductInformation(product),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        _buildBottomBar(total, product),
      ],
    );
  }

  Widget _buildHeader() {
    return SafeArea(
      bottom: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).maybePop(),
              icon: const Icon(Icons.arrow_back),
            ),
            const CircleAvatar(
              radius: 15,
              backgroundColor: Color(0xFFEAEAEA),
              child: Text(
                'M',
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'SHOPPIX  PRODUCT DETAIL',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ),
            const CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFFE5E5E5),
              child: Icon(Icons.person_outline, size: 20, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(ProductEntity product) {
    return Container(
      color: const Color(0xFFF0F0F0),
      width: double.infinity,
      height: 340,
      padding: const EdgeInsets.all(12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: Image.network(
          product.imageUrl,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Icon(
                Icons.image_not_supported_outlined,
                size: 60,
                color: Colors.grey,
              ),
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;

            return const Center(
              child: CircularProgressIndicator(color: Colors.black),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProductTitle(ProductEntity product) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            product.name,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w400,
              color: Color(0xFF171717),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          margin: const EdgeInsets.only(top: 5),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          color: product.stockQuantity > 0
              ? const Color(0xFFEDEDE9)
              : const Color(0xFFFFE6E6),
          child: Text(
            product.stockQuantity > 0 ? 'IN STOCK' : 'SOLD OUT',
            style: const TextStyle(
              fontSize: 9,
              letterSpacing: 1,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrice(ProductEntity product) {
    return Row(
      children: [
        Text(
          '\$${product.price.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 8),
        const Text(
          'Taxes included',
          style: TextStyle(fontSize: 11, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildQuantitySelector(int maxQuantity) {
    final canDecrease = quantity > 1;
    final canIncrease = quantity < maxQuantity;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'QUANTITY',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Text(
                'Single item limit: $maxQuantity',
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ),
            Container(
              color: const Color(0xFFF0F0F0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: canDecrease
                        ? () {
                            setState(() => quantity--);
                          }
                        : null,
                    icon: const Icon(Icons.remove, size: 17),
                    visualDensity: VisualDensity.compact,
                  ),
                  SizedBox(
                    width: 24,
                    child: Text(
                      '$quantity',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                  IconButton(
                    onPressed: canIncrease
                        ? () {
                            setState(() => quantity++);
                          }
                        : null,
                    icon: const Icon(Icons.add, size: 17),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProductInformation(ProductEntity product) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: const Color(0xFFF0F0F0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Expanded(
                child: Text(
                  'PRODUCT DETAILS',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Icon(Icons.keyboard_arrow_down, size: 20),
            ],
          ),
          const SizedBox(height: 16),
          _infoRow('Product ID', '${product.id}'),
          const SizedBox(height: 10),
          _infoRow('Available stock', '${product.stockQuantity}'),
          const SizedBox(height: 10),
          _infoRow('Price per item', '\$${product.price.toStringAsFixed(2)}'),
        ],
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 12, color: Color(0xFF777777)),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(double total, ProductEntity product) {
    final isAvailable = product.stockQuantity > 0;

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'TOTAL',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '\$${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: isAvailable
                      ? () {
                          context.read<CartCubit>().addProductToCart(
                            product.id,
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade400,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    isAvailable ? 'ADD TO CART' : 'OUT OF STOCK',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
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
}
