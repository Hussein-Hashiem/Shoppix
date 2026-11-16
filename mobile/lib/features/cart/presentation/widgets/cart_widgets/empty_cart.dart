import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/utils/responsive/responsive.dart';

class EmptyCart extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(Responsive.w(24)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: Responsive.sp(64),
              color: Colors.grey,
            ),
            SizedBox(height: Responsive.h(16)),
            Text(
              'Your cart is empty',
              style: TextStyle(
                fontSize: Responsive.sp(22),
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: Responsive.h(8)),
            Text(
              'Add some products to see them here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: Responsive.sp(14),
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}