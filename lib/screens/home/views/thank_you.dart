import 'package:flutter/material.dart';
import 'package:shop/entry_point.dart';
import 'package:shop/route/route_constants.dart';
import 'package:shop/screens/home/views/home_screen.dart';



class TestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ThankYouPage(),
    );
  }
}

class ThankYouPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              color: Colors.blue,
              size: 100,
            ),
            SizedBox(height: 30),
            Text(
              'Thank You!',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 69, 69, 69),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Your order has been purchased successfully!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            // ElevatedButton(
            //   onPressed: () {
            //      Navigator.push(
            //           context,
            //           MaterialPageRoute(builder: (context) => HomeScreen()),
            //       );
            //   },
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.blue, 
            //     padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(10),
            //     ),
            //   ),
            //   child: Text(
            //     'Go Back',
            //     style: TextStyle(fontSize: 18, color: Colors.white),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
