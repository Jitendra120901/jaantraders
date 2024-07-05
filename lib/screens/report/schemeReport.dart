import 'package:flutter/material.dart';
import 'package:jaantradersindia/ApiHandler/apiWrapper.dart';
import 'package:jaantradersindia/ApiHandler/networkConstant.dart';
import 'package:jaantradersindia/controllers/authController.dart';

class ReportsPage extends StatefulWidget {
  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  String? _role;
  String? _userId;
  String? selectedSchemeId; // Store the selected scheme ID
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> reportData = [];
  List<DropdownMenuItem<String>> schemeDropdownItems = [];

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
      
      handleGetalluserReportlist(context); // Fetch the schemes for the dropdown
    });
  }

  Future<void> handleGetSchemeReport(BuildContext context) async {
    var params = {
      "Schemedet": selectedSchemeId.toString(), // Pass the selected scheme ID
      "userRole": _role.toString(),
    };

    try {
      final ApiResponse? result = await AuthControllers.post(
        NetworkConstantsUtil.schemeReport,
        params,
      );

      print("API Response: ${result?.data}");

      if (result?.success == "true" && result?.data != null) {
        setState(() {
          // Assuming result?.data contains 'allocations' and 'user_points'
          reportData = [
            ...result?.data['allocations'], // List of allocations
            ...result?.data['user_points'] // List of user points
          ];
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

  Future<void> handleGetalluserReportlist(BuildContext context) async {
    var params = {
      "userRole": _role
    };

    try {
      final ApiResponse? result = await AuthControllers.post(
          NetworkConstantsUtil.schemeReportList, params);

      print("API Response: ${result?.data}");

      if (result?.success == "true" && result?.data != null) {
        List<Map<String, dynamic>> schemeData = List<Map<String, dynamic>>.from(result?.data);
        
        setState(() {
          schemeDropdownItems = schemeData.map((scheme) {
            return DropdownMenuItem<String>(
              child: Text(scheme['SchemeName'] ?? ''),
              value: scheme['SchemeID'], // Set the value to SchemeID
            );
          }).toList();
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reports',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Scheme',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    items: schemeDropdownItems,
                    onChanged: (value) {
                      setState(() {
                        selectedSchemeId = value; // Update selectedSchemeId
                      });
                    },
                    hint: Text('Select Scheme'),
                    value: selectedSchemeId, // Use selectedSchemeId as value
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            handleGetSchemeReport(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text('SEARCH', style: TextStyle(color: Colors.white),),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedSchemeId = null;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text('CLEAR',style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
                DataColumn(label: Text('ALLOCATED BY')),
                DataColumn(label: Text('SCHEME NAME')),
                DataColumn(label: Text('POINTS REQUIRED')),
                DataColumn(label: Text('TOTAL POINTS')),
                DataColumn(label: Text('ALLOCATED ON')),
              ],
              rows: reportData.map((data) {
                return DataRow(cells: [
                  DataCell(Text(data['AllocatedTo'] ?? '')),
                  DataCell(Text('Administrator')), // Assuming "Administrator" as Allocated By
                  DataCell(Text(data['SchemeName'] ?? '')),
                  DataCell(Text(data['PointsRequired'] ?? '')),
                  DataCell(Text(data['TotalPoint'] ?? '')),
                  DataCell(Text(data['AllocatedOn'] ?? '')),
                ]);
              }).toList(),
            ),
          ),
          SizedBox(height: 20),
          // Align(
          //   alignment: Alignment.centerRight,
          //   child: ElevatedButton(
          //     onPressed: () {
          //       // Add your export to excel logic here
          //     },
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: Colors.green,
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(10),
          //       ),
          //     ),
          //     child: Text('EXPORT TO EXCEL'),
          //   ),
          // ),
        ],
      ),
    );
  }
}
