import 'package:flutter/material.dart';
import 'package:shop/models/product.dart';
import 'package:shop/route/route_constants.dart';
import 'package:shop/services/product_service.dart';


import '/components/Banner/M/banner_m_with_counter.dart';
import '../../../../components/product/product_card.dart';
import '../../../../constants.dart';


class FlashSale extends StatelessWidget {
  const FlashSale({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ProductService productService = ProductService();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BannerMWithCounter(
          duration: const Duration(hours: 8),
          text: "Super Flash Sale \n50% Off",
          press: () {},
        ),
        const SizedBox(height: defaultPadding / 2),
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Text(
            "Flash sale",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        FutureBuilder<List<Product>>(
          future: productService.fetchPopularProducts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No flash sale products found'));
            } else {
              return SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final product = snapshot.data![index];
                    return Padding(
                      padding: EdgeInsets.only(
                        left: defaultPadding,
                        right: index == snapshot.data!.length - 1
                            ? defaultPadding
                            : 0,
                      ),
                      child: ProductCard(
                        image: product.images.isNotEmpty
                            ? 'http://10.0.2.2:8080/api/v1/product-images/imagesPost/' + product.images[0].imageUrl
                            : 'assets/images/0055.png_860.png',
                        manufacturer: product.manufacturer,
                        price: product.price,
                        press: () {
                          Navigator.pushNamed(
                            context,
                            productDetailsScreenRoute,
                            arguments: {'productId': product.productId},
                          );
                        },
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),
      ],
    );
  }
}