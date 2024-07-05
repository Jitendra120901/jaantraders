import 'package:flutter/material.dart';
import 'package:jaantradersindia/ApiHandler/apiWrapper.dart';
import 'package:jaantradersindia/ApiHandler/networkConstant.dart';
import 'package:jaantradersindia/controllers/authController.dart';

class UpdateProductScreen extends StatefulWidget {
  final Map<String, dynamic> productpointData;

  const UpdateProductScreen({Key? key, required this.productpointData})
      : super(key: key);

  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  TextEditingController _productNameController = TextEditingController();
  TextEditingController _productPointController = TextEditingController();
  String? _selectedRole;
  String _userId = ""; // Set your user ID here
  String _companyId = ""; // Set your company ID here

  Future<void> handleAddProducts(BuildContext context) async {
    _showLoaderDialog(context);

    var params = {
      "userid": _userId,
      "ProductName": _productNameController.text.toString(),
      "ProductPoint": _productPointController.text.toString(),
      "Role": _selectedRole,
      "ProductID": widget.productpointData["productid"]
    };

    try {
      // Await the result of the login API call
      final ApiResponse? result = await AuthControllers.post(
          NetworkConstantsUtil.UpdateProduct, params);

      Navigator.pop(context);

      if (result?.success == "true") {
        print(
            "post api data after api call =====================> ${result?.success}");
        final data = result?.data;

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
        // Clear all fields
        _productNameController.clear();
        _productPointController.clear();
        setState(() {
          _selectedRole = null;
        });
        Navigator.pop(context);
      } else {
        print(
            "post api data after api call on error=====================> ${result?.success}");
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
      print("Error during login: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred. Please try again.'),
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
                    "Processing.....",
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

  @override
  void initState() {
    super.initState();
    var userid = AuthControllers.readCredentialData("UserID");

    var companyID = AuthControllers.readCredentialData("CompanyID");
    var role = AuthControllers.readCredentialData("UserRole");
    userid.then((result) {
      print("user id read in add product screen ===========> $result");
      setState(() {
        _userId = result!;
      });
    });
    companyID.then((result) {
      setState(() {
        _companyId = result!;
      });

      _productNameController =
          TextEditingController(text: widget.productpointData["ProductName"]);
      _productPointController =
          TextEditingController(text: widget.productpointData["ProductPoints"]);
      _selectedRole =
          widget.productpointData["AssignedFor"]; // Initialize selected role
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Update Product",
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
          ),
        ),
        backgroundColor: Colors.purple,
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.keyboard_arrow_left)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Product Points',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _productNameController,
              decoration: InputDecoration(
                labelText: 'Product Name',
                border: OutlineInputBorder(),
                hintText: 'Enter Product Name',
                suffixIcon: Icon(Icons.edit),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _productPointController,
              decoration: InputDecoration(
                labelText: 'Per Bag Product Point',
                border: OutlineInputBorder(),
                hintText:
                    'Enter Product Points per bag or Every Single Quantity',
                suffixIcon: Icon(Icons.point_of_sale),
              ),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Choose Role',
                border: OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem(
                  child: Text('Admin'),
                  value: 'Admin',
                ),
                DropdownMenuItem(
                  child: Text('Distributor'),
                  value: 'Distributor',
                ),
                DropdownMenuItem(
                  child: Text('Mistri'),
                  value: 'Mistri',
                ),
                DropdownMenuItem(
                  child: Text('Retailer'),
                  value: 'Retailer',
                ),
                // Add more roles as needed
              ],
              onChanged: (value) {
                setState(() {
                  _selectedRole = value;
                });
              },
              value: _selectedRole,
            ),
            SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  handleAddProducts(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'UPDATE PRODUCT POINT',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
