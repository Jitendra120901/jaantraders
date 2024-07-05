import 'package:flutter/material.dart';
import 'package:jaantradersindia/ApiHandler/apiWrapper.dart';
import 'package:jaantradersindia/ApiHandler/networkConstant.dart';
import 'package:jaantradersindia/controllers/authController.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = "";

  String? _role;
  String? _userId;
  List<User> _users = [];

  Future<void> handleGetAllUsers(BuildContext context) async {
    var params = {
    "userid":_userId,"Role":_role
};

    try {
      final ApiResponse? result = await AuthControllers.post(
          NetworkConstantsUtil.getAllUsers, params);

      print("API Response: ${result?.data}");

      if (result?.success == "true" && result?.data != null) {
        final data = result?.data as List<dynamic>;
        setState(() {
          _users = data.map((item) => User.fromJson(item)).toList();
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
    var useridFuture = AuthControllers.readCredentialData("UserID");
    var roleFuture = AuthControllers.readCredentialData("UserRole");

    Future.wait([useridFuture, roleFuture]).then((values) {
      setState(() {
        _userId = values[0];
        _role = values[1];
      });
      handleGetAllUsers(context);
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
    final filteredUsers = _users.where((user) {
      return user.role.toLowerCase().contains(_searchText.toLowerCase()) ||
          user.name.toLowerCase().contains(_searchText.toLowerCase()) ||
          user.email.toLowerCase().contains(_searchText.toLowerCase()) ||
          user.password.toLowerCase().contains(_searchText.toLowerCase()) ||
          user.phone.toLowerCase().contains(_searchText.toLowerCase()) ||
          user.createdBy.toLowerCase().contains(_searchText.toLowerCase());
    }).toList();

    return Scaffold(
    
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          
          children: [
             Text(
                  'All/Users',
                  style: TextStyle(
                    fontSize: 24,
                    color: Color(0xFF333333),
                    wordSpacing: 3
                  ),
                ),
                SizedBox(height: 20),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                // DropdownButton<int>(
                //   value: 10,
                //   onChanged: (value) {},
                //   items: <int>[10, 25, 50, 100].map<DropdownMenuItem<int>>((int value) {
                //     return DropdownMenuItem<int>(
                //       value: value,
                //       child: Text(value.toString()),
                //     );
                //   }).toList(),
                // ),
                
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: MaterialStateColor.resolveWith((states) => Colors.grey.shade200),
                    columns: const <DataColumn>[
                      DataColumn(label: Text('ROLE ASSIGN')),
                      DataColumn(label: Text('NAME')),
                      DataColumn(label: Text('EMAIL')),
                      DataColumn(label: Text('PASSWORD')),
                      DataColumn(label: Text('PHONE')),
                      DataColumn(label: Text('CREATED BY')),
                    ],
                    rows: filteredUsers.map((user) {
                      return DataRow(
                        cells: [
                          DataCell(Text(user.role)),
                          DataCell(Text(user.name)),
                          DataCell(Text(user.email)),
                          DataCell(Text(user.password)),
                          DataCell(Text(user.phone)),
                          DataCell(Text(user.createdBy)),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            // SizedBox(height: 10),
            Spacer(),
                Text(
                  'Showing 1 to ${filteredUsers.length} of ${_users.length} entries',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     ElevatedButton(
            //       onPressed: () {},
            //       style: ElevatedButton.styleFrom(
            //         backgroundColor: Colors.blue,
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(10.0),
            //         ),
            //       ),
            //       child: Text('Previous'),
            //     ),
            //     SizedBox(width: 10),
            //     ElevatedButton(
            //       onPressed: () {},
            //       style: ElevatedButton.styleFrom(
            //         backgroundColor: Colors.blue,
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(10.0),
            //         ),
            //       ),
            //       child: Text('Next'),
            //     ),
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}

class User {
  final String role;
  final String name;
  final String email;
  final String password;
  final String phone;
  final String createdBy;

  User({
    required this.role,
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.createdBy,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      role: json['Role'],
      name: json['Name'],
      email: json['Email'],
      password: json['Password'],
      phone: json['Phone'],
      createdBy: json['CreatedBy'],
    );
  }
}
