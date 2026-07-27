// import 'package:cost_it_mobile/feature/products/providers/prod_provider.dart';
// import 'package:cost_it_mobile/feature/products/widgets/global_products_card.dart';
// import 'package:cost_it_mobile/feature/products/widgets/product_shimmer.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class PopularServicesSection extends ConsumerWidget {
//   const PopularServicesSection({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final servicesAsync = ref.watch(popularServicesProvider);

//     return servicesAsync.when(
//       loading: () => const ProductCardShimmer(),
//       error: (e, _) => const SizedBox.shrink(),
//       data: (services) {
//         if (services.isEmpty) return const SizedBox.shrink();
//         return Padding(
//           padding: EdgeInsets.symmetric(horizontal: 15.w),
//           child: GridView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(), // parent scrolls
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               crossAxisSpacing: 12.w,
//               mainAxisSpacing: 12.h,
//               childAspectRatio: 0.78,
//             ),
//             itemCount: services.length,
//             itemBuilder: (_, index) {
//               final service = services[index];
//               return ProductCard(
//                 product: service,
//                 onTap: () {},
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
// }