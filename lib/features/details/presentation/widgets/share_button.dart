import 'package:ecommerce_app_huma_volve/features/home/domain/entities/product.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ShareButton extends StatelessWidget {
  final Product product;
  final String? customShareText;

  const ShareButton({super.key, required this.product, this.customShareText});

  Future<void> _share(BuildContext context) async {
    // final box = context.findRenderObject() as RenderBox?;
    // final sharePositionOrigin = box != null
    //     ? box.localToGlobal(Offset.zero) & box.size
    //     : null;

    final shareText =
        customShareText ??
        'Check out "${product.name}" on Shopy!\n'
            'Price: \$${product.price.toStringAsFixed(2)}\n\n'
            '${product.description.isNotEmpty ? '${product.description}\n\n' : ''}'
            'https://evently-route-c19.web.app/details/${product.id}';

    await SharePlus.instance.share(
      ShareParams(text: shareText, subject: product.name, title: product.name),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Share Product',
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
        child: const Icon(
          Icons.share_outlined,
          size: 18,
          color: Colors.black87,
        ),
      ),
      onPressed: () => _share(context),
    );
  }
}
