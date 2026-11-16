import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile/features/product/domain/entities/product_entity.dart';
import 'package:mobile/features/product/domain/usecases/get_related_products.dart';
import 'package:mobile/features/product/presentation/viewmodel/get_related_products_cubit/get_related_products_cubit.dart';
import 'package:mobile/features/product/presentation/widgets/product_details_widgets/related_products_section.dart';
import 'package:mocktail/mocktail.dart';

class GetRelatedProductsUsecaseMock extends Mock
    implements GetRelatedProductsUsecase {}

void main() {
  testWidgets('shows related products in the recommendation section', (
    tester,
  ) async {
    final usecase = GetRelatedProductsUsecaseMock();
    when(() => usecase(RelatedProductsParams(productId: 4, limit: 2)))
        .thenAnswer(
          (_) async => right([
            const ProductEntity(
              id: 5,
              description: 'A related product',
              name: 'Electric Kettle',
              price: 65,
              stockQuantity: 4,
              imageUrl: 'https://example.com/kettle.jpg',
            ),
            const ProductEntity(
              id: 6,
              description: 'Another related product',
              name: 'Coffee Grinder',
              price: 80,
              stockQuantity: 3,
              imageUrl: 'https://example.com/grinder.jpg',
            ),
          ]),
        );
    final cubit = GetRelatedProductsCubit(usecase);
    addTearDown(cubit.close);
    await cubit.getRelatedProducts(4);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider.value(
            value: cubit,
            child: const SingleChildScrollView(
              child: RelatedProductsSection(productId: 4),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('YOU MIGHT ALSO LIKE'), findsOneWidget);
    expect(find.text('2 PIECES'), findsOneWidget);
    expect(find.text('Electric Kettle'), findsOneWidget);
    expect(find.text('Coffee Grinder'), findsOneWidget);
    expect(find.text('\$65.00'), findsOneWidget);
  });
}
