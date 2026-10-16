import 'package:flutter/material.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/product.dart';

final dummyProducts = [
  Product(
    id: '1',
    name: 'Classic White Sneakers',
    description: 'Comfortable and stylish white sneakers for everyday use.',
    price: 59.99,
    images: ['https://picsum.photos/seed/sneakers/300/300'],
    colors: [Colors.white, Colors.black, Colors.grey],
    sizes: ['40', '41', '42', '43'],
  ),
  Product(
    id: '2',
    name: 'Denim Jacket',
    description: 'A classic denim jacket that never goes out of style.',
    price: 89.99,
    images: ['https://picsum.photos/seed/jacket/300/300'],
    colors: [Colors.blue, Colors.black],
    sizes: ['S', 'M', 'L', 'XL'],
  ),
  Product(
    id: '3',
    name: 'Wireless Headphones',
    description: 'High-quality noise-canceling wireless headphones.',
    price: 199.99,
    images: ['https://picsum.photos/seed/headphones/300/300'],
    colors: [Colors.black, Colors.grey],
    sizes: ['One Size'],
  ),
  Product(
    id: '4',
    name: 'Smart Watch',
    description: 'Stay connected and track your fitness with this smart watch.',
    price: 149.99,
    images: ['https://picsum.photos/seed/watch/300/300'],
    colors: [Colors.black, Colors.blue, Colors.pink],
    sizes: ['One Size'],
  ),
];

class UserProfile {
  final String name;
  final String email;
  final String profilePictureUrl;

  UserProfile({
    required this.name,
    required this.email,
    required this.profilePictureUrl,
  });
}

final dummyUser = UserProfile(
  name: 'John Doe',
  email: 'john.doe@example.com',
  profilePictureUrl: 'https://picsum.photos/seed/user/150/150',
);

final dummyCategories = [
  'All',
  'Shoes',
  'Clothing',
  'Accessories',
  'Electronics',
];
