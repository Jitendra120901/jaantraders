import 'package:flutter/material.dart';
import 'package:jaantradersindia/ApiHandler/apiWrapper.dart';
import 'package:jaantradersindia/ApiHandler/networkConstant.dart';
import 'package:jaantradersindia/controllers/authController.dart';
import 'package:jaantradersindia/screens/resetPassword.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
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
                    "Preoccessing.....",
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

  Future<void> verifyEnteredData(BuildContext context) async {
    if (emailController.text.isNotEmpty) {
      _showLoaderDialog(context);

      var params = {"usermail": emailController.text.trim().toString()};

      try {
        // Await the result of the login API call
        final ApiResponse? result = await AuthControllers.forgetPasswod(
            NetworkConstantsUtil.forgetPasswod, params);
        Navigator.pop(context);
        // Ensure result is not null and print the result from the API call
        if (result?.success == "true") {
          print(
              "post api data after api call =====================> ${result?.data[0]['UserID']}");
          // Accessing specific fields in the response
          final data = result?.data;

          // Navigate to DashboardScreen if login is successful
          if (data != null && data.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserInputFormPage(userId: data[0]["UserID"],)
              ),
            );

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '${result?.message}', // Updated to access the correct index and key
                  style: TextStyle(color: Colors.black),
                ),
                duration: Duration(seconds: 2),
                backgroundColor: Colors.greenAccent,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Invalid response from the server.'),
                duration: Duration(seconds: 2),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        } else {
          print(
              "post api data after api call on error=====================> ${result?.success}");
          // Show error message if login failed
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(' ${result?.message}.'),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      } catch (e) {
        // Handle any errors that occur during the API call
        Navigator.pop(context);
        print("Error : $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred. Please try again.'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                  Text(
                    'Forgot Password?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Enter your email and we\'ll send you instructions to reset your password',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 24),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {verifyEnteredData(context);},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    child: Text(
                      'Send Password Reset Link',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      // Navigate back to login screen
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Back to login',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.purple,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
