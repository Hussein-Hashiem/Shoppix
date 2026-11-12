import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../cubit/layout_cubit.dart';
import '../cubit/layout_state.dart';
import '../widgets/custom_bottom_navigation_bar.dart';

class LayoutScreen extends StatelessWidget {
  final Widget child;

  const LayoutScreen({super.key, required this.child});

  void _onNavTap(BuildContext context, int index) {
    context.read<LayoutCubit>().changeBottomNavIndex(index);

    final routes = ['/', '/cart', '/orders', '/profile'];
    context.go(routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LayoutCubit, LayoutState>(
      builder: (context, state) {
        return Scaffold(
          body: child,
          bottomNavigationBar: CustomBottomNavigationBar(
            currentIndex: state.currentIndex,
            onTap: (index) => _onNavTap(context, index),
          ),
        );
      },
    );
  }
}
