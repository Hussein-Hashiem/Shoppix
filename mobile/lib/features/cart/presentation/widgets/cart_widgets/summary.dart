import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/utils/responsive/responsive.dart';
import 'package:mobile/features/cart/domain/entities/cart_entity.dart';
import 'package:mobile/features/cart/presentation/widgets/cart_widgets/summary_row.dart';

class Summary extends StatelessWidget {
  const Summary({super.key, required this.cart});
  final CartEntity cart;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Responsive.w(16)),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(Responsive.r(6)),
      ),
      child: Column(
        children: [
          SummaryRow(
            title: 'Subtotal',
            value: '\$${cart.subtotal.toStringAsFixed(2)}',
          ),
          SizedBox(height: Responsive.h(16)),
          SummaryRow(title: 'Estimated Shipping', value: 'COMPLIMENTARY'),
          SizedBox(height: Responsive.h(16)),
          SummaryRow(
            title: 'Estimated Sales Tax',
            value: '\$${cart.salesTax.toStringAsFixed(2)}',
          ),
          SizedBox(height: Responsive.h(16)),
          const Divider(color: Color(0xFFDDDDDD)),
          SizedBox(height: Responsive.h(8)),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Total',
                  style: TextStyle(
                    fontSize: Responsive.sp(20),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                '\$${cart.total.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: Responsive.sp(25),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          SizedBox(height: Responsive.h(6)),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Includes applicable taxes',
              style: TextStyle(
                fontSize: Responsive.sp(11),
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
