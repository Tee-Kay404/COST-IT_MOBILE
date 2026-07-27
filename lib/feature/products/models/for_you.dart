import 'package:cost_it_mobile/feature/products/models/products.dart';

class ForYouPage {
  final List<Product> data;
  final String? nextCursor; // null means no more pages

  const ForYouPage({required this.data, this.nextCursor});

  bool get hasMore => nextCursor != null;

  factory ForYouPage.fromJson(Map<String, dynamic> json) {
    return ForYouPage(
      data: (json['data'] as List)
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextCursor: json['nextCursor'] as String?,
    );
  }
}