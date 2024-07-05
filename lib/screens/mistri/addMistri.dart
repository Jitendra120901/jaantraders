import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:jaantradersindia/ApiHandler/apiWrapper.dart';
import 'package:jaantradersindia/ApiHandler/networkConstant.dart';
import 'package:jaantradersindia/controllers/authController.dart';

class AddNewMistriScreen extends StatefulWidget {
  @override
  State<AddNewMistriScreen> createState() => _AddNewMistriScreenState();
}

class _AddNewMistriScreenState extends State<AddNewMistriScreen> {
  String? _base64Image;

  // TextEditingController for each field
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  Future<void> handleAddNewMistri(BuildContext context) async {
    _showLoaderDialog(context);

    var params = {
      "Name": _nameController.text,
      "Phone": _phoneController.text,
      "Email": _emailController.text,
      "image": _base64Image
    };

    try {
      final ApiResponse? result = await AuthControllers.post(
          NetworkConstantsUtil.addMistri, params);

      Navigator.pop(context);

      if (result?.success == "true") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${result?.message}',
              style: TextStyle(color: Colors.black),
            ),
            duration: Duration(seconds: 4),
            backgroundColor: Colors.greenAccent,
          ),
        );
        // Clear all fields
        _clearAllFields();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${result?.message}.'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred. Please try again.'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  void _clearAllFields() {
    _nameController.clear();
    _phoneController.clear();
    _companyController.clear();
    _emailController.clear();
    setState(() {
      _base64Image = null;
    });
  }

  void _showLoaderDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Center(
            child: Container(
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Processing...",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void imagePickerSource(source) async {
    final XFile? image = await ImagePicker().pickImage(source: source);

    if (image != null) {
      image_cropper(image);
    }
  }

  void image_cropper(XFile image) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: image.path,
      compressQuality: 60,
    );
    if (croppedImage != null) {
      final bytes = await File(croppedImage.path).readAsBytes();
      setState(() {
        _base64Image = base64Encode(bytes);
      });
    }
  }

  void showImagePickerOption() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            ListTile(
              title: Text("Select Profile Picture"),
            ),
            ListTile(
              onTap: () async {
                Navigator.pop(context);
                imagePickerSource(ImageSource.gallery);
              },
              leading: Icon(Icons.image),
              title: Text("Select Image from Album"),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                imagePickerSource(ImageSource.camera);
              },
              leading: Icon(Icons.camera_alt),
              title: Text("Take picture from Camera"),
            )
          ]),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Mistri Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(_nameController, 'Name', 'Enter Mistri Name'),
                    const SizedBox(height: 20),
                    _buildTextField(_phoneController, 'Phone', 'Enter Mistri Contact'),
                    const SizedBox(height: 20),
                    _buildTextField(_companyController, 'Choose Company', 'cmpny_112200564'),
                    const SizedBox(height: 20),
                    _buildTextField(_emailController, 'Email', 'Enter Mistri Email'),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        showImagePickerOption();
                      },
                      icon: Icon(Icons.image),
                      label: const Text('Choose File'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                      ),
                    ),
                    if (_base64Image != null) ...[
                      const SizedBox(height: 20),
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Image.memory(base64Decode(_base64Image!)),
                          IconButton(
                            icon: Icon(Icons.cancel, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                _base64Image = null;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        handleAddNewMistri(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                      ),
                      child: const Text(
                        'ADD NEW MISTRI',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, String hint) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(),
      ),
    );
  }
}
