import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/services/user_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final UserService _userService = UserService();
  String _name = 'Unknown';
  String _email = 'Unknown';
  String _dateOfBirth = 'Unknown';
  String _phoneNumber = 'Unknown';
  String _gender = 'Unknown';
  String _avatar = '';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    // print('User ID: $userId'); // In ra giá trị của userId để kiểm tra

    if (userId != null) {
      try {
        final userInfo = await _userService.getUserInfo(userId);
        // print('User Info: $userInfo'); // In ra dữ liệu người dùng để kiểm tra
        setState(() {
          _name = userInfo['username'] ?? 'Unknown';
          _email = userInfo['email'] ?? 'Unknown';
          _dateOfBirth = userInfo['dateOfBirth'] ?? 'Unknown';
          _phoneNumber = userInfo['phoneNumber'] ?? 'Unknown';
          _gender = userInfo['gender'] ?? 'Unknown';
          _avatar = userInfo['avatar'] ?? '';
        });
      } catch (e) {
        // Handle error
        print('Failed to load user data: $e');
      }
    } else {
      print('No userId found in SharedPreferences');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              // Hành động khi nhấn "Edit"
            },
            child: const Text(
              'Edit',
              style: TextStyle(color: Colors.purple, fontSize: 16),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  // Hình ảnh và thông tin người dùng
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: _avatar.isNotEmpty
                        ? CachedNetworkImageProvider(_avatar)
                        : AssetImage('assets/images/avatar.jpg') as ImageProvider<Object>,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _email,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Các trường thông tin
            buildInfoRow('Name', _name),
            const Divider(),
            buildInfoRow('Date of birth', _dateOfBirth),
            const Divider(),
            buildInfoRow('Phone number', _phoneNumber),
            const Divider(),
            buildInfoRow('Gender', _gender),
            const Divider(),
            buildInfoRow('Email', _email),
            const Divider(),

            // Mật khẩu và nút thay đổi mật khẩu
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Password',
                  style: TextStyle(fontSize: 16),
                ),
                TextButton(
                  onPressed: () {
                    // Hành động khi nhấn "Change Password"
                  },
                  child: const Text(
                    'Change Password',
                    style: TextStyle(color: Colors.purple, fontSize: 14),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget để xây dựng hàng thông tin với tiêu đề và giá trị
  Widget buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}