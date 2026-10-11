import 'package:dio/dio.dart';
import 'package:ecommerce_app_huma_volve/core/consts/api_consts.dart';

class ApiClient {
  static Dio get creatDio => Dio(
    BaseOptions(baseUrl: ApiConsts.baseURL, receiveDataWhenStatusError: true),
  );
}
