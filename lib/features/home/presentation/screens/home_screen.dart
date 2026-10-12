import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/dummy_data.dart';
import '../../../../core/di/get_it.dart';
import '../../../../core/theme.dart';
import '../../../../core/widgets/custom_shimmer_card.dart';
import '../../domain/entities/category.dart';
import '../cubit/category_cubit.dart';
import '../cubit/category_states.dart';
import '../cubit/product_cubit.dart';
import '../cubit/product_states.dart';
import '../widgets/product_card.dart';
import '../widgets/category_chip.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<CategoryCubit>()),
        BlocProvider(create: (_) => getIt<ProductCubit>()..loadProducts()),
      ],
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  final ScrollController _scrollController = ScrollController();
  int? _selectedCategoryId;
  bool _allCategoriesSelected = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter < 500) {
      context.read<ProductCubit>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.menu,
                            color: AppTheme.primary,
                          ),
                        ),
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(
                            dummyUser.profilePictureUrl,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Explore',
                      style: Theme.of(
                        context,
                      ).textTheme.displayLarge?.copyWith(fontSize: 36),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Best trendy collection!',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(fontSize: 18),
                    ),
                    const SizedBox(height: 32),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.05),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search clothes...',
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          suffixIcon: Container(
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppTheme.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.tune,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      height: 44,
                      child: BlocBuilder<CategoryCubit, CategoryState>(
                        builder: (context, state) {
                          if (state is CategoryLoading ||
                              state is CategoryInitial) {
                            return ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: 4,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(width: 12),
                              itemBuilder: (context, index) =>
                                  const CustomShimmerCard(
                                    compact: true,
                                    width: 88,
                                    height: 44,
                                    borderRadius: 24,
                                  ),
                            );
                          }
                          if (state is CategoryError) {
                            return Center(
                              child: TextButton(
                                onPressed: context
                                    .read<CategoryCubit>()
                                    .loadCategories,
                                child: Text('Could not load categories. Retry'),
                              ),
                            );
                          }

                          final categories =
                              (state as CategoryLoaded).categories;
                          return _buildCategoryList(categories);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: BlocBuilder<ProductCubit, ProductState>(
                builder: (context, state) {
                  if (state is ProductsInitial || state is ProductsLoading) {
                    return SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.7,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => const CustomShimmerCard(),
                        childCount: 6,
                      ),
                    );
                  }

                  if (state is ProductsError) {
                    return SliverToBoxAdapter(
                      child: Center(
                        child: TextButton(
                          onPressed: () => context
                              .read<ProductCubit>()
                              .loadProducts(categoryId: _selectedCategoryId),
                          child: Text('Could not load products. Retry'),
                        ),
                      ),
                    );
                  }

                  final loaded = state as ProductsLoaded;
                  if (loaded.products.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(child: Text('No products found.')),
                      ),
                    );
                  }

                  final hasFooter =
                      loaded.isLoadingMore || loaded.loadMoreError != null;
                  return SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index == loaded.products.length) {
                          if (loaded.isLoadingMore) {
                            return const CustomShimmerCard();
                          }
                          return Center(
                            child: TextButton(
                              onPressed: context.read<ProductCubit>().loadMore,
                              child: Text(
                                'Could not load more. Retry',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }
                        return ProductCard(product: loaded.products[index]);
                      },
                      childCount: loaded.products.length + (hasFooter ? 1 : 0),
                    ),
                  );
                },
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryList(List<Category> categories) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: categories.length + 1,
      separatorBuilder: (context, index) => const SizedBox(width: 12),
      itemBuilder: (context, index) {
        if (index == 0) {
          return CategoryChip(
            label: 'All',
            isSelected: _allCategoriesSelected,
            onTap: () {
              setState(() {
                _allCategoriesSelected = true;
                _selectedCategoryId = null;
              });
              context.read<ProductCubit>().loadProducts();
            },
          );
        }

        final category = categories[index - 1];
        return CategoryChip(
          label: category.name,
          isSelected:
              !_allCategoriesSelected && _selectedCategoryId == category.id,
          onTap: () {
            setState(() {
              _allCategoriesSelected = false;
              _selectedCategoryId = category.id;
            });
            context.read<ProductCubit>().loadProducts(categoryId: category.id);
          },
        );
      },
    );
  }
}
