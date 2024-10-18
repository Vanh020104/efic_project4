import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // Import intl for date formatting
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/route/route_constants.dart';
import 'package:url_launcher/url_launcher.dart'; // Import SharedPreferences

class AppointmentScreen extends StatefulWidget {
  final int designerId;

  const AppointmentScreen({Key? key, required this.designerId}) : super(key: key);

  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  DateTime? selectedDate;
  List<dynamic> appointments = [];
  bool isLoading = true;
  bool hasData = true;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    fetchAppointments();
  }

  Future<void> fetchAppointments() async {
    if (selectedDate == null) return;

    final String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate!) + 'T00:00:00'; // Format date to YYYY-MM-DD and add T00:00:00
    final String apiUrl =
        'http://10.0.2.2:8080/api/v1/appointments/day?date=$formattedDate&designerId=${widget.designerId}';


    try {
      // Get token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('accessToken');
      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token', 
        },
      );

     
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print('API Response: $data');

        setState(() {
          if (data['data'] != null && data['data'].isNotEmpty) {
            appointments = data['data'];
            hasData = true;
          } else {
            hasData = false;
          }
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load appointments');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
        hasData = false;
      });
      print('Error fetching appointments: $error');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        isLoading = true; // Show loading when calling API
      });
      fetchAppointments(); // Call API with the newly selected date
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue, // Set AppBar color to blue
        title: Text(
          'Appointments on ${selectedDate != null ? DateFormat('yyyy-MM-dd').format(selectedDate!) : 'Select a date'}',
          style: const TextStyle(
            fontWeight: FontWeight.bold, // Bold title
            color: Colors.white, // White text color
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today, color: Colors.white), // White calendar icon
            onPressed: () => _selectDate(context), // Date picker icon in top-right
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : hasData
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: appointments.length,
                        itemBuilder: (context, index) {
                          final appointment = appointments[index];
                          
                          // Formatting times to show only the hour and minute
                          String startTime = DateFormat('HH:mm').format(DateTime.parse(appointment['datetimeStart']));
                          String endTime = DateFormat('HH:mm').format(DateTime.parse(appointment['datetimeEnd']));

                          return GestureDetector(
  onTap: () {
    // Navigate to the DetailScreen and pass the appointment ID
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(appointmentId: appointment['id']),
      ),
    );
  },
  child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Card(
      elevation: 6, // Increased shadow effect
      color: appointment['status'] == 'AVAILABLE' ? const Color.fromARGB(255, 55, 190, 60) : Colors.grey[300], // Change color based on status
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Rounded corners
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Appointment',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black87, // Darker text color
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time, color: Colors.blue), // Time icon
                const SizedBox(width: 8), // Spacing between icon and text
                Text(
                  'Time: $startTime - $endTime',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold, // Bold the time text
                    color: Colors.black54, // Softer black text for time
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
                  : const Center(
                      child: Text(
                        'No appointments available for the selected date.',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent, // Red text for no-data message
                        ),
                      ),
                    ),
        ],
      ),
    );
  }
}


/// Trang detail




class DetailScreen extends StatefulWidget {
  final int appointmentId;

  const DetailScreen({Key? key, required this.appointmentId}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Map<String, dynamic>? appointmentDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAppointmentDetails();
  }

  Future<void> fetchAppointmentDetails() async {
    final String apiUrl = 'http://10.0.2.2:8080/api/v1/appointments/id/${widget.appointmentId}';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        setState(() {
          appointmentDetails = json.decode(response.body)['data'];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load appointment details');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching appointment details: $error');
    }
  }

  Future<void> scheduleAppointment() async {
    final prefs = await SharedPreferences.getInstance();
    final int? userId = prefs.getInt('userId');
    final String? token = prefs.getString('accessToken');

    if (userId == null || token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User ID or token not found. Please log in again.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final String apiUrl = 'http://10.0.2.2:8080/api/v1/appointments/updateStatus/${widget.appointmentId}';
    final Map<String, dynamic> data = {
      'status': 'UNAVAILABLE',
      'userId': userId,
    };

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        setState(() {
          appointmentDetails!['status'] = 'UNAVAILABLE';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Appointment scheduled successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        print('Failed to schedule appointment: ${response.statusCode} ${response.body}');
        throw Exception('Failed to schedule appointment: ${response.statusCode} ${response.body}');
      }
    } catch (error) {
      print('Error scheduling appointment: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to schedule appointment: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Appointment Details', style: TextStyle(color: Colors.white)),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : appointmentDetails == null
              ? const Center(child: Text('Unable to load appointment details.'))
              : Column(
                  children: [
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16), 
                      
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Card(
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Appointment ',
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        const Icon(Icons.access_time, color: Colors.blue),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Start: ${DateFormat('HH:mm').format(DateTime.parse(appointmentDetails!['datetimeStart']))}',
                                          style: const TextStyle(fontSize: 18, color: Color.fromARGB(255, 40, 40, 40)),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(Icons.access_time_outlined, color: Colors.red),
                                        const SizedBox(width: 8),
                                        Text(
                                          'End: ${DateFormat('HH:mm').format(DateTime.parse(appointmentDetails!['datetimeEnd']))}',
                                          style: const TextStyle(fontSize: 18, color: Color.fromARGB(255, 40, 40, 40)),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    // Row(
                                    //   children: [
                                    //     const Icon(Icons.info, color: Colors.green),
                                    //     const SizedBox(width: 8),
                                    //     Text(
                                    //       'Status: ${appointmentDetails!['status']}',
                                    //       style: const TextStyle(fontSize: 18, color: Color.fromARGB(255, 40, 40, 40)),
                                    //     ),
                                    //   ],
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 32), // Khoảng cách giữa card và nút
                            ElevatedButton(
                              onPressed: appointmentDetails!['status'] == 'AVAILABLE'
                                  ? () {
                                      scheduleAppointment();
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                              ),
                              child: const Text(
                                'Schedule Appointment',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}