import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../home/domain/entities/product.dart';
import '../../domain/entities/cart_item.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState());

  void addProduct(
    Product product, {
    String? selectedSize,
    Color? selectedColor,
    int quantity = 1,
  }) {
    if (quantity < 1) {
      throw ArgumentError.value(quantity, 'quantity', 'Must be at least 1.');
    }

    final item = CartItem(
      product: product,
      quantity: quantity,
      selectedColor:
          selectedColor ??
          (product.colors.isEmpty ? Colors.black : product.colors.first),
      selectedSize:
          selectedSize ??
          (product.sizes.isEmpty ? 'One Size' : product.sizes.first),
    );
    final items = List<CartItem>.from(state.items);
    final existingIndex = items.indexWhere(
      (existing) => existing.hasSameVariant(item),
    );

    if (existingIndex == -1) {
      items.add(item);
    } else {
      items[existingIndex] = items[existingIndex].copyWith(
        quantity: items[existingIndex].quantity + quantity,
      );
    }

    _emitItems(items);
  }

  void increaseQuantity(CartItem item) {
    _updateQuantity(item, item.quantity + 1);
  }

  void decreaseQuantity(CartItem item) {
    if (item.quantity <= 1) {
      removeItem(item);
      return;
    }
    _updateQuantity(item, item.quantity - 1);
  }

  void removeItem(CartItem item) {
    _emitItems(
      state.items.where((current) => !current.hasSameVariant(item)).toList(),
    );
  }

  void clearCart() {
    _emitItems(const []);
  }

  void _updateQuantity(CartItem item, int quantity) {
    final items = List<CartItem>.from(state.items);
    final index = items.indexWhere((current) => current.hasSameVariant(item));
    if (index == -1) return;
    items[index] = items[index].copyWith(quantity: quantity);
    _emitItems(items);
  }

  void _emitItems(List<CartItem> items) {
    emit(CartState(items: List.unmodifiable(items)));
  }
}
