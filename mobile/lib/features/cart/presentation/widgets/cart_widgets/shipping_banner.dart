import 'package:flutter/material.dart';
import 'package:mobile/core/utils/responsive/responsive.dart';

class ShippingBanner extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: EdgeInsets.all(Responsive.w(12)),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(Responsive.r(6)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.local_shipping_outlined, size: Responsive.sp(20)),
              SizedBox(width: Responsive.w(8)),
              Expanded(
                child: Text(
                  'COMPLIMENTARY SHIPPING UNLOCKED',
                  style: TextStyle(
                    fontSize: Responsive.sp(11),
                    fontWeight: FontWeight.w600,
                    letterSpacing: Responsive.w(0.4),
                  ),
                ),
              ),
              Text('100%', style: TextStyle(fontSize: Responsive.sp(11))),
            ],
          ),
          SizedBox(height: Responsive.h(8)),
          Container(
            height: Responsive.h(5),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(Responsive.r(10)),
            ),
          ),
        ],
      ),
    );
  }
}