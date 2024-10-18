import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../constants.dart';
import 'product_availability_tag.dart';

class ProductInfo extends StatelessWidget {
  const ProductInfo({
    super.key,
    required this.title,
    required this.brand,
    required this.description,
    required this.rating,
    required this.numOfReviews,
    required this.isAvailable,
    required this.size,
    required this.weight,
    required this.category,
  });

  final String title, brand, description, size, weight, category;
  final double rating;
  final int numOfReviews;
  final bool isAvailable;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(defaultPadding),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              brand.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: defaultPadding / 2),
            Text(
              title,
              maxLines: 2,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: defaultPadding),
            Row(
              children: [
                ProductAvailabilityTag(isAvailable: isAvailable),
                const Spacer(),
                SvgPicture.asset("assets/icons/Star_filled.svg"),
                const SizedBox(width: defaultPadding / 4),
                Text(
                  "$rating ",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text("($numOfReviews Reviews)")
              ],
            ),
            const SizedBox(height: defaultPadding),
            Text(
              "Product info",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: defaultPadding / 2),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        "Description",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      subtitle: Text(
                        description,
                        style: const TextStyle(height: 1.4),
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        "Category",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      subtitle: Text(
                        category,
                        style: const TextStyle(height: 1.4),
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        "Size",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      subtitle: Text(
                        size,
                        style: const TextStyle(height: 1.4),
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        "Weight",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      subtitle: Text(
                        weight,
                        style: const TextStyle(height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: defaultPadding / 2),
          ],
        ),
      ),
    );
  }
}