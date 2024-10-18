import 'package:flutter/material.dart';
import 'package:shop/models/product.dart';
import 'package:shop/services/product_service.dart';
import 'package:shop/route/route_constants.dart';

import '../../../constants.dart';

class BookmarkScreen extends StatefulWidget {
  final int? categoryId;

  const BookmarkScreen({Key? key, this.categoryId}) : super(key: key);

  @override
  _BookmarkScreenState createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  late Future<List<Product>> futureProducts;
  final ProductService productService = ProductService();
  final ScrollController _scrollController = ScrollController(); // Thêm ScrollController

  @override
  void initState() {
    super.initState();
    if (widget.categoryId != null) {
      print('Selected categoryId: ${widget.categoryId}');
      futureProducts = productService.fetchProductsByCategoryId(widget.categoryId!);
    } else {
      futureProducts = productService.fetchProducts(1, 10);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop'),
      ),
      body: Column(
        children: [
          // Hiển thị thông báo nếu có categoryId
          if (widget.categoryId != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Products by category',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
            ),
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: futureProducts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No products found'));
                } else {
                  // Cuộn về vị trí đầu tiên khi dữ liệu đã tải xong
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (_scrollController.hasClients) {
                      _scrollController.jumpTo(0);
                    }
                  });

                  return CustomScrollView(
                    controller: _scrollController, // Gán ScrollController vào CustomScrollView
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: defaultPadding, vertical: defaultPadding),
                        sliver: SliverGrid(
                          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200.0,
                            mainAxisSpacing: defaultPadding,
                            crossAxisSpacing: defaultPadding,
                            childAspectRatio: 0.66,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              final product = snapshot.data![index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    productDetailsScreenRoute,
                                    arguments: {
                                      'productId': product.productId,
                                    },
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(defaultBorderRadious),
                                  ),
                                  padding: const EdgeInsets.all(defaultPadding / 2),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      AspectRatio(
                                        aspectRatio: 1.15,
                                        child: product.images.isNotEmpty 
                                          ? (product.images[0].imageUrl.startsWith('http') 
                                            ? Image.network(
                                                product.images[0].imageUrl,
                                                height: 110,
                                                width: 110,
                                                errorBuilder: (context, error, stackTrace) {
                                                  return const Icon(Icons.error, size: 110);
                                                },
                                              )
                                            : Image.network(
                                                'http://10.0.2.2:8080/api/v1/product-images/imagesPost/${product.images[0].imageUrl}',
                                                height: 110,
                                                width: 110,
                                                errorBuilder: (context, error, stackTrace) {
                                                  return const Icon(Icons.error, size: 110);
                                                },
                                              ))
                                          : Image.asset(
                                              'assets/images/0055.png_860.png',
                                              height: 110,
                                              width: 110,
                                              errorBuilder: (context, error, stackTrace) {
                                                return const Icon(Icons.error, size: 110);
                                              },
                                            ),
                                      ),
                                      const SizedBox(height: defaultPadding / 2),
                                      Text(
                                        product.manufacturer.toUpperCase(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(fontSize: 10),
                                      ),
                                      const SizedBox(height: defaultPadding / 2),
                                      Text(
                                        product.name,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .copyWith(fontSize: 12),
                                      ),
                                      const Spacer(),
                                      Text(
                                        "\$${product.price}",
                                        style: const TextStyle(
                                          color: Color(0xFF31B0D8),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            childCount: snapshot.data!.length,
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
