import 'package:flutter/material.dart';
import 'package:jaantradersindia/controllers/authController.dart';
import 'package:jaantradersindia/screens/dashboardScreen.dart';
import 'package:jaantradersindia/screens/loginScreen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jaantraders',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder<String?>(
        future: _checkUserID(),
        builder: (context, snapshot) {
          // Check if the future has completed
          if (snapshot.connectionState == ConnectionState.done) {
            // Check if there's a user ID
            if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
              return DashboardScreen(); // Navigate to Dashboard if user ID is found
            } else {
              return LoginScreen(); // Navigate to Login if no user ID is found
            }
          } else {
            // Show a loading indicator while waiting for the future to complete
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Future<String?> _checkUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('UserID');
  }
}

class AuthControllers {
  static Future<String?> readCredentialData(String keyName) async {
    final flutterSecureStorage = FlutterSecureStorage();
    var readDataFound = await flutterSecureStorage.read(key: keyName);
    return readDataFound;
  }
}
