import 'package:ecommerce_app_huma_volve/features/details/screens/product_details_screen.dart';
import 'package:ecommerce_app_huma_volve/features/splash/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const SplashScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'details/:id',
          builder: (BuildContext context, GoRouterState state) {
            final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
            final extra = state.extra;
            String? coverImageUrl;
            String? productName;
            double? productPrice;

            if (extra is Map<String, dynamic>) {
              coverImageUrl = extra['coverImageUrl'] as String?;
              productName = extra['productName'] as String?;
              productPrice = (extra['productPrice'] as num?)?.toDouble();
            } else if (extra is String) {
              coverImageUrl = extra;
            }

            return ProductDetailsScreen(
              productId: id,
              coverImageUrl: coverImageUrl,
              productName: productName,
              productPrice: productPrice,
            );
          },
        ),
      ],
    ),
  ],
);
