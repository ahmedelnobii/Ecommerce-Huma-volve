import 'package:flutter/material.dart';

import '../../../home/domain/entities/product.dart';

class CartItem {
  final Product product;
  final int quantity;
  final Color selectedColor;
  final String selectedSize;

  const CartItem({
    required this.product,
    required this.quantity,
    required this.selectedColor,
    required this.selectedSize,
  });

  bool hasSameVariant(CartItem other) =>
      product.id == other.product.id &&
      selectedColor == other.selectedColor &&
      selectedSize == other.selectedSize;

  CartItem copyWith({int? quantity}) => CartItem(
    product: product,
    quantity: quantity ?? this.quantity,
    selectedColor: selectedColor,
    selectedSize: selectedSize,
  );
}
