import 'package:ecommerce_app_huma_volve/core/di/get_it.dart';
import 'package:ecommerce_app_huma_volve/features/details/presentation/cubit/product_details_cubit.dart';
import 'package:ecommerce_app_huma_volve/features/details/presentation/cubit/product_details_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../home/domain/entities/product.dart';
import '../../cart/presentation/cubit/cart_cubit.dart';
import '../../../core/theme.dart';
import '../../wishList/presentation/cubit/wishlist_cubit.dart';
import '../../wishList/presentation/cubit/wishlist_state.dart';
import '../widgets/color_selector.dart';
import '../widgets/size_selector.dart';
import '../../../core/widgets/primary_button.dart';

class ProductDetailsScreen extends StatelessWidget {
  final int productId;
  final String? coverImageUrl;
  final String? productName;
  final double? productPrice;

  const ProductDetailsScreen({
    super.key,
    required this.productId,
    this.coverImageUrl,
    this.productName,
    this.productPrice,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProductDetailsCubit>()..loadProduct(productId),
      child: _ProductDetailsView(
        productId: productId,
        coverImageUrl: coverImageUrl,
        productName: productName,
        productPrice: productPrice,
      ),
    );
  }
}

class _ProductDetailsView extends StatefulWidget {
  final int productId;
  final String? coverImageUrl;
  final String? productName;
  final double? productPrice;

  const _ProductDetailsView({
    required this.productId,
    this.coverImageUrl,
    this.productName,
    this.productPrice,
  });

  @override
  State<_ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<_ProductDetailsView> {
  late final PageController _imagePageController;
  Color _selectedColor = Colors.black;
  String _selectedSize = 'One Size';
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _imagePageController = PageController();
  }

  @override
  void dispose() {
    _imagePageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
      builder: (context, state) {
        if (state is ProductDetailsLoading || state is ProductDetailsInitial) {
          return _buildLoadingScaffold(context);
        }

        if (state is ProductDetailsError) {
          return _buildErrorScaffold(context, state.message);
        }

        if (state is ProductDetailsLoaded) {
          final product = state.product;

          // Sync defaults when product first arrives
          if (_selectedColor == Colors.black && product.colors.isNotEmpty) {
            _selectedColor = product.colors.first;
          }
          if (_selectedSize == 'One Size' && product.sizes.isNotEmpty) {
            _selectedSize = product.sizes.first;
          }

          return _buildProductScaffold(context, product);
        }

        return _buildLoadingScaffold(context);
      },
    );
  }

  // ──────────────────────────────────────────────
  // Scaffold variants
  // ──────────────────────────────────────────────

  Scaffold _buildLoadingScaffold(BuildContext context) {
    final hasCover =
        widget.coverImageUrl != null && widget.coverImageUrl!.isNotEmpty;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            backgroundColor: AppTheme.background,
            leading: IconButton(
              icon: _circleIcon(Icons.arrow_back_ios_new),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'product-${widget.productId}',
                child: hasCover
                    ? _buildProductImage(widget.coverImageUrl!)
                    : Container(
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: Icon(
                            Icons.image_outlined,
                            size: 64,
                            color: Colors.grey,
                          ),
                        ),
                      ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              transform: Matrix4.translationValues(0.0, -32.0, 0.0),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: widget.productName != null
                              ? Text(
                                  widget.productName!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineLarge
                                      ?.copyWith(fontSize: 28, height: 1.2),
                                )
                              : _skeletonBar(width: 200, height: 28),
                        ),
                        const SizedBox(width: 16),
                        widget.productPrice != null
                            ? Text(
                                '\$${widget.productPrice!.toStringAsFixed(2)}',
                                style: Theme.of(context).textTheme.headlineLarge
                                    ?.copyWith(
                                      color: AppTheme.primary,
                                      fontSize: 24,
                                    ),
                              )
                            : _skeletonBar(width: 70, height: 28),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _skeletonBar(width: 120, height: 20),
                    const SizedBox(height: 12),
                    _skeletonBar(width: double.infinity, height: 14),
                    const SizedBox(height: 8),
                    _skeletonBar(width: double.infinity, height: 14),
                    const SizedBox(height: 8),
                    _skeletonBar(width: 220, height: 14),
                    const SizedBox(height: 32),
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppTheme.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Loading details...',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _skeletonBar({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(height / 2),
      ),
    );
  }

  Scaffold _buildErrorScaffold(BuildContext context, String message) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        leading: _backButton(context),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.accent.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.wifi_off_rounded,
                  size: 56,
                  color: AppTheme.accent,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Something went wrong',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => context.read<ProductDetailsCubit>().retry(),
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Scaffold _buildProductScaffold(BuildContext context, Product product) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            backgroundColor: AppTheme.background,
            leading: IconButton(
              icon: _circleIcon(Icons.arrow_back_ios_new),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              BlocBuilder<WishlistCubit, WishlistState>(
                builder: (context, state) {
                  final isFav = context.read<WishlistCubit>().isFavorite(
                    product.id,
                  );
                  return IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        size: 18,
                        color: isFav ? AppTheme.accent : Colors.black87,
                      ),
                    ),
                    onPressed: () {
                      context.read<WishlistCubit>().toggleWishlist(product);
                    },
                  );
                },
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  PageView.builder(
                    controller: _imagePageController,
                    itemCount: product.images.isEmpty
                        ? 1
                        : product.images.length,
                    onPageChanged: (index) {
                      setState(() => _currentImageIndex = index);
                    },
                    itemBuilder: (context, index) {
                      final imageUrl = product.images.isEmpty
                          ? (widget.coverImageUrl ?? '')
                          : product.images[index];
                      final image = _buildProductImage(imageUrl);

                      if (index == 0) {
                        return Hero(
                          tag: 'product-${widget.productId}',
                          child: image,
                        );
                      }
                      return image;
                    },
                  ),
                  if (product.images.length > 1)
                    Positioned(
                      bottom: 56,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.55),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${_currentImageIndex + 1} / ${product.images.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              transform: Matrix4.translationValues(0.0, -32.0, 0.0),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            style: Theme.of(context).textTheme.headlineLarge
                                ?.copyWith(fontSize: 28, height: 1.2),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.headlineLarge
                              ?.copyWith(color: AppTheme.primary, fontSize: 24),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Description',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        height: 1.6,
                        fontSize: 16,
                      ),
                    ),
                    if (product.colors.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      Text(
                        'Select Color',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ColorSelector(
                        colors: product.colors,
                        selectedColor: _selectedColor,
                        onColorSelected: (color) {
                          setState(() => _selectedColor = color);
                        },
                      ),
                    ],
                    if (product.sizes.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      Text(
                        'Select Size',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizeSelector(
                        sizes: product.sizes,
                        selectedSize: _selectedSize,
                        onSizeSelected: (size) {
                          setState(() => _selectedSize = size);
                        },
                      ),
                    ],
                    const SizedBox(height: 32),
                    PrimaryButton(
                      text: 'Add to Cart',
                      onPressed: () {
                        context.read<CartCubit>().addProduct(
                          product,
                          selectedSize: _selectedSize,
                          selectedColor: _selectedColor,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${product.name} added to cart'),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: AppTheme.primary,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────
  // Helpers
  // ──────────────────────────────────────────────

  Widget _backButton(BuildContext? context) {
    return IconButton(
      icon: _circleIcon(Icons.arrow_back_ios_new),
      onPressed: context != null ? () => Navigator.pop(context) : null,
    );
  }

  Widget _circleIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 16),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      color: Colors.grey.shade100,
      child: const Center(
        child: Icon(Icons.image_not_supported_outlined, color: Colors.grey),
      ),
    );
  }

  Widget _buildProductImage(String imageUrl) {
    if (imageUrl.isEmpty) return _imagePlaceholder();
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Container(
          color: Colors.grey.shade100,
          child: Center(
            child: CircularProgressIndicator(
              value: progress.expectedTotalBytes != null
                  ? progress.cumulativeBytesLoaded /
                        progress.expectedTotalBytes!
                  : null,
              color: AppTheme.primary,
              strokeWidth: 2,
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) => _imagePlaceholder(),
    );
  }
}
