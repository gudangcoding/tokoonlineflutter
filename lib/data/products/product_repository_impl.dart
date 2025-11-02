import '../../core/network/api_client.dart';
import '../../domain/products/product_entity.dart';
import '../../domain/products/product_repository.dart';
import 'product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ApiClient apiClient;
  late final ProductRemoteDataSource _remote = ProductRemoteDataSource(apiClient.dio);

  ProductRepositoryImpl(this.apiClient);

  @override
  Future<List<ProductEntity>> getProducts({String? query, int page = 1, int limit = 8}) async {
    final result = await _remote.fetchProducts(query: query, page: page, limit: limit);
    return result.map((e) => ProductEntity(
          id: e['id'].toString(),
          name: e['name'] ?? e['title'] ?? 'Produk',
          description: e['description'] ?? '',
          price: (e['price'] is num) ? (e['price'] as num).toDouble() : double.tryParse(e['price']?.toString() ?? '0') ?? 0,
          imageUrl: e['image'] ?? e['image_url'] ?? '',
        )).toList();
  }

  @override
  Future<ProductEntity> getProductDetail(String id) async {
    final e = await _remote.fetchProductDetail(id);
    return ProductEntity(
      id: e['id'].toString(),
      name: e['name'] ?? e['title'] ?? 'Produk',
      description: e['description'] ?? '',
      price: (e['price'] is num) ? (e['price'] as num).toDouble() : double.tryParse(e['price']?.toString() ?? '0') ?? 0,
      imageUrl: e['image'] ?? e['image_url'] ?? '',
    );
  }
}