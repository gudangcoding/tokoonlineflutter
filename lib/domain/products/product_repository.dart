import 'product_entity.dart';

abstract class ProductRepository {
  Future<List<ProductEntity>> getProducts({String? query, int page = 1, int limit = 8});
  Future<ProductEntity> getProductDetail(String id);
}