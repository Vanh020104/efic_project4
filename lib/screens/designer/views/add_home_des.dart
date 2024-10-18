import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HouseDescriptionForm extends StatefulWidget {
  @override
  _HouseDescriptionFormState createState() => _HouseDescriptionFormState();
}

class _HouseDescriptionFormState extends State<HouseDescriptionForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _lengthController = TextEditingController();
  String? _selectedColor;
  XFile? _image;

  final List<String> colors = ['Red', 'Blue', 'Yellow', 'White', 'Black'];

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Lấy token từ SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (token == null) {
        ScaffoldMessenger.of(this.context).showSnackBar(
          SnackBar(content: Text('Token không tồn tại. Vui lòng đăng nhập lại.')),
        );
        return;
      }

      // In ra token để kiểm tra
      print('Token: $token');

      // Tạo yêu cầu multipart
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://10.0.2.2:8080/api/v1/room_specifications'),
      );

      // Thêm token vào tiêu đề
      request.headers['Authorization'] = 'Bearer $token';

      // Thêm các dữ liệu
      request.fields['room_length'] = _lengthController.text;
      request.fields['room_width'] = _heightController.text;
      request.fields['color'] = _selectedColor ?? '';
      request.fields['userId'] = prefs.getInt('userId').toString(); // Lấy userId từ SharedPreferences
      request.fields['appointmentId'] = '6'; // Cập nhật giá trị này nếu cần

      // In ra dữ liệu
      print('Dữ liệu gửi đi:');
      print('room_length: ${_lengthController.text}');
      print('room_width: ${_heightController.text}');
      print('color: ${_selectedColor ?? ''}');
      print('userId: ${prefs.getInt('userId').toString()}');
      print('appointmentId: 6');

      // Thêm tệp hình ảnh nếu đã chọn
      if (_image != null) {
        var file = await http.MultipartFile.fromPath('image', _image!.path);
        request.files.add(file);
        print('Đã thêm tệp hình ảnh: ${_image!.path}');
      }

      // Gửi yêu cầu
      var response = await request.send();

      // Đọc phản hồi từ máy chủ
      var responseBody = await http.Response.fromStream(response);
      print('Mã trạng thái: ${response.statusCode}');
      print('Phản hồi: ${responseBody.body}');

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(this.context).showSnackBar(
          SnackBar(content: Text('Lưu thông tin thành công!')),
        );
      } else {
        ScaffoldMessenger.of(this.context).showSnackBar(
          SnackBar(content: Text('Không thể lưu thông tin.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('House Description Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _heightController,
                  decoration: InputDecoration(labelText: 'Height (m)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập chiều cao';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _lengthController,
                  decoration: InputDecoration(labelText: 'Length (m)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập chiều dài';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Color'),
                  value: _selectedColor,
                  items: colors.map((color) {
                    return DropdownMenuItem(
                      value: color,
                      child: Text(color),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedColor = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Vui lòng chọn màu';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Upload Image:'),
                    IconButton(
                      icon: Icon(Icons.upload_file),
                      onPressed: _pickImage,
                      tooltip: 'Upload Image',
                      iconSize: 24,
                    ),
                  ],
                ),
                if (_image != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: SizedBox(
                      width: 100,
                      height: 150,
                      child: Image.file(
                        File(_image!.path),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}