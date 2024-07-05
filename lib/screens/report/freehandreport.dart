import 'package:flutter/material.dart';
import 'package:jaantradersindia/ApiHandler/apiWrapper.dart';
import 'package:jaantradersindia/ApiHandler/networkConstant.dart';
import 'package:jaantradersindia/controllers/authController.dart';

class FreehandReportsScreen extends StatefulWidget {
  @override
  State<FreehandReportsScreen> createState() => _FreehandReportsScreenState();
}

class _FreehandReportsScreenState extends State<FreehandReportsScreen> {
  String? _role;
  String? _userId;
  List<Map<String, dynamic>> rolesData = [];
  List<Map<String, dynamic>> reportData = [];
  TextEditingController _validFromController = TextEditingController();
  TextEditingController _validToController = TextEditingController();
  TextEditingController _singleProductPointController = TextEditingController();
  String? _selectedAllocationFor;
  String? _selectedRole;

  @override
  void initState() {
    super.initState();
    var useridFuture = AuthControllers.readCredentialData("UserID");
    var roleFuture = AuthControllers.readCredentialData("UserRole");

    Future.wait([useridFuture, roleFuture]).then((values) {
      setState(() {
        _userId = values[0];
        _role = values[1];
      });

      handleGetRolesList(context); // Fetch roles data for the dropdown
    });
  }

  Future<void> handleGetRolesList(BuildContext context) async {
    var params = {"userRole": _role, "userID": _userId};

    try {
      final ApiResponse? result = await AuthControllers.post(NetworkConstantsUtil.userReportList, params);

      print("API Response: ${result?.data}");

      if (result?.success == "true" && result?.data != null) {
        List<Map<String, dynamic>> roles = List<Map<String, dynamic>>.from(result?.data);

        setState(() {
          rolesData = roles;
          _selectedAllocationFor = null; // Clear selected values
          _selectedRole = null; // Clear selected values
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

  Future<void> handleGetFreehandReport(BuildContext context) async {
    var params = {
      "AllocatedTo": _selectedAllocationFor ?? "",
      "SelectedRole": _selectedRole ?? "",
      "StartDate": _validFromController.text,
      "EndDate": _validToController.text,
      "UserID": _userId,
      "UserRole": _role
    };

    try {
      final ApiResponse? result = await AuthControllers.post(NetworkConstantsUtil.freehandReport, params);

      print("API Response: ${result?.data}");

      if (result?.success == "true" && result?.data != null) {
        setState(() {
          reportData = List<Map<String, dynamic>>.from(result?.data);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 900,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reports Get Freehand Reports',
                  style: TextStyle(
                    fontSize: 24,
                    color: Color(0xFF333333),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      child: _buildDropdown(
                          'Choose Allocation For', 'Select Allocation for'),
                    ),
                    SizedBox(width: 10),
                    Flexible(
                      fit: FlexFit.tight,
                      child: _buildDropdown('Choose Role', 'Select Role'),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      child: _buildTextFormField('Valid From *', 'dd-mm-yyyy',
                          _validFromController, Icons.calendar_today),
                    ),
                    SizedBox(width: 20),
                    Flexible(
                      fit: FlexFit.tight,
                      child: _buildTextFormField('Valid To *', 'dd-mm-yyyy',
                          _validToController, Icons.calendar_today),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildButton('SEARCH', Color(0xFF7F3EAE), _search),
                    SizedBox(width: 10),
                    _buildButton('CLEAR', Color(0xFFFFBE00), _clearFields),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'Separated Allocation Report By Scheme',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text('ALLOCATED TO')),
                      DataColumn(label: Text('ALLOCATED ON')),
                      DataColumn(label: Text('ALLOCATED BY')),
                      DataColumn(label: Text('PRODUCT')),
                      DataColumn(label: Text('POINTS PER BAG')),
                      DataColumn(label: Text('POINTS EARN')),
                      DataColumn(label: Text('QNTY SALE')),
                      DataColumn(label: Text('STATUS')),
                    ],
                    rows: reportData.map((data) {
                      return DataRow(cells: [
                        DataCell(Text(data['AllocatedTo'] ?? '')),
                        DataCell(Text(data['AllocatedOn'] ?? '')),
                        DataCell(Text(data['AllocatedBy'] ?? 'Administrator')), // Assuming "Administrator" as Allocated By
                        DataCell(Text(data['Product'] ?? '')),
                        DataCell(Text(data['SinleProductPoint'] ?? '')),
                        DataCell(Text(data['PointEarn'] ?? '')),
                        DataCell(Text(data['Quantity'] ?? '')),
                        DataCell(Text(data['Status'] ?? '')),
                      ]);
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, String hint) {
    List<DropdownMenuItem<String>> items = rolesData.map((role) {
      return DropdownMenuItem<String>(
        child: Text(role['Name'] ?? ''),
        value: role['Role'],
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF666666),
          ),
        ),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: label == 'Choose Allocation For'
              ? _selectedAllocationFor
              : _selectedRole,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: Color(0xFFDDDDDD)),
            ),
          ),
          hint: Text(
            hint,
            style: TextStyle(fontSize: 10),
          ),
          items: items,
          onChanged: (value) {
            setState(() {
              if (label == 'Choose Allocation For') {
                _selectedAllocationFor = value;
              } else {
                _selectedRole = value;
              }
            });
          },
        ),
      ],
    );
  }

  Widget _buildTextFormField(String labelText, String hintText,
      TextEditingController controller, IconData suffixIcon) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        suffixIcon: IconButton(
          icon: Icon(suffixIcon),
          onPressed: () => _selectDate(context, controller),
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please select a date';
        }
        return null;
      },
    );
  }

  Widget _buildButton(String label, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(fontSize: 14, color: Colors.white),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      String formattedDate = "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
      controller.text = formattedDate;
    }
  }

  void _clearFields() {
    _validFromController.clear();
    _validToController.clear();
    _singleProductPointController.clear();
    setState(() {
      _selectedAllocationFor = null;
      _selectedRole = null;
    });
  }

  void _search() {
    handleGetFreehandReport(context);
  }

  @override
  void dispose() {
    _validFromController.dispose();
    _validToController.dispose();
    _singleProductPointController.dispose();
    super.dispose();
  }
}
