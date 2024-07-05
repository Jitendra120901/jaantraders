import 'package:flutter/material.dart';
import 'package:jaantradersindia/ApiHandler/apiWrapper.dart';
import 'package:jaantradersindia/controllers/authController.dart';
import 'package:jaantradersindia/screens/dashboardScreen.dart';
import 'package:jaantradersindia/screens/forgetPasswordScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  Future<void> verifyEnteredData(BuildContext context) async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      _showLoaderDialog(context);

      var params = {
        "userdet": emailController.text.trim().toString(),
        "passkey": passwordController.text.trim().toString()
      };

      try {
        // Await the result of the login API call
        final ApiResponse? result =
            await AuthControllers.post("data/loginVerify.php", params);
        Navigator.pop(context);

        if (result?.success == "true") {
          print(
              "post api data after api call =====================> ${result?.success}");
          // Accessing specific fields in the response
          final data = result?.data;

          // Navigate to DashboardScreen if login is successful
          if (data != null && data.isNotEmpty) {
      AuthControllers.saveCredential("UserID", data[0]['UserID']);
      AuthControllers.saveCredential("Name", data[0]['Name']);
      AuthControllers.saveCredential("UserRole", data[0]['UserRole']);
      AuthControllers.saveCredential("CompanyID", data[0]['CompanyID']);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DashboardScreen(
                  userId: data[0]['UserID'],
                  userIs: data[0]['Name'],
                  userRole: data[0]['UserRole'],
                ),
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
              content: Text('Login failed. ${result?.message}.'),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      } catch (e) {
        // Handle any errors that occur during the API call
        Navigator.pop(context);
        print("Error during login: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred. Please try again.'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } else {
      // Show error message if fields are empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Email and password cannot be empty'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
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
                    "Logging in...",
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

  var isEncrypted = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset(
                  'assets/logo.png', // Path to your logo
                  height: 100,
                ),
                SizedBox(height: 20),
                // Welcome Text with Highlight
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(text: 'Welcome to '),
                      TextSpan(
                        text: 'Common',
                        style: TextStyle(
                          backgroundColor: Colors.green,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(text: ' Login System'),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                // Subtitle Text
                Text(
                  'Please sign-in to your account and start the adventure',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 30),
                // Email/Username Field
                TextField(
                  keyboardType: TextInputType.text,
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email or Username',
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(color: Colors.deepPurple),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Password Field
                TextField(
                  controller: passwordController,
                  obscureText: isEncrypted,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(color: Colors.deepPurple),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple),
                    ),
                    suffixIcon: IconButton(
                      icon: isEncrypted
                          ? Icon(Icons.visibility_off)
                          : Icon(Icons.visibility),
                      onPressed: () {
                        setState(() {
                          isEncrypted = !isEncrypted;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 10),
                // Forgot Password Link
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return ForgotPasswordScreen();
                        },
                      ));
                    },
                    child: Text('Forgot Password?'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.deepPurple,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Login Button
                ElevatedButton(
                  onPressed: () {
                    // Check if email and password are not empty
                    verifyEnteredData(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple, // Button color
                    minimumSize:
                        Size(double.infinity, 50), // Button width and height
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    'Login Now',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
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
