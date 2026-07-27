import 'package:cost_it_mobile/app/network/client.dart';
import 'package:cost_it_mobile/app/network/dio_client.dart';
import 'package:cost_it_mobile/feature/products/models/category.dart';
import 'package:cost_it_mobile/feature/products/models/for_you.dart';
import 'package:cost_it_mobile/feature/products/models/products.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class IProductService {
  Future<List<ProductCategory>> getCategories();
  Future<List<Product>> getSpecialOffers();
  Future<List<Product>> getTrendingProducts({
    String? categoryId,
    int page = 1,
    int limit = 20,
  });
  Future<Product> getProductById(String productId);
  Future<List<Product>> searchProducts({
    required String query,
    String? categoryId,
    double? maxPrice,
    double? minPrice,
    PricingType? pricingType,
    int page = 1,
    int limit = 20,
  });
  Future<bool> saveProduct(String productId);
  Future<bool> removeSavedProduct(String productId);
  Future<List<Product>> getSavedProducts();
  Future<List<Product>> getPopularServices();
  Future<ForYouPage> getForYou({String? afterId, int limit = 10});

  // Vendor actions
  Future<Product> postProduct(Map<String, dynamic> payload);
  Future<Product> editProduct(String productId, Map<String, dynamic> payload);
  Future<bool> deleteProduct(String productId);
  Future<List<Product>> getMyListings({int page = 1, int limit = 20});
}

class ProductService implements IProductService {
  final NetworkClient client;
  ProductService({required this.client});

 @override
Future<List<ProductCategory>> getCategories() async {
  final response = await client.get('categories');
  final list = response.data as List;
  return list
      .map((e) => ProductCategory.fromJson(e as Map<String, dynamic>))
      .toList();
}

  @override
  Future<List<Product>> getSpecialOffers() async {
    final response = await client.get('products/special-offers');
    
    final list = response.data as List;
    return list
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<Product>> getTrendingProducts({
    String? categoryId,
    int page = 1,
    int limit = 20,
  }) async {
    final response = await client.get(
      'products/trending',
      queryParameters: {
        'page': '$page',
        'limit': '$limit',
        if (categoryId != null) 'category_id': categoryId,
      },
    );
    final list = response.data as List;
    return list
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Product> getProductById(String productId) async {
    final response = await client.get('products/$productId');
    return response
        .transform<Product>(
          (data) => Product.fromJson(data as Map<String, dynamic>),
        )
        .data!;
  }

  @override
  Future<List<Product>> searchProducts({
    required String query,
    String? categoryId,
    double? maxPrice,
    double? minPrice,
    PricingType? pricingType,
    int page = 1,
    int limit = 20,
  }) async {
    final response = await client.get(
      'products/search',
      queryParameters: {
        'query': query,  // backend ProductQueryDto field is 'query', not 'q'
        'page': '$page',
        'limit': '$limit',
        if (categoryId != null) 'categoryId': categoryId,
        if (maxPrice != null) 'maxPrice': '$maxPrice',
        if (minPrice != null) 'minPrice': '$minPrice',
        if (pricingType != null) 'pricingType': pricingType.name,
      },
    );
    final list = response.data as List;
    return list
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<Product>> getPopularServices() async {
    final response = await client.get('products/popular-services');
    final list = response.data as List;
    return list
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ForYouPage> getForYou({String? afterId, int limit = 10}) async {
    final response = await client.get(
      'products/for-you',
      queryParameters: {
        'limit': '$limit',
        if (afterId != null) 'after': afterId,
      },
    );
    return ForYouPage.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<bool> saveProduct(String productId) async {
    final response = await client.post('products/$productId/save', data: {});
    return response.success;
  }

  @override
  Future<bool> removeSavedProduct(String productId) async {
    final response = await client.delete('products/$productId/save');
    return response.success;
  }

  @override
  Future<List<Product>> getSavedProducts() async {
    final response = await client.get('products/saved');
    final list = response.data as List;
    return list
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // Vendor

  @override
  Future<Product> postProduct(Map<String, dynamic> payload) async {
    final response = await client.post('products', data: payload);
    return response
        .transform<Product>(
          (data) => Product.fromJson(data as Map<String, dynamic>),
        )
        .data!;
  }

  @override
  Future<Product> editProduct(
    String productId,
    Map<String, dynamic> payload,
  ) async {
    final response = await client.patch('products/$productId', data: payload);
    return response
        .transform<Product>(
          (data) => Product.fromJson(data as Map<String, dynamic>),
        )
        .data!;
  }

  @override
  Future<bool> deleteProduct(String productId) async {
    final response = await client.delete('products/$productId');
    return response.success;
  }

  @override
  Future<List<Product>> getMyListings({int page = 1, int limit = 20}) async {
    final response = await client.get(
      'products/my-listings',
      queryParameters: {'page': '$page', 'limit': '$limit'},
    );
    final list = response.data as List;
    return list
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

final productServiceProvider = Provider<ProductService>((ref) {
  return ProductService(client: ref.watch(dioClientProvider));
});
