import 'package:dio/dio.dart';

class ProductRemoteDataSource {
  final Dio dio;
  ProductRemoteDataSource(this.dio);

  Future<List<Map<String, dynamic>>> fetchProducts({String? query, int page = 1, int limit = 8}) async {
    final params = {
      'q': query,
      'page': page,
      'limit': limit,
    }..removeWhere((key, value) => value == null);
    final res = await dio.get('/products', queryParameters: params);
    final data = res.data as List<dynamic>;
    return data.cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> fetchProductDetail(String id) async {
    final res = await dio.get('/products/$id');
    return res.data as Map<String, dynamic>;
  }
}