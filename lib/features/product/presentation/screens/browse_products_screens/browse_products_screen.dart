import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/routing/routes.dart';
import 'package:mobile/core/utils/constants/colors.dart';
import 'package:mobile/core/utils/responsive/responsive.dart';
import 'package:mobile/features/product/presentation/viewmodel/get_all_products_cubit/get_all_products_cubit.dart';
import 'package:mobile/features/product/presentation/viewmodel/get_all_products_cubit/get_all_products_states.dart';
import 'package:mobile/features/product/presentation/widgets/browse_products_widgets/products_list.dart';

class BrowseProductsScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shoppix", style: Theme.of(context).textTheme.titleMedium),
        centerTitle: false,
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(
          horizontal: Responsive.w(16),
          vertical: Responsive.h(16),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "COLLECTION 10 / 2026",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text("CATALOG", style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: Responsive.h(16)),

              BlocConsumer<GetAllProductsCubit, GetAllProductsStates>(
                listener: (context, state) {
                  if (state is FailGetAllProductState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: AppColors.error,
                      ),
                    );
                    if (state.message ==
                        "Your session may have expired. Please sign in again.") {
                      context.pushReplacementNamed(Routes.login);
                    }
                  }
                },
                builder: (context, state) {
                  if (state is LoadingGetAllProductState) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (state is FailGetAllProductState) {
                    return Center(
                      child: Text(
                        state.message,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    );
                  }
                  return ProductsList(
                    products: (state as SuccessGetAllProductState).products,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
