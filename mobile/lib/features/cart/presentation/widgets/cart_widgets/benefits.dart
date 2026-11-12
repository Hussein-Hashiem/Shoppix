import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile/core/utils/responsive/responsive.dart';

class Benefits extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _benefitItem(
            Icons.verified_user_outlined,
            'Carbon Neutral\nFulfillment',
          ),
        ),
        SizedBox(width: Responsive.w(10)),
        Expanded(
          child: _benefitItem(
            Icons.recycling_outlined,
            '30-Day Effortless\nReturns',
          ),
        ),
      ],
    );
  }
}
Widget _benefitItem(IconData icon, String title) {
  return Container(
    padding: EdgeInsets.all(Responsive.w(12)),
    decoration: BoxDecoration(
      color: const Color(0xFFF2F2F2),
      borderRadius: BorderRadius.circular(Responsive.r(6)),
    ),
    child: Row(
      children: [
        Icon(icon, size: Responsive.sp(20), color: Colors.grey.shade700),
        SizedBox(width: Responsive.w(8)),
        Expanded(
          child: Text(
            title,
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
