import 'package:ecommerce_app_huma_volve/features/details/domain/use_cases/get_product_details.dart';
import 'package:ecommerce_app_huma_volve/features/details/presentation/cubit/product_details_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  final GetProductDetails _getProductDetails;

  int? _productId;

  ProductDetailsCubit(this._getProductDetails) : super(ProductDetailsInitial());

  Future<void> loadProduct(int id) async {
    _productId = id;
    emit(ProductDetailsLoading());

    final result = await _getProductDetails(id);

    result.fold(
      (failure) => emit(ProductDetailsError(failure.msg)),
      (product) => emit(ProductDetailsLoaded(product)),
    );
  }

  Future<void> retry() async {
    if (_productId != null) {
      await loadProduct(_productId!);
    }
  }
}
