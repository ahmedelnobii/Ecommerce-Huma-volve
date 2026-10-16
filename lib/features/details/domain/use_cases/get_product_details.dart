import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/errors/failer.dart';
import 'package:ecommerce_app_huma_volve/features/details/domain/repo/product_details_repo.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/product.dart';
import 'package:injectable/injectable.dart';

@singleton
class GetProductDetails {
  final ProductDetailsRepo _productDetailsRepo;

  GetProductDetails(this._productDetailsRepo);

  Future<Either<Failure, Product>> call(int id) {
    return _productDetailsRepo.getProductById(id);
  }
}
