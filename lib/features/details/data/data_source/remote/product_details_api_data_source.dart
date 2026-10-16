import 'package:dio/dio.dart';
import 'package:ecommerce_app_huma_volve/core/consts/api_consts.dart';
import 'package:ecommerce_app_huma_volve/core/errors/remote_exption.dart';
import 'package:ecommerce_app_huma_volve/features/details/data/data_source/remote/product_details_remote_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/models/product_model.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: ProductDetailsRemoteDataSource)
class ProductDetailsApiDataSource implements ProductDetailsRemoteDataSource {
  final Dio _dio;

  ProductDetailsApiDataSource(this._dio);

  @override
  Future<ProductModel> getProductById(int id) async {
    try {
      final response = await _dio.get(
        '${ApiConsts.productsEndPoint}/$id',
      );
      final data = response.data;

      if (data is! Map || data.keys.any((key) => key is! String)) {
        throw RemoteExptions('Invalid product details response');
      }

      return ProductModel.fromJson(Map<String, dynamic>.from(data));
    } catch (error) {
      throw RemoteExptions(error.toString());
    }
  }
}
