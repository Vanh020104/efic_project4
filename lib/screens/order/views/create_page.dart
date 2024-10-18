import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreatePage extends StatefulWidget {
  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  List<Order> orders = [];
  bool isLoading = true;
  String? accessToken;
  int? userId;
  bool hasData = true;

  @override
  void initState() {
    super.initState();
    fetchUserCredentials();
  }

  Future<void> fetchUserCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString('accessToken');
    userId = prefs.getInt('userId');

    if (accessToken != null && userId != null) {
      fetchOrders();
    } else {
      print("No accessToken or userId found.");
    }
  }

  Future<void> fetchOrders() async {
    final url = Uri.parse('http://10.0.2.2:8080/api/v1/orders/user/$userId/status?status=CREATED');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> content = data['data']['content'];

      setState(() {
        if (content.isEmpty) {
          hasData = false;
        } else {
          orders = content.map((json) => Order.fromJson(json)).toList();
        }
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load orders');
    }
  }

  String formatDateTime(String dateTimeStr) {
    final DateTime parsedDate = DateTime.parse(dateTimeStr);
    return DateFormat('MMMM d, yyyy, h:mm a').format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Orders', style: TextStyle(fontSize: 18, color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : hasData
              ? Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderDetailPage(orderId: order.id),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            elevation: 6,
                            shadowColor: Colors.grey.withOpacity(0.3),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Order ID: ${order.id}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.monetization_on,
                                        color: Colors.green,
                                        size: 18,
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        'Total Price: \$${order.totalPrice.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        color: Colors.blueGrey,
                                        size: 18,
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        'Created At: ${formatDateTime(order.createdAt)}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              : Center(
                  child: Text(
                    'No pending orders available.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ),
    );
  }
}

// Order class
class Order {
  final String id;
  final double totalPrice;
  final String createdAt;

  Order({required this.id, required this.totalPrice, required this.createdAt});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      totalPrice: json['totalPrice'],
      createdAt: json['createdAt'],
    );
  }
}



class OrderDetailPage extends StatefulWidget {
  final String orderId;

  const OrderDetailPage({Key? key, required this.orderId}) : super(key: key);

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  Map<String, dynamic>? orderDetails; // Holds the fetched order details
  bool isLoading = true; // For loading state
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchOrderDetails(); // Fetch the order details when the page is loaded
  }

  // Fetch token from SharedPreferences
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  // Fetch order details from the API
  Future<void> fetchOrderDetails() async {
    final token = await getToken();
    if (token == null) {
      setState(() {
        isLoading = false;
        errorMessage = 'User token is missing';
      });
      return;
    }

    final orderId = widget.orderId; // Order ID from the widget
    final url = 'http://10.0.2.2:8080/api/v1/orders/$orderId';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token', // Attach token in headers
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          orderDetails = json.decode(response.body); // Decode JSON response
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load order details (Status: ${response.statusCode})';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'An error occurred: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Order Details',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loader while fetching
          : errorMessage != null
              ? Center(child: Text(errorMessage!)) // Display error if occurred
              : orderDetails != null
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Order Information',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Display order ID
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.deepPurple.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.deepPurple.shade100),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.receipt_long, color: Colors.deepPurple),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Order ID: ${orderDetails!['id']}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Display Order Status
                          const Text(
                            'Order Status',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.green.shade200),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle, color: Colors.green),
                                const SizedBox(width: 12),
                                Text(
                                  orderDetails!['status'] ?? 'Unknown',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green.shade800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),

                          // Display order summary or items
                          const Text(
                            'Order Summary',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // // Iterate over products in orderDetails (adjust as per API response)
                                // ...(orderDetails!['items'] as List<dynamic>)
                                //     .map(
                                //       (item) => Text(
                                //         '${item['name']}: \$${item['price']} x ${item['quantity']}',
                                //         style: const TextStyle(fontSize: 16),
                                //       ),
                                //     )
                                //     .toList(),
                                const Divider(height: 30, thickness: 1),
                                Text(
                                  'Total: \$${orderDetails!['total']}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : const Center(child: Text('No details available')),
    );
  }
}

