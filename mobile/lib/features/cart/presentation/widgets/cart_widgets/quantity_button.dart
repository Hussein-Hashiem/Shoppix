import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/utils/responsive/responsive.dart';

class QuantityButton extends StatelessWidget {
  const QuantityButton({super.key, required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: Responsive.w(32),
        height: Responsive.h(36),
        child: Icon(icon, size: Responsive.sp(17)),
      ),
    );
  }
}