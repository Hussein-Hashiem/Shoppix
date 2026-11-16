import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/cart/data/data_sources/cart_local_data_source.dart';
import 'package:mobile/features/cart/data/repo/cart_repo_impl.dart';
import 'package:mobile/features/product/domain/repo/product_repo.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductRepoMock extends Mock implements ProductRepo {}

void main() {
  test(
    'persists the selected quantity and adds it to an existing line',
    () async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      final dataSource = CartLocalDataSource(pref: preferences);
      final repository = CartRepoImpl(
        cartLocalDataSource: dataSource,
        productRepo: ProductRepoMock(),
      );

      await repository.addProductToCart(42, quantity: 3);

      expect((await dataSource.getCartProducts()).single.productQuantity, 3);

      await repository.addProductToCart(42, quantity: 2);

      expect((await dataSource.getCartProducts()).single.productQuantity, 5);
    },
  );
}
