import 'package:flutter/material.dart';

import '../../constants.dart';
import '../network_image_with_loader.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.image,
    required this.manufacturer,
    required this.price,
    required this.press,
  });

  final String image, manufacturer;
  final double price;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: press,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(140, 220),
        maximumSize: const Size(140, 220),
        padding: const EdgeInsets.all(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1.15,
            child: NetworkImageWithLoader(image, radius: defaultBorderRadious),
          ),
          const SizedBox(height: defaultPadding / 2),
          Text(
            manufacturer.toUpperCase(),
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontSize: 10),
          ),
          const SizedBox(height: defaultPadding / 2),
          Text(
            "\$$price",
            style: const TextStyle(
              color: Color(0xFF31B0D8),
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}