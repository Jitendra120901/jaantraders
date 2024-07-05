import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jaantradersindia/ApiHandler/apiWrapper.dart';
import 'package:jaantradersindia/ApiHandler/networkConstant.dart';
import 'package:jaantradersindia/controllers/authController.dart';

class AllocationScreen extends StatefulWidget {
  @override
  State<AllocationScreen> createState() => _AllocationScreenState();
}

class _AllocationScreenState extends State<AllocationScreen> {
  final TextEditingController _validFromController = TextEditingController();
  final TextEditingController _bagQuantityController = TextEditingController();
  final TextEditingController _totalPointsController = TextEditingController();
  final TextEditingController _singleProductPointController = TextEditingController();

  String? _selectedRole;
  String _userId = ""; // Set your user ID here
  String _companyId = ""; // Set your company ID here

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
    });
    role.then((result) {
      setState(() {
        _selectedRole = result!;
      });
    });

    _singleProductPointController.addListener(_calculateTotalPoints);
    _bagQuantityController.addListener(_calculateTotalPoints);
  }

  void _calculateTotalPoints() {
    final perBagPoint = double.tryParse(_singleProductPointController.text) ?? 0;
    final bagQuantity = double.tryParse(_bagQuantityController.text) ?? 0;
    final totalPoints = perBagPoint * bagQuantity;
    _totalPointsController.text = totalPoints.toStringAsFixed(2);
  }

  @override
  void dispose() {
    _validFromController.dispose();
    _bagQuantityController.dispose();
    _totalPointsController.dispose();
    _singleProductPointController.dispose();
    super.dispose();
  }

  Future<void> handleAddProducts(BuildContext context) async {
    _showLoaderDialog(context);

    var params = {
      "AllocationTo": "usr_663368543bd16-Mistri",
      "AllocationProduct": "prd_1714645562",
      "AllocationDate": _validFromController.text,
      "SingleProductPoint": _singleProductPointController.text,
      "BagQuantity": _bagQuantityController.text,
      "TotalPointsEarned": _totalPointsController.text,
      "userID": _userId,
      "userRole": _selectedRole ?? "",
      "CompanyID": _companyId
    };

    try {
      final ApiResponse? result = await AuthControllers.post(
          NetworkConstantsUtil.addAllocation, params);

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
          )
        );

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

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Allocation Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Choose Allocation For *'),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            items: [
                              DropdownMenuItem(
                                value: 'option1',
                                child: Text('Select Allocation for'),
                              ),
                            ],
                            onChanged: (value) {},
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text('Choose Product *'),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            items: [
                              DropdownMenuItem(
                                value: 'option1',
                                child: Text('First Choose Allocation For'),
                              ),
                            ],
                            onChanged: (value) {},
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text('Allocation Date *'),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _validFromController,
                            decoration: InputDecoration(
                              labelText: 'Valid From *',
                              hintText: 'dd-mm-yyyy',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.calendar_today),
                                onPressed: () =>
                                    _selectDate(context, _validFromController),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please select a date';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          Text('Per Bag Point'),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _singleProductPointController,
                            decoration: InputDecoration(
                              hintText: 'First Choose Product',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text('Bag Quantity *'),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _bagQuantityController,
                            decoration: InputDecoration(
                              hintText: 'Enter Bag Quantity',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text('Total Points *'),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _totalPointsController,
                            readOnly: true,
                            decoration: InputDecoration(
                              hintText: 'First Choose Product and Enter Quantity',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            handleAddProducts(context);
                          },
                          icon: Icon(
                            Icons.check_circle,
                            color: Colors.white,
                          ),
                          label: Text(
                            'ALLOCATE NOW',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            padding: EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
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
