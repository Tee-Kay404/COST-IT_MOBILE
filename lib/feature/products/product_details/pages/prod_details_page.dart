import 'package:cost_it_mobile/feature/products/models/products.dart';
import 'package:cost_it_mobile/feature/products/product_details/views/prod_details_view.dart';
import 'package:flutter/material.dart';

class ProdDetailsPage extends StatelessWidget {
  final Product product;
  const ProdDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return ProdDetailsView(product: product);
  }
}
