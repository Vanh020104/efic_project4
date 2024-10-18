import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shop/screens/designer/views/appointment_screen.dart';

class DesignerListScreen extends StatefulWidget {
  const DesignerListScreen({Key? key}) : super(key: key);

  @override
  _DesignerListScreenState createState() => _DesignerListScreenState();
}

class _DesignerListScreenState extends State<DesignerListScreen> {
  List<dynamic> designers = [];
  bool isLoading = true;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    fetchDesigners();
  }

  Future<void> fetchDesigners() async {
    const String apiUrl = 'http://10.0.2.2:8080/api/v1/users/role/3';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // Assuming the designers data is in "content"
        setState(() {
          designers = data['data']['content'];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load designers');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching designers: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'Designer List',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: designers.length,
              itemBuilder: (context, index) {
                final designer = designers[index];
                return Padding(
                  // padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundImage: AssetImage(
                            'assets/images/login_dark.png'), 
                      ),
                      title: Text(
                        designer['username'],
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                          'Email: ${designer['email']}\nPhone: ${designer['phoneNumber']}'),
                      onTap: () {
                         Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AppointmentScreen(
                                designerId: designer['id'],
                               
                              ),
                            ),
                          );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
