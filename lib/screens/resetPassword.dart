import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jaantradersindia/ApiHandler/networkConstant.dart';
import 'dart:convert';

import 'package:jaantradersindia/controllers/authController.dart';

class UserInputFormPage extends StatefulWidget {
  final userId;

  const UserInputFormPage({Key? key, this.userId}) : super(key: key);
  @override
  _UserInputFormPageState createState() => _UserInputFormPageState();
}

class _UserInputFormPageState extends State<UserInputFormPage> {
  final _formKey = GlobalKey<FormState>();
  var _useridController = TextEditingController();
  final _userotpController = TextEditingController();
  final _newpassController = TextEditingController();
  final _renewpassController = TextEditingController();


 @override
  void initState() {
    super.initState();
    _useridController = TextEditingController(text: widget.userId);
  }
  @override
  void dispose() {
    _useridController.dispose();
    _userotpController.dispose();
    _newpassController.dispose();
    _renewpassController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final params = {
        "userid": _useridController.text.trim(),
        "userotp": _userotpController.text.trim(),
        "newpass": _newpassController.text.trim(),
        "renewpass": _renewpassController.text.trim(),
      };

      print(params);

      try {
        final response = await AuthControllers.resetPass(NetworkConstantsUtil.resetPass, params);

        if (response?.success=="true") {
           ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Your password has reset'),
                  duration: Duration(seconds: 2),
                  backgroundColor: Colors.greenAccent,
                ),
              );
         Navigator.popUntil(context,(route) {
           return route.isFirst;
         }, );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Something went wrong . please try again!!'),
                  duration: Duration(seconds: 2),
                  backgroundColor: Colors.redAccent,
                ),
              );
        }
      } catch (e) {
        print('Error: $e');
        // Handle network or other errors here
      }
    }
  }

  String? validatePasswords(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please re-enter the new password';
    }
    if (value != _newpassController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10.0,
                  spreadRadius: 2.0,
                ),
              ],
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/logo.png', // Make sure to add your logo to the assets folder and update the path
                      height: 50,
                    ),
                    SizedBox(width: 8),
                  ],
                ),
                SizedBox(height: 24),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _useridController,
                        decoration: InputDecoration(
                          labelText: 'User ID',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your User ID';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        controller: _userotpController,
                        decoration: InputDecoration(
                          labelText: 'User OTP',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your OTP';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _newpassController,
                        decoration: InputDecoration(
                          labelText: 'New Password',
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a new password';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _renewpassController,
                        decoration: InputDecoration(
                          labelText: 'Re-enter New Password',
                        ),
                        obscureText: true,
                        validator: validatePasswords,
                      ),
                      SizedBox(height: 24),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          padding: EdgeInsets.symmetric(
                              horizontal: 32, vertical: 12),
                        ),
                        onPressed: _submitForm,
                        child: Text(
                          'Submit',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
