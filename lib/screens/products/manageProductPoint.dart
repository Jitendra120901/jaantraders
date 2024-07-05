import 'package:flutter/material.dart';
import 'package:jaantradersindia/ApiHandler/apiWrapper.dart';
import 'package:jaantradersindia/ApiHandler/networkConstant.dart';
import 'package:jaantradersindia/controllers/authController.dart';
import 'package:jaantradersindia/screens/products/productDetailScreen.dart';
import 'package:jaantradersindia/screens/products/updateProductScreen.dart';

class ProductPointsPage extends StatefulWidget {
  @override
  State<ProductPointsPage> createState() => _ProductPointsPageState();
}

class _ProductPointsPageState extends State<ProductPointsPage> {
  List<ProductPoint> productPoints = [];
  List<ProductPoint> filteredProductPoints = [];
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
    var params = {"userid": _userId, "role": _role};

    try {
      final ApiResponse? result = await AuthControllers.post(
          NetworkConstantsUtil.getallproductpoint, params);

      print("API Response: ${result?.data}");

      if (result?.success == "true" && result?.data != null) {
        final data = result?.data;
        setState(() {
          productPoints = data
              .map<ProductPoint>((item) => ProductPoint.fromJson(item))
              .toList();
          filteredProductPoints = productPoints; // Update the filtered list
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

  Future<void> handleUpdateProductStatus(BuildContext context, ProductPoint productPoint) async {
    String endpoint;
    Map<String, String> params;

    if (productPoint.status == '1') {
      endpoint = NetworkConstantsUtil.deactivateProduct;
      params = {"productid": productPoint.productId};
    } else {
      endpoint = NetworkConstantsUtil.activateProduct;
      params = {"productid": productPoint.productId};
    }

    try {
      final ApiResponse? result = await AuthControllers.post(endpoint, params);

      if (result?.success == "true" && result?.data != null) {
        setState(() {
          productPoint.status = productPoint.status == '1' ? '0' : '1';
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

  void _filterProducts(String query) {
    setState(() {
      filteredProductPoints = productPoints
          .where((product) =>
              product.productName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _editProductPoint(ProductPoint productPoint) {
    // Implement edit action
    print('Editing ${productPoint.productName}');
    // Navigate to edit screen or show dialog for editing
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return UpdateProductScreen(
          productpointData: {
            'ProductName': productPoint.productName,
            'ProductPoints': productPoint.pointsPerBag.toString(),
            'AssignedFor': productPoint.assignedFor,
            'AddedOn': productPoint.addedOn,
            'Status': productPoint.status,
            "productid": productPoint.productId
          },
        );
      },
    ));
  }

  void _deleteProductPoint(ProductPoint productPoint) {
    // Implement delete action
    print('Deleting ${productPoint.productName}');
    // Show confirmation dialog and delete the product point
    Future<void> handleDeleteProduct(BuildContext context) async {
      var params = {"userid": _userId, "productid": productPoint.productId};

      try {
        final ApiResponse? result = await AuthControllers.post(
            NetworkConstantsUtil.deleteProduct, params);

        if (result?.success == "true" && result?.data != null) {
          final data = result?.data![0]; // Access the first element of the list

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

    handleDeleteProduct(context);
  }

  void _viewProductPointDetails(ProductPoint productPoint) {
    print("Product ID: ${productPoint.productId}");

    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return ProductDetailScreen(
          ProductID: productPoint.productId,
        );
      },
    ));
  }

  Future<void> _refreshProducts() async {
    await handleGetAllProductsPoint(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshProducts,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
               Text(
                  'All/Prosduct',
                  style: TextStyle(
                    fontSize: 24,
                    color: Color(0xFF333333),
                    wordSpacing: 3
                  ),
                ),
                SizedBox(height: 20),
              TextField(
                controller: searchController,
                onChanged: _filterProducts,
                decoration: InputDecoration(
                  labelText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: MaterialStateColor.resolveWith(
                          (states) => Colors.grey[200]!),
                      columns: [
                        DataColumn(
                            label: Text('Product Name',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('Points Per Bag',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('Added On',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('Assigned For',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('Status',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('Actions',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: filteredProductPoints.map((productPoint) {
                        return DataRow(cells: [
                          DataCell(Text(productPoint.productName)),
                          DataCell(Text(productPoint.pointsPerBag.toString())),
                          DataCell(Text(productPoint.addedOn)),
                          DataCell(Text(productPoint.assignedFor)),
                          DataCell(Row(
                            children: [
                              Icon(
                                Icons.circle,
                                color: productPoint.status == '1'
                                    ? Colors.green
                                    : Colors.red,
                                size: 12,
                              ),
                              SizedBox(width: 5),
                              Text(
                                productPoint.status == '1'
                                    ? 'Activated'
                                    : 'Deactivated',
                              ),
                            ],
                          )),
                          DataCell(
                            PopupMenuButton<String>(
                              onSelected: (String result) {
                                switch (result) {
                                  case 'Edit':
                                    _editProductPoint(productPoint);
                                    break;
                                  case 'Delete':
                                    _deleteProductPoint(productPoint);
                                    break;
                                  case 'View Details':
                                    _viewProductPointDetails(productPoint);
                                    break;
                                  case 'Toggle Status':
                                    handleUpdateProductStatus(context, productPoint);
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
                                  child: Text(productPoint.status == '1'
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

class ProductPoint {
  final String productId;
  final String productName;
  final double pointsPerBag;
  final String addedOn;
  final String assignedFor;
  String status;

  ProductPoint({
    required this.productId,
    required this.productName,
    required this.pointsPerBag,
    required this.addedOn,
    required this.assignedFor,
    required this.status,
  });

  factory ProductPoint.fromJson(Map<String, dynamic> json) {
    return ProductPoint(
      productId: json['ProductID'],
      productName: json['ProductName'],
      pointsPerBag: double.parse(json['ProuductPoints'] ?? '0'),
      addedOn: json['AddedOn'],
      assignedFor: json['AssignedFor'],
      status: json['Status'].toString(),
    );
  }
}
