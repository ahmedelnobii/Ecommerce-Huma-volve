import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/errors/failer.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/product.dart';

abstract class ProductRepo {
  Future<Either<Failer, List<Product>>> getProducts({
    int? categoryId,
    required int offset,
  });
}
