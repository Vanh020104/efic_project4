import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CancelPage extends StatefulWidget {
  @override
  _PendingPageState createState() => _PendingPageState();
}

class _PendingPageState extends State<CancelPage> {
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
    final url = Uri.parse('http://10.0.2.2:8080/api/v1/orders/user/$userId/status?status=CANCEL');
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
        title: Text('Cancel', style: TextStyle(fontSize: 18, color: Colors.white)),
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

// New OrderDetailPage to display order details
class OrderDetailPage extends StatelessWidget {
  final String orderId;

  const OrderDetailPage({Key? key, required this.orderId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Replace this with the actual details of the order
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Text(
          'Details for Order ID: $orderId',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
