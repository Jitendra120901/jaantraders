import 'package:flutter/material.dart';
import 'package:jaantradersindia/ApiHandler/apiWrapper.dart';
import 'package:jaantradersindia/ApiHandler/networkConstant.dart';
import 'package:jaantradersindia/controllers/authController.dart';
import 'package:jaantradersindia/screens/distributor/distributorDetail.dart';

class DistributorsScreen extends StatefulWidget {
  @override
  State<DistributorsScreen> createState() => _DistributorsScreenState();
}

class _DistributorsScreenState extends State<DistributorsScreen> {
  List<dynamic> distributors = [];
  List<dynamic> _filteredDistributors = [];
  TextEditingController _searchController = TextEditingController();

  Future<void> handleGetAllDistributor(BuildContext context) async {
    try {
      final ApiResponse? result = await AuthControllers.commonforGetApicall(
        NetworkConstantsUtil.getAllDistributor,
      );

      print("API Response: ${result?.data}");

      if (result?.success == "true" && result?.data != null) {
        final data = result?.data as List<dynamic>;
        print("Data of get all distributor: $data");

        setState(() {
          distributors = data;
          _filteredDistributors = data;
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

  Future<void> _deleteDistributor(BuildContext context, dynamic distributor) async {
    var params = {
      "deluserid": distributor['UserID'].toString(),
    };

    try {
      final ApiResponse? result = await AuthControllers.post(
        NetworkConstantsUtil.deleteUser,
        params,
      );

      if (result?.success == "true" && result?.data != null) {
        setState(() {
          distributors.remove(distributor);
          _filteredDistributors.remove(distributor);
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

  Future<void> _updateDistributorStatus(BuildContext context, dynamic distributor) async {
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

  void _viewDistributorDetails(dynamic distributor) {
    print('Viewing details of ${distributor['UserID']}');
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return DistributorDetailScreen(
        DistributorId: distributor['UserID'],
      );
    }));
  }

  void _filterDistributors(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredDistributors = distributors;
      } else {
        _filteredDistributors = distributors.where((distributor) {
          final nameLower = distributor['Name']?.toLowerCase() ?? '';
          final emailLower = distributor['Email']?.toLowerCase() ?? '';
          final phoneLower = distributor['Phone']?.toLowerCase() ?? '';
          final searchLower = query.toLowerCase();

          return nameLower.contains(searchLower) ||
              emailLower.contains(searchLower) ||
              phoneLower.contains(searchLower);
        }).toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    handleGetAllDistributor(context);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
               Text(
                  'All/Distributor',
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text('Search:'),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                    ),
                                    child: TextField(
                                      controller: _searchController,
                                      onChanged: _filterDistributors,
                                      decoration: InputDecoration(
                                        labelText: 'Search',
                                        prefixIcon: Icon(Icons.search),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
                            DataColumn(label: Text('EMAIL')),
                            DataColumn(label: Text('PHONE')),
                            DataColumn(label: Text('IMAGE')),
                            DataColumn(label: Text('STATUS')),
                            DataColumn(label: Text('ACTIONS')),
                          ],
                          rows: _filteredDistributors.map((distributor) {
                            return DataRow(cells: [
                              DataCell(Text('Distributor')),
                              DataCell(Text(distributor['Name'] ?? 'N/A')),
                              DataCell(Text(distributor['Email'] ?? 'N/A')),
                              DataCell(Text(distributor['Phone'] ?? 'N/A')),
                              DataCell(
                                CircleAvatar(
                                  backgroundImage: NetworkImage(distributor['Image'] ?? ''),
                                  radius: 25,
                                  onBackgroundImageError: (exception, stackTrace) {
                                    // Error handling
                                  },
                                ),
                              ),
                              DataCell(
                                Chip(
                                  label: Text(distributor['Status'] == '1' ? 'Activated' : 'Deactivated'),
                                  backgroundColor: distributor['Status'] == '1' ? Colors.green : Colors.red,
                                  labelStyle: TextStyle(color: Colors.white),
                                ),
                              ),
                              DataCell(
                                PopupMenuButton<String>(
                                  onSelected: (String result) {
                                    switch (result) {
                                      case 'Delete':
                                        _deleteDistributor(context, distributor);
                                        break;
                                      case 'View Details':
                                        _viewDistributorDetails(distributor);
                                        break;
                                      case 'Activate':
                                      case 'Deactivate':
                                        _updateDistributorStatus(context, distributor);
                                        break;
                                    }
                                  },
                                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                    const PopupMenuItem<String>(
                                      value: 'Delete',
                                      child: Text('Delete'),
                                    ),
                                    const PopupMenuItem<String>(
                                      value: 'View Details',
                                      child: Text('View Details'),
                                    ),
                                    PopupMenuItem<String>(
                                      value: distributor['Status'] == '1' ? 'Deactivate' : 'Activate',
                                      child: Text(distributor['Status'] == '1' ? 'Deactivate' : 'Activate'),
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
                      Text('Showing ${_filteredDistributors.length} entries'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: Text('Previous'),
                          ),
                          const SizedBox(width: 8),
                          Text('1'),
                          const SizedBox(width: 8),
                          TextButton(
                            onPressed: () {},
                            child: Text('Next'),
                          ),
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
