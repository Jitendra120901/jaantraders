import 'package:flutter/material.dart';
import 'package:jaantradersindia/ApiHandler/apiWrapper.dart';
import 'package:jaantradersindia/ApiHandler/networkConstant.dart';
import 'package:jaantradersindia/controllers/authController.dart';

class AllocationManagement extends StatefulWidget {
  @override
  State<AllocationManagement> createState() => _AllocationManagementState();
}

class _AllocationManagementState extends State<AllocationManagement> {
  final List<Allocation> data = [];

  String? _role;
  String? _userId;
  TextEditingController searchController = TextEditingController();

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
      handleGetAllProductsPoint(context);
    });
  }

  Future<void> handleGetAllProductsPoint(BuildContext context) async {
    var params = {
      "userRole": _role,
    };

    try {
      final ApiResponse? result = await AuthControllers.post(
        NetworkConstantsUtil.getallAllocation, params);

      print("API Response: ${result?.data}");

      if (result?.success == "true" && result?.data != null) {
        final List<Allocation> allocations = (result?.data as List)
          .map((item) => Allocation.fromJson(item))
          .toList();

        setState(() {
          data.clear();
          data.addAll(allocations);
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
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Manage Allocation',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: DataTable(
                      columnSpacing: 20,
                      headingRowColor: MaterialStateColor.resolveWith((states) => Colors.grey[200]!),
                      columns: const <DataColumn>[
                        DataColumn(label: Text('ALLOCATED TO', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('ALLOCATED BY', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('ALLOCATED ON', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('PRODUCT', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('ADDED ON', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('REQ. QNTY', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('EARNED POINTS', style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: data
                        .map(
                          (item) => DataRow(
                            cells: [
                              DataCell(Text(item.allocatedTo)),
                              DataCell(Text(item.allocatedBy)),
                              DataCell(Text(item.allocatedOn)),
                              DataCell(Text(item.product)),
                              DataCell(Text(item.addedOn)),
                              DataCell(Text(item.reqQty)),
                              DataCell(Text(item.earnedPoints)),
                            ],
                          ),
                        )
                        .toList(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Allocation {
  final String allocatedTo;
  final String allocatedBy;
  final String allocatedOn;
  final String product;
  final String addedOn;
  final String reqQty;
  final String earnedPoints;

  Allocation({
    required this.allocatedTo,
    required this.allocatedBy,
    required this.allocatedOn,
    required this.product,
    required this.addedOn,
    required this.reqQty,
    required this.earnedPoints,
  });

  factory Allocation.fromJson(Map<String, dynamic> json) {
    return Allocation(
      allocatedTo: json['AllocatedTo'] ?? '',
      allocatedBy: json['AllocatedBy'] ?? '',
      allocatedOn: json['AllocatedOn'] ?? '',
      product: json['ProductDetail'] ?? '',
      addedOn: json['CreatedDate'] ?? '',
      reqQty: json['Quantity'] ?? '',
      earnedPoints: json['EarnedPoints'] ?? '',
    );
  }
}
