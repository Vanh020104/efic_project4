import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/route/screen_export.dart'; // Import navigation routes
import 'package:shop/route/route_constants.dart';
import 'package:shop/screens/address/views/addresses_screen.dart'; // Address screen
import 'package:shop/screens/home/views/thank_you.dart';
import 'package:shop/services/cart_service.dart'; // Cart service to get cart items
import 'package:shop/services/order_service.dart'; // Order service to place order

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<PaymentScreen> {
  
  String selectedPaymentMethod = 'COD';
  late Future<List<Map<String, dynamic>>> cartItemsFuture; 
  int? userId;
  int? id; 
  String addressText = 'Add delivery address!'; 
  bool hasDefaultAddress = false; 
  String? name;
  String? phone;
  String? addressRegion;
  String? addressDetail;

  @override
  void initState() {
    super.initState();
    getUserId().then((id) {
      setState(() {
        userId = id;
        if (userId != null) {
          cartItemsFuture = CartService().getCartData(userId!); 
          fetchAddress(userId!); 
        }
      });
    });
  }


  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }


  Future<void> fetchAddress(int userId) async {
    final token = await getToken();
    if (token == null) {
      setState(() {
        addressText = 'Add delivery address!';
        hasDefaultAddress = false;
      });
      return;
    }

    final response = await http.get(
      Uri.parse('http://10.0.2.2:8080/api/v1/address_order/user/$userId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      final List<dynamic> addresses = responseBody['data'];

      if (addresses.isNotEmpty) {
        final defaultAddr = addresses.firstWhere(
          (address) => address['isDefault'] == "true",
          orElse: () => null,
        );

        setState(() {
          if (defaultAddr != null) {
            id = defaultAddr['id'];
            name = defaultAddr['username'];
            phone = defaultAddr['phone'];
            addressRegion = defaultAddr['addressRegion'];
            addressDetail = defaultAddr['addressDetail'];
            hasDefaultAddress = true; 
          } else {
            addressText = 'Add delivery address!';
            hasDefaultAddress = false;
          }
        });
      } else {
        setState(() {
          addressText = 'Add delivery address!';
          hasDefaultAddress = false;
        });
      }
    } else {
      setState(() {
        addressText = 'Add delivery address!';
        hasDefaultAddress = false;
      });
    }
  }

 
void _placeOrder(List<Map<String, dynamic>> cartItems) async {
  if (userId == null) return;

  if (id == null) { 
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Color.fromARGB(255, 228, 227, 227),
        content: Text(
          'Please enter a delivery address!', 
          style: TextStyle(color: Colors.red, fontSize: 15),
          )),
    );
    return;
  }

  final orderData = {
    "userId": userId,
    "addressOrderId": id, 
    "note": "Order note here", 
    "paymentMethod": selectedPaymentMethod,
    "totalPrice": cartItems.fold<double>(
      0.0,
      (sum, item) => sum + (item['productPrice'] as double) * (item['quantity'] as int),
    ),
    "cartItems": cartItems.map((item) {
      return {
        "userId": userId,
        "productId": item['productId'],
        "quantity": item['quantity'],
        "unitPrice": item['productPrice'],
      };
    }).toList(),
  };



  try {
    await OrderService().placeOrder(orderData, context);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Order placed successfully!')),
    );

       Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TestPage()), 
    );
  } catch (e) {
    // Handle errors by showing a failure message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to place order: $e')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to previous screen
          },
        ),
        title: const Text('Pay'), // Title of the app bar
      ),
      body: userId == null
          ? const Center(child: CircularProgressIndicator()) // Show loader if userId is null
          : FutureBuilder<List<Map<String, dynamic>>>(
              future: cartItemsFuture, // Future that retrieves cart items
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No items in the cart'));
                }

                final cartItems = snapshot.data!;
                final subtotal = cartItems.fold<double>(
                  0.0,
                  (sum, item) =>
                      sum + (item['productPrice'] as double) * (item['quantity'] as int),
                );
                final total = subtotal + 1; // Example for calculating total (subtotal + shipping)

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Address section
                        Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.location_on, color: Colors.orange),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const AddressesScreen(),
                                          ),
                                        );
                                      },
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          if (hasDefaultAddress)
                                            Text(
                                              '$name, $phone',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          if (hasDefaultAddress)
                                            Text('$addressRegion, $addressDetail'),
                                          if (!hasDefaultAddress)
                                            Text(
                                              addressText,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Product list section
                        ...cartItems.map((item) {
                          final productName = item['productName'];
                          final productPrice = item['productPrice'].toStringAsFixed(2);
                          final quantity = item['quantity'];
                          final imageUrl =
                              'http://10.0.2.2:8080/api/v1/product-images/imagesPost/${item['productImages'][0]}';

                          return Column(
                            children: [
                              productItem(
                                imageUrl: imageUrl,
                                productName: productName,
                                price: '\$$productPrice',
                                quantity: 'x$quantity',
                              ),
                              const SizedBox(height: 16),
                            ],
                          );
                        }),

                        // Payment methods section
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Payment Methods',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              RadioListTile<String>(
                                title: const Text('Payment upon receipt!'),
                                value: 'COD',
                                groupValue: selectedPaymentMethod,
                                onChanged: (value) {
                                  setState(() {
                                    selectedPaymentMethod = value!;
                                  });
                                },
                              ),
                              RadioListTile<String>(
                                title: const Text('Payment with VNPAY'),
                                value: 'VNPAY',
                                groupValue: selectedPaymentMethod,
                                onChanged: (value) {
                                  setState(() {
                                    selectedPaymentMethod = value!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Order summary section
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Column(
                            children: [
                              rowDetail('Subtotal', '\$$subtotal'),
                              const Divider(height: 32),
                              rowDetail('Shipping Fee', 'Free'),
                              const Divider(height: 32),
                              rowDetail('Total', '\$$total'),
                            ],
                          ),
                        ),

                        
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            _placeOrder(cartItems); 
                          
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: const Text('Place Order', style: TextStyle(color: Colors.white),),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  // Helper widget for product item display
  Widget productItem({
    required String imageUrl,
    required String productName,
    required String price,
    required String quantity,
  }) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            imageUrl,
            height: 70,
            width: 70,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(productName,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(price),
                  Text(quantity),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Helper widget for displaying rows in the summary
  Widget rowDetail(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}