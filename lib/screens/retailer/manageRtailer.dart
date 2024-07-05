import 'package:flutter/material.dart';
import 'package:jaantradersindia/ApiHandler/apiWrapper.dart';
import 'package:jaantradersindia/ApiHandler/networkConstant.dart';
import 'package:jaantradersindia/screens/mistri/userDetail.dart';
import 'package:jaantradersindia/controllers/authController.dart';
import 'package:jaantradersindia/screens/retailer/UpdateRetailer.dart';

class RetailerScreen extends StatefulWidget {
  @override
  State<RetailerScreen> createState() => _RetailerScreenState();
}

class _RetailerScreenState extends State<RetailerScreen> {
  String? _role;
  String? _userId;
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> retailers = [];

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
      handleGetAllRetailer(context);
    });
  }

  Future<void> handleGetAllRetailer(BuildContext context) async {
    try {
      final ApiResponse? result = await AuthControllers.commonforGetApicall(
        NetworkConstantsUtil.getAllRetailer,
      );

      print("API Response: ${result?.data}");

      if (result?.success == "true" && result?.data != null) {
        setState(() {
          retailers = List<Map<String, dynamic>>.from(result!.data!);
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

  void _viewRetailerDetails(dynamic retailer) {
    print('Viewing details of ${retailer['UserID']}');
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return UpdateRetailerScreen(currentRetailerData: {
          "Name": retailer['Name'],
          "email": retailer['Email'],
          "Phone": retailer['Phone'],
          "distributorId": retailer['Status'],
          "Photo": retailer['Image'],
          "userId":retailer['UserID'],
        });
      },
    ));
  }

  Future<void> _deleteRetailer(BuildContext context, dynamic retailer) async {
    var params = {"deluserid": retailer['UserID']};

    try {
      final ApiResponse? result = await AuthControllers.post(
        NetworkConstantsUtil.deleteUser,
        params
      );

      if (result?.success == "true" && result?.data != null) {
        setState(() {
          retailers.remove(retailer);
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

  Future<void> _updateStatus(BuildContext context, dynamic distributor) async {
    String endpoint;
    Map<String, String> params;

    if (distributor['Status'] == '1') {
      endpoint = NetworkConstantsUtil.deactivateUser;
      params = {
        "deactuserid": distributor['UserID'].toString(),
      };
    } else {
      endpoint = NetworkConstantsUtil.activateUser;
      params = {
        "actuserid": distributor['UserID'].toString(),
      };
    }

    try {
      final ApiResponse? result = await AuthControllers.post(endpoint, params);

      if (result?.success == "true" && result?.data != null) {
        setState(() {
          distributor['Status'] = distributor['Status'] == '1' ? '2' : '1'; // Toggle status between 1 and 2
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text(
                  'All/Retailer',
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
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Show'),
                              const SizedBox(width: 8),
                              DropdownButton<int>(
                                value: 10,
                                onChanged: (int? newValue) {},
                                items: <int>[10, 25, 50, 100]
                                    .map<DropdownMenuItem<int>>((int value) {
                                  return DropdownMenuItem<int>(
                                    value: value,
                                    child: Text(value.toString()),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(width: 8),
                              Text('entries'),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Search:'),
                              const SizedBox(width: 8),
                              Container(
                                width: 200,
                                child: TextField(
                                  controller: searchController,
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
                            DataColumn(label: Text('PHOTO')), // New column for photo
                            DataColumn(label: Text('NAME')),
                            DataColumn(label: Text('EMAIL')),
                            DataColumn(label: Text('STATUS')),
                            DataColumn(label: Text('ACTIONS')),
                          ],
                          rows: retailers.map((retailer) {
                            bool isActive = retailer['Status'] == '1'; // Check if active

                            return DataRow(cells: [
                              DataCell(Text('Retailer')), // Assuming role is 'Retailer'
                              DataCell(retailer['Image'] != null
                                  ? Image.network(
                                      retailer['Image'],
                                      width: 50,
                                      height: 50,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Icon(Icons.broken_image);
                                      },
                                    )
                                  : Icon(Icons.image_not_supported)), // Photo cell
                              DataCell(Text(retailer['Name'] ?? '')),
                              DataCell(Text(retailer['Email'] ?? '')),
                              DataCell(
                                Chip(
                                  label: Text(retailer['Status'] == "1" ? "Active" : "Deactive"), // Display current status
                                  backgroundColor: retailer['Status'] == "1" ? Colors.green : Colors.red,
                                  labelStyle: TextStyle(color: Colors.white),
                                ),
                              ),
                              DataCell(
                                PopupMenuButton<String>(
                                  onSelected: (String result) {
                                    switch (result) {
                                      case 'Delete':
                                        _deleteRetailer(context, retailer);
                                        break;
                                      case 'View Details':
                                        _viewRetailerDetails(retailer);
                                        break;
                                      case 'Activate':
                                        if (!isActive) _updateStatus(context, retailer, );
                                        break;
                                      case 'Deactivate':
                                        if (isActive) _updateStatus(context, retailer, );
                                        break;
                                    }
                                  },
                                  itemBuilder: (BuildContext context) =>
                                      <PopupMenuEntry<String>>[
                                    const PopupMenuItem<String>(
                                      value: 'Delete',
                                      child: Text('Delete'),
                                    ),
                                    const PopupMenuItem<String>(
                                      value: 'View Details',
                                      child: Text('View Details'),
                                    ),
                                    if (isActive)
                                      const PopupMenuItem<String>(
                                        value: 'Deactivate',
                                        child: Text('Deactivate'),
                                      )
                                    else
                                      const PopupMenuItem<String>(
                                        value: 'Activate',
                                        child: Text('Activate'),
                                      ),
                                  ],
                                  icon: Icon(Icons.more_vert),
                                ),
                              ),
                            ]);
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text('Showing ${retailers.length} entries'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('Previous'),
                          const SizedBox(width: 8),
                          Text('1'), // Assuming single page for simplicity
                          const SizedBox(width: 8),
                          Text('Next'),
                        ],
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
