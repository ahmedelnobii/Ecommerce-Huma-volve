import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/errors/app_exptions.dart';
import 'package:ecommerce_app_huma_volve/core/errors/failer.dart';
import 'package:ecommerce_app_huma_volve/features/details/data/data_source/remote/product_details_remote_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/details/domain/repo/product_details_repo.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/product.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: ProductDetailsRepo)
class ProductDetailsRepoImpl implements ProductDetailsRepo {
  final ProductDetailsRemoteDataSource _remoteDataSource;

  ProductDetailsRepoImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, Product>> getProductById(int id) async {
    try {
      final product = await _remoteDataSource.getProductById(id);
      return Right(product);
    } on AppExceptions catch (e) {
      return Left(ErrorHandler.handle(e.message));
    }
  }
}
