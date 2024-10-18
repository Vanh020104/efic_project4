import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Để định dạng ngày tháng
import 'package:shop/services/appointment_service.dart';

class CreateScheduleScreen extends StatefulWidget {
  const CreateScheduleScreen({super.key});

  @override
  _CreateScheduleScreenState createState() => _CreateScheduleScreenState();
}

class _CreateScheduleScreenState extends State<CreateScheduleScreen> {
  final AppointmentService _appointmentService = AppointmentService(); // Khởi tạo service

  // Chọn ngày và giờ
  DateTime? selectedDate;
  TimeOfDay? selectedStartTime;

  // Hàm chọn ngày
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  // Hàm chọn giờ bắt đầu
  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? pickedStartTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedStartTime != null) {
      setState(() {
        selectedStartTime = pickedStartTime;
      });
    }
  }

  // Hàm gửi dữ liệu lên API
  Future<void> _submitSchedule() async {
    if (selectedDate != null && selectedStartTime != null) {
      final DateTime datetimeStart = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        selectedStartTime!.hour,
        selectedStartTime!.minute,
      );

      final DateTime now = DateTime.now();
      final DateTime minAllowedTime = now.add(const Duration(hours: 12));

      if (datetimeStart.isBefore(minAllowedTime)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a time at least 12 hours from now.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      try {
        await _appointmentService.createAppointment(datetimeStart); // Gửi dữ liệu lên API
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Appointment created successfully!'), backgroundColor: Colors.green,),
        );
        Navigator.pop(context); // Quay lại trang trước đó
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create appointment: $e')),
        );
      }
    } else {
      // Nếu thiếu dữ liệu, thông báo lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a date and start time.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Schedule'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text(
                selectedDate != null
                    ? DateFormat('dd/MM/yyyy').format(selectedDate!)
                    : 'Select Date',
              ),
              onTap: () => _selectDate(context),
            ),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: Text(
                selectedStartTime != null
                    ? 'Start Time: ${selectedStartTime!.format(context)}'
                    : 'Select Start Time',
              ),
              onTap: () => _selectStartTime(context),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitSchedule,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text(
                'Submit',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}