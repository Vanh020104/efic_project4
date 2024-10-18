
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class OrderInfo extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Order Information'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0), // Tăng padding 2 bên trái phải
//         child: Column(
//           children: [
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     ListTile(
//                       leading: ClipRRect(
//                         borderRadius: BorderRadius.circular(8.0), // Thêm borderRadius cho ảnh
//                         child: Image.asset("assets/images/banner01.webp", width: 80, height: 80),
//                       ),
//                       title: Text('Printed Sleeveless Tiered Dress'),
//                       subtitle: Text('\$299.43', style: TextStyle(decoration: TextDecoration.lineThrough)),
//                       trailing: Text('\$534.33'),
//                     ),
//                     Divider(), // Thêm thanh ngăn cách
//                     ListTile(
//                       leading: ClipRRect(
//                         borderRadius: BorderRadius.circular(8.0), // Thêm borderRadius cho ảnh
//                         child: Image.asset("assets/images/banner01.webp", width: 80, height: 80),
//                       ),
//                       title: Text('Printed Sleeveless Tiered Dress'),
//                       subtitle: Text('\$299.43', style: TextStyle(decoration: TextDecoration.lineThrough)),
//                       trailing: Text('\$534.33'),
//                     ),
//                     Divider(), // Thêm thanh ngăn cách
//                   ],
//                 ),
//               ),
//             ),
//             Expanded(
//               child: GoogleMap(
//                 initialCameraPosition: CameraPosition(
//                   target: LatLng(21.0288015, 105.7797143), 
//                   zoom: 17,
//                 ),
//                 onMapCreated: (GoogleMapController controller) {
              
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class Product {
//   final String name;
//   final String imageUrl;

//   Product({required this.name, required this.imageUrl});
// }

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Information'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0), // Tăng padding 2 bên trái phải
          child: Column(
            children: [
              ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0), // Thêm borderRadius cho ảnh
                  child: Image.asset("assets/images/banner01.webp", width: 80, height: 80),
                ),
                title: Text('Printed Sleeveless Tiered Dress'),
                subtitle: Text('\$299.43', style: TextStyle(decoration: TextDecoration.lineThrough)),
                trailing: Text('\$534.33'),
              ),
              Divider(), // Thêm thanh ngăn cách
              ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0), // Thêm borderRadius cho ảnh
                  child: Image.asset("assets/images/banner01.webp", width: 80, height: 80),
                ),
                title: Text('Printed Sleeveless Tiered Dress'),
                subtitle: Text('\$299.43', style: TextStyle(decoration: TextDecoration.lineThrough)),
                trailing: Text('\$534.33'),
              ),
              Padding(
                  padding: const EdgeInsets.only(bottom: 20), 
                  child: Divider(),
                ),
              // Container(
              //   height: 300, // Đặt chiều cao cố định cho GoogleMap
              //   child: GoogleMap(
              //     initialCameraPosition: CameraPosition(
              //       target: LatLng(21.0288015, 105.7797143), 
              //       zoom: 17,
              //     ),
              //     onMapCreated: (GoogleMapController controller) {
              //       // Bạn có thể thêm các thiết lập bổ sung ở đây nếu cần
              //     },
              //   ),
              // ),
              // SizedBox(height: 16), // Thêm khoảng cách giữa GoogleMap và nút Hủy
              // ElevatedButton(
              //   onPressed: () {
              //     // Xử lý sự kiện khi nhấn nút Hủy
              //   },
              //   child: Text('Hủy'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class Product {
  final String name;
  final String imageUrl;

  Product({required this.name, required this.imageUrl});
}