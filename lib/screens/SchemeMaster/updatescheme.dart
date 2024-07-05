import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jaantradersindia/ApiHandler/apiWrapper.dart';
import 'package:jaantradersindia/ApiHandler/networkConstant.dart';
import 'package:jaantradersindia/controllers/authController.dart';

class UpdateSchemePage extends StatefulWidget {
  final Map<String, dynamic> schemeCurrentdata;

  const UpdateSchemePage({Key? key, required this.schemeCurrentdata})
      : super(key: key);

  @override
  _UpdateSchemePageState createState() => _UpdateSchemePageState();
}

class _UpdateSchemePageState extends State<UpdateSchemePage> {
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

  Future<void> handleUpdateScheme(BuildContext context) async {
    _showLoaderDialog(context);

    var params = {
      "SchemeName": _schemeName.text.trim().toString(),
      "TotalPointsReq": _totalPointsReqController.text.trim().toString(),
      "ValidFrom": _validFromController.text.trim().toString(),
      "ValidTo": _validToController.text.trim().toString(),
      "Role": _selectedRole,
      "SchemeDesc": _desController.text.trim().toString(),
      "SchemeID": widget.schemeCurrentdata["schemeId"]
    };

    try {
      final ApiResponse? result = await AuthControllers.post(
          NetworkConstantsUtil.UpdateScheme, params);

      Navigator.pop(context);

      if (result?.success == "true") {
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
        _clearFields();
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
      Navigator.pop(context);
      print("Error during update scheme: $e");
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

  void _clearFields() {
    _schemeName.clear();
    _totalPointsReqController.clear();
    _validFromController.clear();
    _validToController.clear();
    _desController.clear();
    _selectedRole = null;
  }

  @override
  void initState() {
    super.initState();
    AuthControllers.readCredentialData("UserID").then((result) {
      setState(() {
        _userId = result!;
      });
    });

    AuthControllers.readCredentialData("CompanyID").then((result) {
      setState(() {
        _companyId = result!;
      });
    });

    AuthControllers.readCredentialData("UserRole").then((result) {
      setState(() {
        _role = result!;
      });
    });

    // Set initial values for the TextEditingControllers
    _schemeName.text = widget.schemeCurrentdata["schemeName"];
    _validFromController.text = widget.schemeCurrentdata["validFrom"];
    _validToController.text = widget.schemeCurrentdata["validTo"];
    _totalPointsReqController.text = widget.schemeCurrentdata["totalPoints"];
    _desController.text = widget.schemeCurrentdata["gift"];
    _selectedRole = widget.schemeCurrentdata["schemeFor"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Scheme'),
      ),
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
                TextFormField(
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
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _totalPointsReqController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Total Points required for gift *',
                          hintText: 'Points required for gifts/scheme',
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
                    SizedBox(width: 20),
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
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
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
                    SizedBox(width: 20),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedRole,
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
                  ],
                ),
                SizedBox(height: 20),
                TextFormField(
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
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        handleUpdateScheme(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      backgroundColor: Colors.purple,
                    ),
                    child: Text(
                      'UPDATE SCHEME',
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
