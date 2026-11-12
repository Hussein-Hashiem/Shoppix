import 'package:flutter/material.dart';
import 'package:mobile/core/utils/responsive/responsive.dart';

class SummaryRow extends StatelessWidget {
  const SummaryRow({super.key, required this.title, required this.value});
  final String title;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: Responsive.sp(13),
              color: Colors.grey.shade700,
            ),
          ),
        ),
        SizedBox(width: Responsive.w(8)),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: Responsive.sp(13),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}