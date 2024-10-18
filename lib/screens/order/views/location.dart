import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPage extends StatelessWidget {
  const LocationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location'),
      ),
      body: Center(
        child: Container(
          height: 600,
          width: double.infinity, // Để bản đồ rộng theo chiều ngang
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(21.0288015, 105.7797143), // Vị trí tại Hà Nội
              zoom: 17, // Mức zoom
            ),
            onMapCreated: (GoogleMapController controller) {
              // Xử lý khi bản đồ đã được tạo xong (nếu cần)
            },
          ),
        ),
      ),
    );
  }
}

