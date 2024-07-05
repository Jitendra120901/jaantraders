import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jaantradersindia/ApiHandler/apiWrapper.dart';
import 'package:jaantradersindia/ApiHandler/networkConstant.dart';
import 'package:jaantradersindia/controllers/authController.dart';

class AddSchemePage extends StatefulWidget {
  @override
  _AddSchemePageState createState() => _AddSchemePageState();
}

class _AddSchemePageState extends State<AddSchemePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _validFromController = TextEditingController();
  final TextEditingController _validToController = TextEditingController();
  final TextEditingController _schemeName = TextEditingController();
  final TextEditingController _desController = TextEditingController();
  final TextEditingController _totalPointsReqController =
      TextEditingController();
  String? _selectedRole;

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        controller.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  String? _role;
  String _userId = ""; // Set your user ID here
  String _companyId = ""; // Set your company ID here

  Future<void> handleAddNewSchemes(BuildContext context) async {
    _showLoaderDialog(context);

    var params = {
      "userid": _userId,
      "SchemeName": _schemeName.text.trim().toString(),
      "TotalPointsReq": _totalPointsReqController.text.trim().toString(),
      "ValidFrom": _validFromController.text.trim().toString(),
      "ValidTo": _validToController.text.trim().toString(),
      "Role": _selectedRole,
      "SchemeDesc": _desController.text.trim().toString(),
      "CompanyID": _companyId
    };

    try {
      // Await the result of the login API call
      final ApiResponse? result = await AuthControllers.post(
          NetworkConstantsUtil.addNewScheme, params);

      Navigator.pop(context);

      if (result?.success == "true") {
        print(
            "post api data after api call =====================> ${result?.success}");
        final data = result?.data;

        if (data != null && data.isNotEmpty) {
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
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${result?.message}'),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
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
    });
    role.then((result) {
      setState(() {
        _role = result!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Scheme / Gifts Information',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _schemeName,
                        decoration: InputDecoration(
                          labelText: 'Scheme Name *',
                          hintText: 'Enter Scheme Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter scheme name';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: TextFormField(
                        controller: _totalPointsReqController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Total Points required for gift *',
                          hintText: 'points required for gifts/scheme',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter points required';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
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
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: TextFormField(
                        controller: _validToController,
                        decoration: InputDecoration(
                          labelText: 'Valid To *',
                          hintText: 'dd-mm-yyyy',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: () =>
                                _selectDate(context, _validToController),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please select a date';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Choose Scheme For *',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        items: <String>['Mistri', 'Retailer', 'Distributor']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedRole = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a role';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: TextFormField(
                        controller: _desController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Scheme Description *',
                          hintText: 'Enter Scheme Details',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter scheme details';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Process data.
                      }
                      handleAddNewSchemes(context);
                    },
                    style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        backgroundColor: Colors.purple),
                    child: Text(
                      'ADD SCHEME',
                      style: TextStyle(fontSize: 16, color: Colors.white),
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
