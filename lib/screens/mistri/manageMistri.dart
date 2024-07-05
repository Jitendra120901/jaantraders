import 'package:flutter/material.dart';
import 'package:jaantradersindia/ApiHandler/apiWrapper.dart';
import 'package:jaantradersindia/ApiHandler/networkConstant.dart';
import 'package:jaantradersindia/screens/mistri/userDetail.dart';
import 'package:jaantradersindia/controllers/authController.dart';

class ManageMistri extends StatefulWidget {
  @override
  State<ManageMistri> createState() => _ManageMistriState();
}

class _ManageMistriState extends State<ManageMistri> {
  String? _role;
  String? _userId;
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> mistris = [];
  List<Map<String, dynamic>> _filteredMistris = [];

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
      handleGetAllMistri(context);
    });
  }

  Future<void> handleGetAllMistri(BuildContext context) async {
    try {
      final ApiResponse? result = await AuthControllers.commonforGetApicall(
        NetworkConstantsUtil.getallMistri,
      );

      print("API Response: ${result?.data}");

      if (result?.success == "true" && result?.data != null) {
        final data = result?.data as List<dynamic>;
        setState(() {
          mistris = List<Map<String, dynamic>>.from(data);
          _filteredMistris = mistris;
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
            content: Text('${result?.message ?? "Unknown error"}'),
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

  void _filterMistris(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredMistris = mistris;
      } else {
        _filteredMistris = mistris.where((mistri) {
          final nameLower = mistri['Name']?.toLowerCase() ?? '';
          final emailLower = mistri['Email']?.toLowerCase() ?? '';
          final phoneLower = mistri['Phone']?.toLowerCase() ?? '';
          final searchLower = query.toLowerCase();

          return nameLower.contains(searchLower) ||
              emailLower.contains(searchLower) ||
              phoneLower.contains(searchLower);
        }).toList();
      }
    });
  }

  Future<void> _deleteMistri(BuildContext context, dynamic mistri) async {
    var params = {"deluserid": mistri['UserID'].toString()};

    try {
      final ApiResponse? result = await AuthControllers.post(
        NetworkConstantsUtil.deleteUser,
        params,
      );

      if (result?.success == "true" && result?.data != null) {
        setState(() {
          mistris.remove(mistri);
          _filteredMistris.remove(mistri);
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

  void _viewMistriDetails(dynamic mistri) {
    print('Viewing details of ${mistri['UserID']}');
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return UserDetailScreen(userId: mistri['UserID']);
    }));
  }

  Future<void> _updateStatus(BuildContext context, dynamic mistri) async {
    String endpoint;
    Map<String, String> params;

    if (mistri['Status'] == '1') {
      endpoint = NetworkConstantsUtil.deactivateUser;
      params = {
        "deactuserid": mistri['UserID'].toString(),
      };
    } else {
      endpoint = NetworkConstantsUtil.activateUser;
      params = {
        "actuserid": mistri['UserID'].toString(),
      };
    }

    try {
      final ApiResponse? result = await AuthControllers.post(endpoint, params);

      if (result?.success == "true" && result?.data != null) {
        setState(() {
          mistri['Status'] = mistri['Status'] == '1' ? '2' : '1'; // Toggle status between 1 and 2
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
  void dispose() {
    searchController.dispose();
    super.dispose();
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
               Text(
                  'All/Mistri',
                  style: TextStyle(
                    fontSize: 24,
                    color: Color(0xFF333333),
                    wordSpacing: 3
                  ),
                ),
                SizedBox(height: 20),
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
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          // Row(
                          //   mainAxisSize: MainAxisSize.min,
                          //   children: [
                          //     Text('Show'),
                          //     const SizedBox(width: 8),
                          //     DropdownButton<int>(
                          //       value: 10,
                          //       onChanged: (int? newValue) {},
                          //       items: <int>[10, 25, 50, 100]
                          //           .map<DropdownMenuItem<int>>((int value) {
                          //         return DropdownMenuItem<int>(
                          //           value: value,
                          //           child: Text(value.toString()),
                          //         );
                          //       }).toList(),
                          //     ),
                          //     const SizedBox(width: 8),
                          //     Text('entries'),
                          //   ],
                          // ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Search:'),
                              const SizedBox(width: 8),
                              Container(
                                width: 200,
                                child: TextField(
                                  controller: searchController,
                                  onChanged: _filterMistris,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('ROLE')),
                            DataColumn(label: Text('NAME')),
                            DataColumn(label: Text('IMAGE')),
                            DataColumn(label: Text('EMAIL')),
                            DataColumn(label: Text('PHONE')),
                            DataColumn(label: Text('STATUS')),
                            DataColumn(label: Text('ACTIONS')),
                          ],
                          rows: _filteredMistris.map((mistri) {
                            bool isActive = mistri['Status'] == '1'; // Check if active

                            return DataRow(cells: [
                              DataCell(Text('Mistri')),
                              DataCell(Text(mistri['Name'] ?? 'N/A')),
                              DataCell(
                                mistri['Image'] != null
                                    ? Image.network(
                                        mistri['Image'],
                                        height: 50,
                                        width: 50,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Icon(Icons.error);
                                        },
                                      )
                                    : Icon(Icons.person),
                              ),
                              DataCell(Text(mistri['Email'] ?? 'N/A')),
                              DataCell(Text(mistri['Phone'] ?? 'N/A')),
                              DataCell(
                                Text(
                                  isActive ? 'Active' : 'Deactive',
                                  style: TextStyle(
                                    color: isActive ? Colors.green : Colors.red,
                                  ),
                                ),
                              ),
                              DataCell(
                                PopupMenuButton<String>(
                                  onSelected: (value) {
                                    if (value == 'view') {
                                      _viewMistriDetails(mistri);
                                    } else if (value == 'delete') {
                                      _deleteMistri(context, mistri);
                                    } else if (value == 'toggle_status') {
                                      _updateStatus(context, mistri);
                                    }
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return [
                                      PopupMenuItem(
                                        value: 'view',
                                        child: Text('View'),
                                      ),
                                      PopupMenuItem(
                                        value: 'delete',
                                        child: Text('Delete'),
                                      ),
                                      PopupMenuItem(
                                        value: 'toggle_status',
                                        child: Text(isActive ? 'Deactivate' : 'Activate'),
                                      ),
                                    ];
                                  },
                                ),
                              ),
                            ]);
                          }).toList(),
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
