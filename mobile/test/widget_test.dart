import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile/layout/presentation/cubit/layout_cubit.dart';
import 'package:mobile/layout/presentation/pages/layout_screen.dart';

void main() {
  testWidgets('LayoutScreen renders the bottom navigation', (tester) async {
    await tester.pumpWidget(
      BlocProvider(
        create: (_) => LayoutCubit(),
        child: const MaterialApp(
          home: LayoutScreen(child: SizedBox.shrink()),
        ),
      ),
    );

    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.text('SHOP'), findsOneWidget);
    expect(find.text('CART'), findsOneWidget);
  });
}
