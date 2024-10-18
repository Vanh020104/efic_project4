import 'package:flutter/material.dart';
import 'package:shop/components/buy_full_ui_kit.dart';
import 'package:shop/components/cart_button.dart';
import 'package:shop/components/custom_modal_bottom_sheet.dart';
import 'package:shop/components/product/product_card.dart';
import 'package:shop/components/review_card.dart';
import 'package:shop/models/product.dart';
import 'package:shop/route/route_constants.dart';
import 'package:shop/screens/product/views/components/notify_me_card.dart';
import 'package:shop/screens/product/views/components/product_images.dart';
import 'package:shop/screens/product/views/components/product_info.dart';
import 'package:shop/screens/product/views/components/product_list_tile.dart';
import 'package:shop/screens/product/views/product_buy_now_screen.dart';
import 'package:shop/screens/product/views/product_returns_screen.dart';
import 'package:shop/services/product_service.dart';
import 'package:shop/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductDetailsScreen extends StatelessWidget {
  final int productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final productService = ProductService();

    return Scaffold(
      bottomNavigationBar: FutureBuilder<Product>(
        future: productService.fetchProductById(productId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox.shrink();
          } else if (snapshot.hasError || !snapshot.hasData) {
            return NotifyMeCard(
              isNotify: false,
              onChanged: (value) {},
            );
          } else {
            final product = snapshot.data!;
            final isProductAvailable = product.stockQuantity > 0;
            return isProductAvailable
                ? CartButton(
                    price: product.price,
                    product: product,
                    press: () {
                      customModalBottomSheet(
                        context,
                        height: MediaQuery.of(context).size.height * 0.92,
                        child: ProductBuyNowScreen(product: product),
                      );
                    },
                  )
                : NotifyMeCard(
                    isNotify: false,
                    onChanged: (value) {},
                  );
          }
        },
      ),
      body: FutureBuilder<Product>(
        future: productService.fetchProductById(productId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Product not found'));
          } else {
            final product = snapshot.data!;
            return SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    floating: true,
                    actions: [
                      IconButton(
                        onPressed: () {},
                        icon: SvgPicture.asset("assets/icons/Bookmark.svg",
                            color: Theme.of(context).textTheme.bodyLarge!.color),
                      ),
                    ],
                  ),
                  ProductImages(
                    images: product.images.map((image) => 'http://10.0.2.2:8080/api/v1/product-images/imagesPost/${image.imageUrl}').toList(),
                  ),
                  ProductInfo(
                    brand: product.manufacturer,
                    title: product.name,
                    isAvailable: product.stockQuantity > 0, 
                    description: product.description,
                    rating: 4.4, 
                    numOfReviews: 126,
                    category: product.category!.categoryName,
                    size: product.size,
                    weight: product.weight, 
                  ),
                  
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(defaultPadding),
                      child: ReviewCard(
                        rating: 4.3,
                        numOfReviews: 128,
                        numOfFiveStar: 80,
                        numOfFourStar: 30,
                        numOfThreeStar: 5,
                        numOfTwoStar: 4,
                        numOfOneStar: 1,
                      ),
                    ),
                  ),
                  ProductListTile(
                    svgSrc: "assets/icons/Chat.svg",
                    title: "Reviews",
                    isShowBottomBorder: true,
                    press: () {
                      Navigator.pushNamed(context, productReviewsScreenRoute);
                    },
                  ),
                  // SliverPadding(
                  //   padding: const EdgeInsets.all(defaultPadding),
                  //   sliver: SliverToBoxAdapter(
                  //     child: Text(
                  //       "You may also like",
                  //       style: Theme.of(context).textTheme.titleSmall!,
                  //     ),
                  //   ),
                  // ),
                  // SliverToBoxAdapter(
                  //   child: SizedBox(
                  //     height: 220,
                  //     child: ListView.builder(
                  //       scrollDirection: Axis.horizontal,
                  //       itemCount: 5,
                  //       itemBuilder: (context, index) => Padding(
                  //         padding: EdgeInsets.only(
                  //             left: defaultPadding,
                  //             right: index == 4 ? defaultPadding : 0),
                  //         // child: ProductCard(
                  //         //   image: productDemoImg2,
                  //         //   title: "Sleeveless Tiered Dobby Swing Dress",
                  //         //   brandName: "LIPSY LONDON",
                  //         //   price: 24.65,
                  //         //   priceAfetDiscount: index.isEven ? 20.99 : null,
                  //         //   dicountpercent: index.isEven ? 25 : null,
                  //         //   press: () {},
                  //         // ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: defaultPadding),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}