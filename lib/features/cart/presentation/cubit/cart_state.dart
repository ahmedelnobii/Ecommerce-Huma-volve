import '../../domain/entities/cart_item.dart';

class CartState {
  final List<CartItem> items;

  const CartState({this.items = const []});

  int get itemCount => items.fold(0, (total, item) => total + item.quantity);

  double get subtotal => items.fold(
    0,
    (total, item) => total + item.product.price * item.quantity,
  );

  double get tax => subtotal * 0.1;

  double get total => subtotal + tax;
}
