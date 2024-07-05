import 'package:flutter/material.dart';
import 'package:jaantradersindia/ApiHandler/apiWrapper.dart';
import 'package:jaantradersindia/ApiHandler/networkConstant.dart';
import 'package:jaantradersindia/controllers/authController.dart';
import 'package:jaantradersindia/screens/SchemeMaster/SchemeDetail.dart';
import 'package:jaantradersindia/screens/SchemeMaster/updatescheme.dart';

class SchemeScreen extends StatefulWidget {
  @override
  _SchemeScreenState createState() => _SchemeScreenState();
}

class _SchemeScreenState extends State<SchemeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = "";

  String? _role;
  String? _userId;

  List<Scheme> _schemes = [];
  bool _isLoading = false;

  Future<void> handleGetAllSchemes() async {
    var params = {
      "userid": _userId,
      "userRole": _role,
    };

    try {
      final ApiResponse? result =
          await AuthControllers.post(NetworkConstantsUtil.allSchemes, params);

      print("API Response: ${result?.data}");

      if (result?.success == "true" && result?.data != null) {
        final data = result?.data as List<dynamic>;
        setState(() {
          _schemes = data.map((item) => Scheme.fromJson(item)).toList();
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
            backgroundColor: Color.fromARGB(255, 57, 3, 193),
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

  Future<void> handleDeleteScheme(BuildContext context, Scheme scheme) async {
    var params = {"userid": _userId, "schemeid": scheme.schemeId};

    try {
      final ApiResponse? result = await AuthControllers.post(
          NetworkConstantsUtil.deleteProduct, params);

      if (result?.success == "true" && result?.data != null) {
        setState(() {
          _schemes.remove(scheme);
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

  Future<void> handleUpdateSchemeStatus(BuildContext context, Scheme scheme) async {
    String endpoint;
    Map<String, String> params;

    if (scheme.status == 'Activated') {
      endpoint = NetworkConstantsUtil.deactivateScheme;
      params = {"SchemeID": scheme.schemeId};
    } else {
      endpoint = NetworkConstantsUtil.activateScheme;
      params = {"SchemeID": scheme.schemeId};
    }

    try {
      final ApiResponse? result = await AuthControllers.post(endpoint, params);

      if (result?.success == "true" && result?.data != null) {
        setState(() {
          scheme.status = scheme.status == 'Activated' ? 'Deactivated' : 'Activated';
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

  void _editScheme(Scheme scheme) {
    print('Editing ${scheme.schemeName}');
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return UpdateSchemePage(
          schemeCurrentdata: {
            "schemeName": scheme.schemeName,
            "validFrom": scheme.validFrom,
            "validTo": scheme.validTo,
            "totalPoints": scheme.totalPoints,
            "schemeFor": scheme.schemeFor,
            "gift": scheme.gift,
            "status": scheme.status,
            "schemeId": scheme.schemeId
          },
        );
      },
    ));
  }

  void _viewSchemeDetails(Scheme scheme) {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return SchemeDetailScreen(schemeID: scheme.schemeId);
      },
    ));
  }

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
      handleGetAllSchemes();
    });

    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredSchemes = _schemes.where((scheme) {
      return scheme.schemeName
              .toLowerCase()
              .contains(_searchText.toLowerCase()) ||
          scheme.gift.toLowerCase().contains(_searchText.toLowerCase()) ||
          scheme.validFrom.toLowerCase().contains(_searchText.toLowerCase()) ||
          scheme.validTo.toLowerCase().contains(_searchText.toLowerCase()) ||
          scheme.totalPoints
              .toLowerCase()
              .contains(_searchText.toLowerCase()) ||
          scheme.schemeFor.toLowerCase().contains(_searchText.toLowerCase()) ||
          scheme.status.toLowerCase().contains(_searchText.toLowerCase());
    }).toList();

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: handleGetAllSchemes,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
               Text(
                  'All Schemes',
                  style: TextStyle(
                    fontSize: 24,
                    color: Color(0xFF333333),
                    
                  ),
     
                ),
                SizedBox(height: 20),
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowColor: MaterialStateColor.resolveWith(
                                (states) => Colors.grey[300]!),
                            columns: const <DataColumn>[
                              DataColumn(label: Text('SCHEME NAME')),
                              DataColumn(label: Text('GIFT')),
                              DataColumn(label: Text('VALID FROM')),
                              DataColumn(label: Text('VALID TO')),
                              DataColumn(label: Text('TOTAL POINTS')),
                              DataColumn(label: Text('FOR')),
                              DataColumn(label: Text('STATUS')),
                              DataColumn(label: Text('ACTIONS')),
                            ],
                            rows: filteredSchemes.map((scheme) {
                              return DataRow(cells: [
                                DataCell(Text(scheme.schemeName)),
                                DataCell(Text(scheme.gift)),
                                DataCell(Text(scheme.validFrom)),
                                DataCell(Text(scheme.validTo)),
                                DataCell(Text(scheme.totalPoints)),
                                DataCell(Text(scheme.schemeFor)),
                                DataCell(Text(
                                  scheme.status,
                                  style: TextStyle(
                                    color: scheme.status == 'Activated'
                                        ? Colors.green
                                        : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                                DataCell(
                                  PopupMenuButton<String>(
                                    onSelected: (String result) {
                                      switch (result) {
                                        case 'Edit':
                                          _editScheme(scheme);
                                          break;
                                        case 'Delete':
                                          handleDeleteScheme(context, scheme);
                                          break;
                                        case 'View Details':
                                          _viewSchemeDetails(scheme);
                                          break;
                                        case 'Toggle Status':
                                          handleUpdateSchemeStatus(context, scheme);
                                          break;
                                      }
                                    },
                                    itemBuilder: (BuildContext context) =>
                                        <PopupMenuEntry<String>>[
                                      const PopupMenuItem<String>(
                                        value: 'Edit',
                                        child: Text('Edit'),
                                      ),
                                      const PopupMenuItem<String>(
                                        value: 'Delete',
                                        child: Text('Delete'),
                                      ),
                                      const PopupMenuItem<String>(
                                        value: 'View Details',
                                        child: Text('View Details'),
                                      ),
                                      PopupMenuItem<String>(
                                        value: 'Toggle Status',
                                        child: Text(scheme.status == 'Activated'
                                            ? 'Deactivate'
                                            : 'Activate'),
                                      ),
                                    ],
                                    icon: Icon(Icons.more_vert),
                                  ),
                                ),
                              ]);
                            }).toList(),
                          ),
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

class Scheme {
  final String schemeId;
  final String schemeName;
  final String gift;
  final String validFrom;
  final String validTo;
  final String totalPoints;
  final String schemeFor;
  String status;

  Scheme({
    required this.schemeId,
    required this.schemeName,
    required this.gift,
    required this.validFrom,
    required this.validTo,
    required this.totalPoints,
    required this.schemeFor,
    required this.status,
  });

  factory Scheme.fromJson(Map<String, dynamic> json) {
    return Scheme(
      schemeId: json['SchemeID'],
      schemeName: json['SchemeName'],
      gift: json['SchemeDescription'],
      validFrom: json['SchemeStDt'],
      validTo: json['SchemeEnDt'],
      totalPoints: json['TotalPointReq'] ?? '0',
      schemeFor: json['SchemeFor'],
      status: json['Status'] == '1' ? 'Activated' : 'Deactivated',
    );
  }
}
