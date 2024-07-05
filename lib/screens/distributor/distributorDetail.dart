import 'package:flutter/material.dart';
import 'package:jaantradersindia/ApiHandler/apiWrapper.dart';
import 'package:jaantradersindia/ApiHandler/networkConstant.dart';
import 'package:jaantradersindia/controllers/authController.dart';
import 'package:jaantradersindia/screens/distributor/updateDistributor.dart';

class DistributorDetailScreen extends StatefulWidget {
  final String DistributorId;

  const DistributorDetailScreen({Key? key, required this.DistributorId})
      : super(key: key);
  @override
  State<DistributorDetailScreen> createState() =>
      _DistributorDetailScreenState();
}

class _DistributorDetailScreenState extends State<DistributorDetailScreen> {
  Map<String, String> userData = {}; // Updated to hold API response data

  Future<void> handleGetDetail(BuildContext context) async {
    var params = {"edituserid": widget.DistributorId};

    try {
      final ApiResponse? result = await AuthControllers.post(
          NetworkConstantsUtil.distributorDetail, params);

      print("API Response for distributor detail: ${result?.data}");

      if (result?.success == "true" && result?.data != null) {
        setState(() {
          // Update userData with API response data
          userData = {
            "sr": result!.data![0]["sr"],
            "Name": result.data![0]["Name"],
            "Email": result.data![0]["Email"],
            "Phone": result.data![0]["Phone"],
            "Photo": result.data![0]["Photo"],
            "Status": result.data![0]["Status"],
          };
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${result?.message}',
              style: TextStyle(color: Colors.black),
            ),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.greenAccent,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${result?.message}'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (e) {
      print("Error during API call: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred. Please try again.'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  void handleNavigateToEditScreen() {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return UpdateDistributorScreen(schemeCurrentdata: {
          "Name": userData['Name'],
          "email": userData['Email'],
          "Phone": userData['Phone'],
          "distributorId":userData['Status']
        });
      },
    ));
  }

  @override
  void initState() {
    super.initState();
    handleGetDetail(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Distributor Detail',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
          ),
        ),
        backgroundColor: Colors.purple,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.keyboard_arrow_left, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),

            // Profile Picture
            CircleAvatar(
              radius: 80,
              backgroundColor: Colors.purple,
              backgroundImage: NetworkImage(userData['Photo'] ?? ''),
              onBackgroundImageError: (error, stackTrace) {
                // Handle error
                print('Error loading image: $error');
              },
              child: userData['Photo'] == null || userData['Photo']!.isEmpty
                  ? Icon(
                      Icons.person,
                      size: 80,
                      color: Colors.grey[300],
                    )
                  : null,
            ),

            SizedBox(height: 20),

            // User Name
            Text(
              userData['Name'] ?? '',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 10),

            // Email
            ListTile(
              leading: Icon(Icons.email, color: Colors.purple),
              title: Text(
                userData['Email'] ?? '',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[800],
                ),
              ),
            ),

            Divider(color: Colors.grey[300]), // Divider

            // Phone Number
            ListTile(
              leading: Icon(Icons.phone, color: Colors.purple),
              title: Text(
                userData['Phone'] ?? '',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[800],
                ),
              ),
            ),

            Divider(color: Colors.grey[300]), // Divider

            SizedBox(height: 20),

            // Status
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color:
                    userData['Status'] == 'Active' ? Colors.green : Colors.red,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'UserId: ${userData['Status'] ?? ''}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),

            SizedBox(height: 40),

            // Edit Profile Button
            ElevatedButton.icon(
              onPressed: () {
                handleNavigateToEditScreen();
              },
              icon: Icon(Icons.edit, color: Colors.white),
              label: Text(
                "Edit Profile",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
