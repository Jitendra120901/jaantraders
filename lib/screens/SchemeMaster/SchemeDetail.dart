import 'package:flutter/material.dart';
import 'package:jaantradersindia/ApiHandler/apiWrapper.dart';
import 'package:jaantradersindia/ApiHandler/networkConstant.dart';
import 'package:jaantradersindia/controllers/authController.dart';

class SchemeDetailScreen extends StatefulWidget {
  final String schemeID;

  SchemeDetailScreen({required this.schemeID});

  @override
  State<SchemeDetailScreen> createState() => _SchemeDetailScreenState();
}

class _SchemeDetailScreenState extends State<SchemeDetailScreen> {
  String? schemeName;
  String? schemeStDt;
  String? schemeEnDt;
  String? totalPointReq;
  String? schemeDescription;
  String? schemeFor;
  String? status;

  Future<void> handleGetDetail(BuildContext context) async {
    var params = {"SchemeID": widget.schemeID};

    try {
      final ApiResponse? result =
          await AuthControllers.post(NetworkConstantsUtil.SchemeDetail, params);

      print("API Response for scheme detail: ${result?.data}");

      if (result?.success == "true" && result?.data != null) {
        final data = result?.data![0]; // Access the first element of the list

        setState(() {
          schemeName = data['SchemeName'];
          schemeStDt = data['SchemeStDt'];
          schemeEnDt = data['SchemeEnDt'];
          totalPointReq = data['TotalPointReq'];
          schemeDescription = data['SchemeDescription'];
          schemeFor = data['SchemeFor'];
          status = data['Status'] == "1" ? 'Active' : 'Inactive';
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
  void initState() {
    super.initState();
    handleGetDetail(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Scheme Detail',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
          ),
        ),
        backgroundColor: Colors.purple,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.keyboard_arrow_left, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              Divider(color: Colors.grey[400]),
              _buildDetailRow('Scheme Name', schemeName ?? ''),
              _buildDetailRow('Scheme Start Date', schemeStDt ?? ''),
              _buildDetailRow('Scheme End Date', schemeEnDt ?? ''),
              _buildDetailRow('Total Points Required', totalPointReq ?? ''),
              _buildDetailRow('Scheme Description', schemeDescription ?? ''),
              _buildDetailRow('Scheme For', schemeFor ?? ''),
              _buildDetailRow('Status', status ?? ''),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.purple,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.business, color: Colors.white),
          SizedBox(width: 8.0),
          Text(
            'Scheme Details',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(width: 16.0),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
