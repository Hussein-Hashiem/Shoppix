import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/usecases/usecase.dart';
import 'package:mobile/core/utils/constants/colors.dart';
import 'package:mobile/core/utils/constants/style.dart';
import 'package:mobile/core/utils/theme/app_theme.dart';
import 'package:mobile/features/order/domain/entities/order_entity.dart';
import 'package:mobile/features/order/domain/usecases/get_orders_usecase.dart';
import 'package:mobile/features/order/presentation/viewmodel/orders_cubit.dart';
import 'package:mobile/features/order_history/presentation/screens/orders_screen.dart';
import 'package:mocktail/mocktail.dart';

class GetOrdersUsecaseMock extends Mock implements GetOrdersUsecase {}

void main() {
  testWidgets('order details dialog follows the app theme', (tester) async {
    final usecase = GetOrdersUsecaseMock();
    when(() => usecase(const NoParams())).thenAnswer(
      (_) async => right([
        OrderEntity(
          id: 17,
          orderDate: DateTime(2026, 11, 14),
          totalPrice: 96,
          status: 'Confirmed',
        ),
      ]),
    );
    final cubit = OrdersCubit(getOrdersUsecase: usecase);
    addTearDown(cubit.close);
    await cubit.getOrders();

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: BlocProvider.value(value: cubit, child: const OrdersScreen()),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('VIEW DETAILS'));
    await tester.pumpAndSettle();

    final dialog = tester.widget<AlertDialog>(find.byType(AlertDialog));
    expect(dialog.backgroundColor, AppColors.background);
    expect(dialog.titleTextStyle, AppTextStyles.titleLarge);
    expect(dialog.contentTextStyle, AppTextStyles.bodyLarge);
    expect(dialog.surfaceTintColor, Colors.transparent);
    expect(AppTheme.lightTheme.progressIndicatorTheme.color, AppColors.button);
  });
}
