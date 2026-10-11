import 'package:dio/dio.dart';
import 'package:ecommerce_app_huma_volve/core/api_client/api_client.dart';
import 'package:injectable/injectable.dart';

@module
abstract class RegisterModuls {
  @singleton
  Dio get dio => ApiClient.creatDio;
}
