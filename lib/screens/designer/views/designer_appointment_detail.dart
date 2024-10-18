import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop/services/appointment_service.dart';
import 'package:url_launcher/url_launcher.dart';

class AppointmentDetail extends StatefulWidget {
  final int appointmentId;

  const AppointmentDetail({Key? key, required this.appointmentId}) : super(key: key);

  @override
  _AppointmentDetailState createState() => _AppointmentDetailState();
}

class _AppointmentDetailState extends State<AppointmentDetail> {
  final AppointmentService _appointmentService = AppointmentService();
  Map<String, dynamic>? appointmentDetail;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAppointmentDetail();
  }

  Future<void> _fetchAppointmentDetail() async {
    try {
      final detail = await _appointmentService.getAppointmentDetail(widget.appointmentId);
      setState(() {
        appointmentDetail = detail['data'];
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching appointment detail: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to fetch appointment detail: $e'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  Future<void> _makeVideoCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'duo',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Google Duo is not installed on this device.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Appointment Detail'),
          backgroundColor: Colors.blueAccent,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (appointmentDetail == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Appointment Detail'),
          backgroundColor: Colors.blueAccent,
        ),
        body: const Center(
          child: Text('Failed to load appointment detail.'),
        ),
      );
    }

    final DateTime startTime = DateTime.parse(appointmentDetail!['datetimeStart']);
    final DateTime endTime = DateTime.parse(appointmentDetail!['datetimeEnd']);
    final String formattedStartTime = DateFormat('HH:mm').format(startTime);
    final String formattedEndTime = DateFormat('HH:mm').format(endTime);
    final String formattedDate = DateFormat('yyyy-MM-dd').format(startTime);
    final Map<String, dynamic>? user = appointmentDetail!['user'];
    final String userName = user?['username'] ?? 'N/A';
    final String userPhone = user?['phoneNumber'] ?? 'N/A';
    final String userEmail = user?['email'] ?? 'N/A';
    final String appointmentUrl = appointmentDetail!['appointmentUrl'] ?? 'N/A';

    return Scaffold(
  appBar: AppBar(
    title: const Text('Appointment Detail'),
    backgroundColor: Colors.blueAccent,
    actions: [
      IconButton(
        icon: const Icon(Icons.phone),
        onPressed: () => _makePhoneCall(userPhone),
      ),
      IconButton(
        icon: const Icon(Icons.video_call),
        onPressed: () => _makeVideoCall(userPhone),
      ),
    ],
  ),
  body: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: const Icon(Icons.calendar_today, color: Colors.blueAccent), // Biểu tượng lịch
              title: const Text(
                'Date',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(formattedDate),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.access_time, color: Colors.blueAccent), // Biểu tượng thời gian
              title: const Text(
                'Start Time',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(formattedStartTime),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.access_time_filled, color: Colors.blueAccent), // Biểu tượng thời gian kết thúc
              title: const Text(
                'End Time',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(formattedEndTime),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.blueAccent), // Biểu tượng người dùng
              title: const Text(
                'User Name',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(userName),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.phone, color: Colors.blueAccent), // Biểu tượng điện thoại
              title: const Text(
                'User Phone',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(userPhone),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.email, color: Colors.blueAccent), // Biểu tượng email
              title: const Text(
                'User Email',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(userEmail),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.link, color: Colors.blueAccent), // Biểu tượng link
              title: const Text(
                'Appointment URL',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(appointmentUrl),
            ),
          ],
        ),
      ),
    ),
  ),
);

  }
}