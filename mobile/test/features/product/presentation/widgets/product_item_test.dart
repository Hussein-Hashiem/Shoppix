import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile/features/product/domain/entities/product_entity.dart';
import 'package:mobile/features/product/presentation/widgets/browse_products_widgets/product_item.dart';

void main() {
  testWidgets('product card handles long names without overflowing', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 159.7,
              height: 239.5,
              child: const ProductItem(
                product: ProductEntity(
                  id: 1,
                  description: 'A coffee grinder',
                  name: 'Precision Artisan Coffee Grinder With Extra Long Name',
                  price: 24,
                  stockQuantity: 10,
                  imageUrl: 'https://example.com/product.jpg',
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
