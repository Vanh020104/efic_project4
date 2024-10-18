// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:shop/services/appointment_service.dart';
// import 'package:url_launcher/url_launcher.dart';

// class UserAppointmentDetail extends StatefulWidget {
//   final int appointmentId;

//   const UserAppointmentDetail({Key? key, required this.appointmentId}) : super(key: key);

//   @override
//   _UserAppointmentDetailState createState() => _UserAppointmentDetailState();
// }

// class _UserAppointmentDetailState extends State<UserAppointmentDetail> {
//   final AppointmentService _appointmentService = AppointmentService();
//   Map<String, dynamic>? appointmentDetail;
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetchAppointmentDetail();
//   }

//   Future<void> _fetchAppointmentDetail() async {
//     try {
//       final detail = await _appointmentService.getAppointmentDetail(widget.appointmentId);
//       setState(() {
//         appointmentDetail = detail['data'];
//         isLoading = false;
//       });
//     } catch (e) {
//       print('Error fetching appointment detail: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to fetch appointment detail: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   Future<void> _makePhoneCall(String phoneNumber) async {
//     final Uri launchUri = Uri(
//       scheme: 'tel',
//       path: phoneNumber,
//     );
//     await launchUrl(launchUri);
//   }

//   Future<void> _makeVideoCall(String phoneNumber) async {
//     final Uri launchUri = Uri(
//       scheme: 'duo',
//       path: phoneNumber,
//     );
//     if (await canLaunchUrl(launchUri)) {
//       await launchUrl(launchUri);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Google Duo is not installed on this device.'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return Scaffold(
//         appBar: AppBar(
//           title: const Text('Appointment Detail'),
//           backgroundColor: Colors.deepPurple,
//         ),
//         body: const Center(
//           child: CircularProgressIndicator(),
//         ),
//       );
//     }

//     if (appointmentDetail == null) {
//       return Scaffold(
//         appBar: AppBar(
//           title: const Text('Appointment Detail'),
//           backgroundColor: Colors.deepPurple,
//         ),
//         body: const Center(
//           child: Text('Failed to load appointment detail.'),
//         ),
//       );
//     }

//     final DateTime startTime = DateTime.parse(appointmentDetail!['datetimeStart']);
//     final DateTime endTime = DateTime.parse(appointmentDetail!['datetimeEnd']);
//     final String formattedStartTime = DateFormat('HH:mm').format(startTime);
//     final String formattedEndTime = DateFormat('HH:mm').format(endTime);
//     final String formattedDate = DateFormat('yyyy-MM-dd').format(startTime);
//     final Map<String, dynamic>? designer = appointmentDetail!['designer'];
//     final String designerName = designer?['username'] ?? 'N/A';
//     final String designerPhone = designer?['phoneNumber'] ?? 'N/A';
//     final String designerEmail = designer?['email'] ?? 'N/A';
//     final String appointmentUrl = appointmentDetail!['appointmentUrl'] ?? 'N/A';

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Appointment Detail'),
//         backgroundColor: Colors.blueAccent,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.phone),
//             onPressed: () => _makePhoneCall(designerPhone),
//           ),
//           IconButton(
//             icon: const Icon(Icons.video_call),
//             onPressed: () => _makeVideoCall(designerPhone),
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Card(
//           elevation: 4,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 ListTile(
//                   leading: const Icon(Icons.calendar_today, color: Colors.blueAccent),
//                   title: const Text(
//                     'Date',
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   subtitle: Text(formattedDate),
//                 ),
//                 const Divider(),
//                 ListTile(
//                   leading: const Icon(Icons.access_time, color: Colors.blueAccent),
//                   title: const Text(
//                     'Start Time',
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   subtitle: Text(formattedStartTime),
//                 ),
//                 const Divider(),
//                 ListTile(
//                   leading: const Icon(Icons.access_time_filled, color: Colors.blueAccent),
//                   title: const Text(
//                     'End Time',
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   subtitle: Text(formattedEndTime),
//                 ),
//                 const Divider(),
//                 ListTile(
//                   leading: const Icon(Icons.person, color: Colors.blueAccent),
//                   title: const Text(
//                     'Designer Name',
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   subtitle: Text(designerName),
//                 ),
//                 const Divider(),
//                 ListTile(
//                   leading: const Icon(Icons.phone, color: Colors.blueAccent),
//                   title: const Text(
//                     'Designer Phone',
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   subtitle: Text(designerPhone),
//                 ),
//                 const Divider(),
//                 ListTile(
//                   leading: const Icon(Icons.email, color: Colors.blueAccent),
//                   title: const Text(
//                     'Designer Email',
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   subtitle: Text(designerEmail),
//                 ),
//                 const Divider(),
//                 ListTile(
//                   leading: const Icon(Icons.link, color: Colors.blueAccent),
//                   title: const Text(
//                     'Appointment URL',
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   subtitle: Text(appointmentUrl),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop/services/appointment_service.dart';
import 'package:url_launcher/url_launcher.dart';

class UserAppointmentDetail extends StatefulWidget {
  final int appointmentId;

  const UserAppointmentDetail({Key? key, required this.appointmentId}) : super(key: key);

  @override
  _UserAppointmentDetailState createState() => _UserAppointmentDetailState();
}

class _UserAppointmentDetailState extends State<UserAppointmentDetail> {
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
          backgroundColor: Colors.deepPurple,
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
          backgroundColor: Colors.deepPurple,
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
    final Map<String, dynamic>? designer = appointmentDetail!['designer'];
    final String designerName = designer?['username'] ?? 'N/A';
    final String designerPhone = designer?['phoneNumber'] ?? 'N/A';
    final String designerEmail = designer?['email'] ?? 'N/A';
    final String appointmentUrl = appointmentDetail!['appointmentUrl'] ?? 'N/A';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment Detail'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.phone),
            onPressed: () => _makePhoneCall(designerPhone),
          ),
          IconButton(
            icon: const Icon(Icons.video_call),
            onPressed: () => _makeVideoCall(designerPhone),
          ),
        ],
      ),
      body: SingleChildScrollView(  // Bọc toàn bộ nội dung trong SingleChildScrollView
        child: Padding(
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
                    leading: const Icon(Icons.calendar_today, color: Colors.blueAccent),
                    title: const Text(
                      'Date',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(formattedDate),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.access_time, color: Colors.blueAccent),
                    title: const Text(
                      'Start Time',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(formattedStartTime),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.access_time_filled, color: Colors.blueAccent),
                    title: const Text(
                      'End Time',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(formattedEndTime),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.person, color: Colors.blueAccent),
                    title: const Text(
                      'Designer Name',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(designerName),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.phone, color: Colors.blueAccent),
                    title: const Text(
                      'Designer Phone',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(designerPhone),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.email, color: Colors.blueAccent),
                    title: const Text(
                      'Designer Email',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(designerEmail),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.link, color: Colors.blueAccent),
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
      ),
    );
  }
}
