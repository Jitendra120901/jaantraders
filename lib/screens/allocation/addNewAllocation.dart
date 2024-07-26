import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jaantradersindia/ApiHandler/apiWrapper.dart';
import 'package:jaantradersindia/ApiHandler/networkConstant.dart';
import 'package:jaantradersindia/controllers/authController.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  String _userId = "";
  String _companyId = "";
  String? _selectedAllocationFor;
  String? _selectedRoleIdAllocationFor;
  String? _selectedProduct;
   String currentUserRole="";

  List<Map<String, dynamic>> rolesData = [];
  List<Map<String, dynamic>> productData = [];

void getUserData()async{
  SharedPreferences prefs = await SharedPreferences.getInstance();

    var userid = await prefs.getString("UserID");;
    var companyID =await prefs.getString("CompanyID");
    var role = await prefs.getString("UserRole");

    setState(() {
      _userId = userid.toString();
      _companyId = companyID.toString();
      currentUserRole = role.toString();
    });
}

  @override
  void initState() {
    super.initState();
      
getUserData();
    _singleProductPointController.addListener(_calculateTotalPoints);
    _bagQuantityController.addListener(_calculateTotalPoints);

    handleGetRolesList(context);  // Fetch the roles list when the screen is initialized
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
  AuthControllers.showLoaderDialog(context, "Loading...");

  // Await the Future values
  String? userId = await _userId;
  String? selectedRole = await _selectedRole;
  String? companyId = await _companyId;

  // Convert nullable values to non-null strings with default values if null
  var params = {
    "AllocationRole": _selectedAllocationFor ?? "",
    "AllocationTo":_selectedRoleIdAllocationFor??"",
    "AllocationProduct": _selectedProduct ?? "",
    "AllocationDate": _validFromController.text,
    "SingleProductPoint": _singleProductPointController.text,
    "BagQuantity": _bagQuantityController.text,
    "TotalPointsEarned": _totalPointsController.text,
    "userID": userId ?? "", // Ensure it's not null
    "userRole": currentUserRole ?? "",
    "CompanyID": companyId ?? "",
  };

  try {
    final ApiResponse? result = await AuthControllers.post(
        NetworkConstantsUtil.addAllocation, params);

    Navigator.pop(context);

    if (result?.success == "true") {
      print("post api data after api call =====================> ${result?.success}");
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
      print("post api data after api call on error=====================> ${result?.success}");
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



  Future<void> handleGetRolesList(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var params = {
      "Role": await prefs.getString("UserRole").toString()
    };

    try {
      final ApiResponse? result = await AuthControllers.post(NetworkConstantsUtil.getUsersByRole, params);

      print("API Response: ${result?.data}");

      if (result?.success == "true" && result?.data != null) {
        List<Map<String, dynamic>> roles = List<Map<String, dynamic>>.from(result?.data);

        setState(() {
          rolesData = roles;
          _selectedAllocationFor = null; // Clear selected values
          _selectedRole = null; // Clear selected values
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

  Future<void> GetProductListBasisOFUser(BuildContext context, String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var params = {
      "Role": _selectedAllocationFor
    };

    try {
      final ApiResponse? result = await AuthControllers.post(NetworkConstantsUtil.getUsersByProduct, params);

      print("API Response: ${result?.data}");

      if (result?.success == "true" && result?.data != null) {
        List<Map<String, dynamic>> products = List<Map<String, dynamic>>.from(result?.data);

        setState(() {
          productData = products;
          _selectedProduct = null; // Clear selected values if needed
        });

        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text(
        //       '${result?.message}',
        //       style: TextStyle(color: Colors.black),
        //     ),
        //     duration: Duration(seconds: 2),
        //     backgroundColor: Colors.greenAccent,
        //   ),
        // );
        Navigator.pop(context);
      } else {
         Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${result?.message}'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (e) {
       Navigator.pop(context);
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

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
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
                            items: rolesData.map((role) {
                              return DropdownMenuItem<String>(
                                value: role['UserID'].toString()+" "+role['Name'],
                                child: Text(role['Name'].toString()),
                              );
                            }).toList(),
                            onChanged: (value) {
                              AuthControllers.showLoaderDialog(context, "Loading...");
                              print("selected user ======== ${value.toString().split(" ")[0]}");
                              setState(() {

                                _selectedRoleIdAllocationFor=value.toString().split(" ")[0];
                                _selectedAllocationFor=value.toString().split(" ")[1];

                              });
                              
                              if (value != null) {
                                GetProductListBasisOFUser(context, value);
                                
                              }
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text('Choose Product *'),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: _selectedProduct,
                            items: productData.map((product) {
                              return DropdownMenuItem<String>(
                                value: product['ProductID'].toString(),
                                child: Text(product['ProductName'].toString()),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedProduct = value;
                              });
                            },
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
                            keyboardType: TextInputType.number,
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
                            keyboardType: TextInputType.number,
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
                            keyboardType: TextInputType.number,
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
