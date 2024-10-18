

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/screens/checkout/views/payment.dart';
import 'package:shop/services/address_service.dart';

class AddressesScreen extends StatefulWidget {
  const AddressesScreen({super.key});

  @override
  _AddressesScreenState createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressRegionController = TextEditingController();
  final _addressDetailController = TextEditingController();
  bool _isDefault = false;
  final AddressService _addressService = AddressService();
  int? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getInt('userId');
    });
  }

  void _submitAddress() async {
    if (_userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to post an address order')),
      );
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      final addressData = {
        "username": _usernameController.text,
        "phone": _phoneController.text,
        "addressRegion": _addressRegionController.text,
        "addressDetail": _addressDetailController.text,
        "isDefault": _isDefault.toString(),
        "userId": _userId
      };

      try {
        await _addressService.postAddressOrder(addressData);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Address order posted successfully')),
        );
        Navigator.push(context, MaterialPageRoute(builder: (context) => const PaymentScreen()));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to post address order: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Address"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Contact"),
              const SizedBox(height: 10),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: "Full Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: "Phone Number",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              const Text("Address"),
              const SizedBox(height: 10),
              TextFormField(
                controller: _addressRegionController,
                decoration: const InputDecoration(
                  labelText: "City/Province, District, Ward",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an address region';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _addressDetailController,
                decoration: const InputDecoration(
                  labelText: "Street Name, Building, House Number",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an address detail';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
                const Row(
                  children: [
                    Icon(Icons.settings, color: Color.fromARGB(255, 121, 121, 121),),
                    SizedBox(width: 8), // Add some space between the icon and the text
                    Text("Settings", 
                    style: TextStyle(
                      // color: const Color.fromARGB(255, 169, 169, 169),
                      fontSize: 16,
                      // fontWeight: FontWeight.bold,
                    )
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Set as default address"),
                  Switch(
                    value: _isDefault,
                    onChanged: (value) {
                      setState(() {
                        _isDefault = value;
                      });
                    },
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.only(top: 20)),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitAddress,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    ),
                    child: Text(
                      "COMPLETE",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}