// import 'dart:io'; // Cần import để sử dụng File
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class RegisterDesignerScreen extends StatefulWidget {
//   const RegisterDesignerScreen({super.key});

//   @override
//   _RegisterDesignerScreenState createState() => _RegisterDesignerScreenState();
// }

// class _RegisterDesignerScreenState extends State<RegisterDesignerScreen> {
//   final _formKey = GlobalKey<FormState>();
//   XFile? _cvFile;
//   List<XFile>? _projectImages = [];
//   final ImagePicker _picker = ImagePicker();

//   // Method to pick a CV image from device
//   Future<void> _pickCV() async {
//     final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//     setState(() {
//       _cvFile = pickedFile;
//     });
//   }

//   // Method to pick project images from device
//   Future<void> _pickProjectImages() async {
//     final List<XFile>? pickedFiles = await _picker.pickMultiImage();
//     setState(() {
//       if (pickedFiles != null) {
//         _projectImages = pickedFiles;
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Register as Designer'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               // Name field
//               TextFormField(
//                 decoration: const InputDecoration(labelText: 'Name'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your name';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16), // Add space between fields

//               // Email field
//               TextFormField(
//                 decoration: const InputDecoration(labelText: 'Email'),
//                 keyboardType: TextInputType.emailAddress,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your email';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16), // Add space between fields

//               // Phone field
//               TextFormField(
//                 decoration: const InputDecoration(labelText: 'Phone'),
//                 keyboardType: TextInputType.phone,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your phone number';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16), // Add space between fields

//               // Address field
//               TextFormField(
//                 decoration: const InputDecoration(labelText: 'Address'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your address';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 20), // Add space before upload CV button

//               // Upload CV button
//               TextButton.icon(
//                 icon: const Icon(Icons.upload_file),
//                 label: const Text("Upload CV"),
//                 onPressed: _pickCV,
//               ),

//               // Display CV image if selected
//               if (_cvFile != null) 
//                 Column(
//                   children: [
//                     const Text('CV uploaded:'),
//                     Image.file(
//                       File(_cvFile!.path),
//                       height: 200,
//                     ),
//                   ],
//                 ),
//               const SizedBox(height: 20), // Add space before upload project images button

//               // Upload project images button
//               TextButton.icon(
//                 icon: const Icon(Icons.image),
//                 label: const Text("Upload Project Images"),
//                 onPressed: _pickProjectImages,
//               ),

//               // Display selected project images
//               if (_projectImages != null && _projectImages!.isNotEmpty)
//                 Wrap(
//                   spacing: 10,
//                   children: _projectImages!.map((image) {
//                     return Image.file(
//                       File(image.path), 
//                       width: 100, 
//                       height: 100, 
//                       fit: BoxFit.cover
//                     );
//                   }).toList(),
//                 ),
//               const SizedBox(height: 20), // Add space before submit button

//               // Submit button
//               ElevatedButton(
//                 onPressed: () {
//                   if (_formKey.currentState!.validate()) {
//                     // Process form data
//                   }
//                 },
//                 child: const Text('Register'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class RegisterDesignerScreen extends StatefulWidget {
  const RegisterDesignerScreen({super.key});

  @override
  _RegisterDesignerScreenState createState() => _RegisterDesignerScreenState();
}

class _RegisterDesignerScreenState extends State<RegisterDesignerScreen> {
  final _formKey = GlobalKey<FormState>();
  XFile? _cvFile;
  List<XFile>? _projectImages = [];
  final ImagePicker _picker = ImagePicker();

  // Form fields
  String _username = '';
  String _email = '';
  String _phoneNumber = '';
  String _address = '';
  String _experience = '';
  String _projects = '';
  String _skills = '';
  String _education = '';
  String _certifications = '';

  // Method to pick a CV image from device
  Future<void> _pickCV() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _cvFile = pickedFile;
    });
  }

  // Method to pick project images from device
  Future<void> _pickProjectImages() async {
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();
    setState(() {
      if (pickedFiles != null) {
        _projectImages = pickedFiles;
      }
    });
  }

  // Method to submit form and upload data
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        var uri = Uri.parse('http://10.0.2.2:8080/api/v1/designer_profile/postProfile');

        var request = http.MultipartRequest('POST', uri)
          ..fields['designerProfileRequest'] = json.encode({
            "username": _username,
            "email": _email,
            "phoneNumber": _phoneNumber,
            "address": _address,
            "experience": _experience,
            "projects": _projects,
            "skills": _skills,
            "education": _education,
            "certifications": _certifications,
            "userId": 1,
            "imagesDesignDesignerIds": [],
          });

   
        // Attach CV file
        if (_cvFile != null) {
          request.files.add(await http.MultipartFile.fromPath('avatar', _cvFile!.path));
        }

        // Attach project images
        for (var image in _projectImages!) {
          request.files.add(await http.MultipartFile.fromPath('files', image.path));
        }

        // Send the request
        var response = await request.send();

        if (response.statusCode == 200) {
          // Handle successful response
          print("Profile successfully submitted.");
        } else {
          // Handle errors
          print("Failed to submit profile. Status code: ${response.statusCode}");
        }
      } catch (error) {
        print("Error submitting profile: $error");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register as Designer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Name field
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _username = value!;
                },
              ),
              const SizedBox(height: 16),

              // Email field
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value!;
                },
              ),
              const SizedBox(height: 16),

              // Phone field
              TextFormField(
                decoration: const InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _phoneNumber = value!;
                },
              ),
              const SizedBox(height: 16),

              // Address field
              TextFormField(
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
                onSaved: (value) {
                  _address = value!;
                },
              ),
              const SizedBox(height: 16),

              // Experience field
              TextFormField(
                decoration: const InputDecoration(labelText: 'Experience'),
                onSaved: (value) {
                  _experience = value!;
                },
              ),
              const SizedBox(height: 16),

              // Projects field
              TextFormField(
                decoration: const InputDecoration(labelText: 'Projects'),
                onSaved: (value) {
                  _projects = value!;
                },
              ),
              const SizedBox(height: 16),

              // Skills field
              TextFormField(
                decoration: const InputDecoration(labelText: 'Skills'),
                onSaved: (value) {
                  _skills = value!;
                },
              ),
              const SizedBox(height: 16),

              // Education field
              TextFormField(
                decoration: const InputDecoration(labelText: 'Education'),
                onSaved: (value) {
                  _education = value!;
                },
              ),
              const SizedBox(height: 16),

              // Certifications field
              TextFormField(
                decoration: const InputDecoration(labelText: 'Certifications'),
                onSaved: (value) {
                  _certifications = value!;
                },
              ),
              const SizedBox(height: 16),

              // Upload CV button
              TextButton.icon(
                icon: const Icon(Icons.upload_file),
                label: const Text("Upload CV"),
                onPressed: _pickCV,
              ),

              // Display CV image if selected
              if (_cvFile != null)
                Column(
                  children: [
                    const Text('CV uploaded:'),
                    Image.file(
                      File(_cvFile!.path),
                      height: 200,
                    ),
                  ],
                ),
              const SizedBox(height: 20),

              // Upload project images button
              TextButton.icon(
                icon: const Icon(Icons.image),
                label: const Text("Upload Project Images"),
                onPressed: _pickProjectImages,
              ),

              // Display selected project images
              if (_projectImages != null && _projectImages!.isNotEmpty)
                Wrap(
                  spacing: 10,
                  children: _projectImages!.map((image) {
                    return Image.file(
                      File(image.path),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    );
                  }).toList(),
                ),
              const SizedBox(height: 20),

              // Submit button
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
