import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile/core/utils/constants/colors.dart';
import 'package:mobile/core/utils/constants/icon_assets.dart';
import 'package:mobile/core/utils/responsive/responsive.dart';
import 'package:mobile/features/product/domain/entities/product_entity.dart';

class ProductItem extends StatelessWidget {
  final ProductEntity product;
  const new({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Responsive.w(173),
      height: Responsive.h(288.25),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(width: 0, color: AppColors.background),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.network(
                product.imageUrl,
                width: Responsive.w(173),
                height: Responsive.h(216.25),
                fit: BoxFit.fill,
              ),
              Positioned(
                bottom: Responsive.h(8),
                right: Responsive.w(8),
                child: Container(
                  width: Responsive.w(36),
                  height: Responsive.h(36),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.background,
                  ),
                  child: SvgPicture.asset(
                    IconAssets.plus,
                    width: Responsive.w(10),
                    height: Responsive.h(10),
                    fit: BoxFit.none,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: Responsive.h(16)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              product.name,
              style: Theme.of(context).textTheme.bodyLarge!
                  .copyWith(color: AppColors.title),
            ),
          ),
          SizedBox(height: Responsive.h(4)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              "\$ ${product.price}",
              style: Theme.of(context).textTheme.titleLarge!
                  .copyWith(fontSize: Responsive.sp(18)),
            ),
          ),
        ],
      ),
    );
  }
}
