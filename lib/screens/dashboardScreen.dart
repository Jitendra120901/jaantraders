import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jaantradersindia/ApiHandler/apiWrapper.dart';
import 'package:jaantradersindia/ApiHandler/networkConstant.dart';
import 'package:jaantradersindia/controllers/authController.dart';
import 'package:jaantradersindia/screens/SchemeMaster/addNewScheme.dart';
import 'package:jaantradersindia/screens/SchemeMaster/allscheme.dart';
import 'package:jaantradersindia/screens/allocation/addNewAllocation.dart';
import 'package:jaantradersindia/screens/allocation/manageAllocation.dart';
import 'package:jaantradersindia/screens/distributor/addDistributor.dart';
import 'package:jaantradersindia/screens/distributor/manageDistributor.dart';
import 'package:jaantradersindia/screens/loginScreen.dart';
import 'package:jaantradersindia/screens/mistri/addMistri.dart';
import 'package:jaantradersindia/screens/mistri/manageMistri.dart';
import 'package:jaantradersindia/screens/products/addProductPoint.dart';
import 'package:jaantradersindia/screens/products/manageProductPoint.dart';
import 'package:jaantradersindia/screens/report/freehandreport.dart';
import 'package:jaantradersindia/screens/report/schemeReport.dart';
import 'package:jaantradersindia/screens/retailer/addRetailer.dart';
import 'package:jaantradersindia/screens/retailer/manageRtailer.dart';
import 'package:jaantradersindia/screens/users/user.dart';

class DashboardScreen extends StatefulWidget {
  final userIs;
  final userRole;
  final userId;

  const DashboardScreen({Key? key, this.userIs, this.userRole, this.userId})
      : super(key: key);
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Future<void> handleLogout(BuildContext context) async {
    var params = {"userid": widget.userId};
    try {
      // Await the result of the login API call
      final ApiResponse? result =
          await AuthControllers.post(NetworkConstantsUtil.logout, params);

      // Ensure result is not null and print the result from the API call
      if (result != null) {
        print("post api data after api call =====================> ${result}");

        if (result.success == "true") {
          Navigator.popUntil(context, (route) => route.isFirst);
        } else {
          // Show error message if login failed
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Something went wrong , please try again!!'),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      } else {
        // Show error message if login failed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed. Please check your credentials.'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (e) {
      // Handle any errors that occur during the API call
      print("Error during login: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred. Please try again.'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  int selectedBodyIndex = 0;

  void openOverflowDrawerInchatScreen(BuildContext context) {
  final RenderBox overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox;
  final RenderBox button = context.findRenderObject() as RenderBox;
  final Offset buttonPosition = button.localToGlobal(Offset.zero, ancestor: overlay);
  final Offset targetPosition = Offset(
    buttonPosition.dx,
    buttonPosition.dy + button.size.height,
  );

  String userIs = widget.userIs ?? 'Unknown User'; // Default value if null
  String userRole = widget.userRole ?? 'Unknown Role'; // Default value if null

  showMenu(
    context: context,
    position: RelativeRect.fromLTRB(
      targetPosition.dy, // Corrected from targetPosition.dy to targetPosition.dx
      targetPosition.dx, // Corrected from targetPosition.dx to targetPosition.dy
      0,
      0,
    ),
    items: [
      PopupMenuItem(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey,
              backgroundImage: AssetImage("assets/user.png"),
            ),
            title: Text(
              userIs,
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
            subtitle: Text(
              userRole,
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      // PopupMenuItem(
      //   child: ListTile(
      //     leading: Icon(Icons.settings),
      //     title: Text(
      //       "Setting",
      //       style: TextStyle(fontSize: 15),
      //     ),
      //     onTap: () {
      //       Navigator.pop(context);
      //     },
      //   ),
      // ),
      // PopupMenuItem(
      //   child: ListTile(
      //     leading: Icon(Icons.attach_money),
      //     title: Text("Pricing", style: TextStyle(fontSize: 15)),
      //     onTap: () {
      //       Navigator.pop(context);
      //     },
      //   ),
      // ),
      PopupMenuItem(
        child: ListTile(
          leading: Icon(Icons.logout),
          title: Text("Log out", style: TextStyle(fontSize: 15)),
          onTap: () {
           
            Navigator.popUntil(context, (route) {
           return route.isFirst;
            },);
             FlutterSecureStorage().delete(key: "UserID");
          },
        ),
      ),
    ],
  );
}


  @override
  Widget build(BuildContext context) {
    String _userId = ""; // Set your user ID here
    String _companyId = ""; // Set your company ID here

    

    @override
    void initState() {
      super.initState();
      var userid = AuthControllers.readCredentialData("UserID");

      var companyID = AuthControllers.readCredentialData("CompanyID");
      var role = AuthControllers.readCredentialData("UserRole");
      userid.then((result) {
        print("user id read in add product screen ===========> $result");
        setState(() {
          _userId = result!;
        });
      });
      
     
    }
 
  
    return Scaffold(
     appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.purple,
        title: Text(
          'JAANTRADERS',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
         
          // IconButton(
          //   icon: Icon(Icons.notifications),
          //   onPressed: () {},
          // ),
        GestureDetector(
            onTap: () {
              openOverflowDrawerInchatScreen(context);
            },
            child: CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: AssetImage("assets/user.png")),
          ),
          SizedBox(width: 10),
        ],
      ),
      drawer: CustomDrawer(
        menuItems: [
          DrawerMenuItem(
            title: 'Dashboard',
            icon: Icons.dashboard,
            onTap: () => _onMenuItemSelected(0),
          ),
          DrawerMenuItem(
            title: 'Products point management',
            icon: Icons.production_quantity_limits_sharp,
            onTap: () => _onMenuItemSelected(1),
            dropdownItems: [
              DropdownMenuItem(
                  title: 'Add Product',
                  onTap: () => _onDropdownItemSelected(1)),
              DropdownMenuItem(
                  title: 'Manage Product',
                  onTap: () => _onDropdownItemSelected(2)),
            ],
          ),
          DrawerMenuItem(
            title: 'Scheme Master',
            icon: Icons.person,
            onTap: () => _onMenuItemSelected(2),
            dropdownItems: [
              DropdownMenuItem(
                  title: 'Add Scheme', onTap: () => _onDropdownItemSelected(3)),
              DropdownMenuItem(
                  title: 'Manage Scheme',
                  onTap: () => _onDropdownItemSelected(4)),
            ],
          ),
          DrawerMenuItem(
            title: 'User Master',
            icon: Icons.person,
            onTap: () => _onMenuItemSelected(2),
            dropdownItems: [
              DropdownMenuItem(
                  title: 'All Users', onTap: () => _onDropdownItemSelected(5)),
            ],
          ),
          DrawerMenuItem(
            title: 'Distributor Master',
            icon: Icons.person,
            onTap: () => _onMenuItemSelected(2),
            dropdownItems: [
              DropdownMenuItem(
                  title: 'Add New Distributor',
                  onTap: () => _onDropdownItemSelected(6)),
              DropdownMenuItem(
                  title: 'Manage Distributor',
                  onTap: () => _onDropdownItemSelected(7)),
            ],
          ),
          DrawerMenuItem(
            title: 'Retailer Master',
            icon: Icons.person,
            onTap: () => _onMenuItemSelected(2),
            dropdownItems: [
              DropdownMenuItem(
                  title: 'Add New Retailer',
                  onTap: () => _onDropdownItemSelected(8)),
              DropdownMenuItem(
                  title: 'Manage Retailer',
                  onTap: () => _onDropdownItemSelected(9)),
            ],
          ),
          DrawerMenuItem(
            title: 'Mistri Master',
            icon: Icons.person,
            onTap: () => _onMenuItemSelected(2),
            dropdownItems: [
              DropdownMenuItem(
                  title: 'Add New Mistri',
                  onTap: () => _onDropdownItemSelected(10)),
              DropdownMenuItem(
                  title: 'Manage Mistri',
                  onTap: () => _onDropdownItemSelected(11)),
            ],
          ),
          DrawerMenuItem(
            title: 'Allocation',
            icon: Icons.assignment_turned_in,
            onTap: () => _onMenuItemSelected(2),
            dropdownItems: [
              DropdownMenuItem(
                  title: 'Add New Allocation',
                  onTap: () => _onDropdownItemSelected(12)),
              DropdownMenuItem(
                  title: 'Manage Allocation',
                  onTap: () => _onDropdownItemSelected(13)),
            ],
          ),

           DrawerMenuItem(
            title: 'Reports',
            icon: Icons.list_alt,
            onTap: () => _onMenuItemSelected(2),
            dropdownItems: [
              DropdownMenuItem(
                  title: 'Free hand Reports',
                  onTap: () => _onDropdownItemSelected(14)),
              DropdownMenuItem(
                  title: 'Scheme Reports',
                  onTap: () => _onDropdownItemSelected(15)),
            ],
          ),
          // Add more DrawerMenuItem instances for other menu items
        ],
      ),
      body: getBody(selectedBodyIndex),
    );
  }

  void _onMenuItemSelected(int index) {
    setState(() {
      selectedBodyIndex = index;
    });
    Navigator.of(context).pop(); // Close the drawer
  }

  void _onDropdownItemSelected(int index) {
    setState(() {
      selectedBodyIndex = index; // Unique index for dropdown items
    });
    Navigator.of(context).pop(); // Close the drawer
  }

  Widget getBody(int index) {
    switch (index) {
      case 0:
        return Dashboard();
      case 1:
        return ProductPointScreen();
      case 2:
        return ProductPointsPage(); // Add Product
      case 3:
        return AddSchemePage(); // Manage Product
      case 4:
        return SchemeScreen();
      case 5:
        return UserScreen(); // Add Scheme
      case 6:
        return AddDistributorScreen();
      case 7:
        return DistributorsScreen(); // Add Scheme
      case 8:
        return AddRetailerScreen();
      case 9:
        return RetailerScreen(); // Add Scheme
      case 10:
        return AddNewMistriScreen(); // Manage Scheme
      case 11:
        return ManageMistri();
      case 12:
        return AllocationScreen();
      case 13:
        return AllocationManagement();
        case 14:
        return FreehandReportsScreen();
        case 15:
        return ReportsPage();
      // Add more cases for other menu and dropdown items
      default:
        return Center(child: Text('Select an option from the drawer.'));
    }
  }
}

class Dashboard extends StatefulWidget {
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String _userId = ""; // Set your user ID here
  var _role;
  String _companyId = ""; // Set your company ID here
  String _stockQuantity = "0"; // Variable to hold the stock quantity
  String _totalRetailer = "0";
  String _totalMistri = "0";
  String _totalGifts = "0";
  String _totalPoints = "0";
  String _totalAllocations = "0";

 Future<void> handlegetDashboard(BuildContext context) async {
  var params = {
    "UserRole": _role,
    "userID": _userId,
  };

  try {
    // Await the result of the login API call
    final ApiResponse? result = await AuthControllers.post(
        NetworkConstantsUtil.dashboardData, params);

    if (result?.success == "true") {
      print("API call success =====================> ${result?.data}");
      final List<dynamic>? dataList = result?.data;

      if (dataList != null && dataList.isNotEmpty) {
        final data = dataList[0]; // Access the first element of the list

        if (data != null && data.isNotEmpty) {
          setState(() {
            _stockQuantity = data['StockQuantity']?.toString() ?? "0";
            _totalRetailer = data['TotalRetailer']?.toString() ?? "0";
            _totalMistri = data['TotalMistri']?.toString() ?? "0";
            _totalGifts = data['TotalGifts']?.toString() ?? "0";
            _totalPoints = data['TotalPoints']?.toString() ?? "0";
            _totalAllocations = data['TotalAllocations']?.toString() ?? "0";
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
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${result?.message}'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } else {
      print("API call error =====================> ${result?.success}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${result?.message}.'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  } catch (e) {
    print("Error during login: $e");
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
    _initializeUserData();
  }

  Future<void> _initializeUserData() async {
    try {
      var userid = await AuthControllers.readCredentialData("UserID");
      var companyID = await AuthControllers.readCredentialData("CompanyID");
      var role = await AuthControllers.readCredentialData("UserRole");

      setState(() {
        _userId = userid ?? "";
        _companyId = companyID ?? "";
        _role = role;
      });

      // Call the API once all the user data is initialized
      handlegetDashboard(context);
    } catch (e) {
      print("Error during user data initialization: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred while initializing user data. Please try again.'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  // Method to simulate fetching updated data
  Future<void> _refreshData() async {
    await handlegetDashboard(context); // Fetch updated stock data
    await Future.delayed(Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DashboardCard(
                title: 'Total Stock',
                value: 'Remaining Stock: $_stockQuantity', // Display the stock quantity
                imageName: 'gift.png',
              ),
              SizedBox(height: 16),
              DashboardCard(
                title: 'Your Sessions',
                value: '2',
                subtitle: 'Last Week',
                imageName: 'illustration-2.png',
              ),
              SizedBox(height: 16),
              DashboardCard(
                title: 'Distributors',
                value: '$_totalRetailer Registered',
                imageName: 'distributor.png',
              ),
              SizedBox(height: 16),
              DashboardCard(
                title: 'Retailers',
                value: '$_totalRetailer Registered',
                imageName: 'retailer.png',
              ),
              SizedBox(height: 16),
              DashboardCard(
                title: 'Mistri',
                value: '$_totalMistri Registered',
                imageName: 'mistri.png',
              ),
              SizedBox(height: 16),
              DashboardCard(
                title: 'Allocations',
                value: 'Total $_totalAllocations',
                subtitle: 'Assigned 0\nCompleted $_totalAllocations',
                imageName: 'mistri.png',
              ),
              SizedBox(height: 16),
              DashboardCard(
                title: 'Offers / Gifts',
                value: '$_totalGifts Available',
                subtitle: 'Last Week',
                imageName: 'gift.png',
              ),
              SizedBox(height: 20),
              PointsCard(
                points: '$_totalPoints',
                imageName: "prdt.png",
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class CustomDrawer extends StatefulWidget {
  final List<DrawerMenuItem> menuItems;

  const CustomDrawer({Key? key, required this.menuItems}) : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  int? openDropdownIndex; // Track the index of the currently open dropdown

  @override
  Widget build(BuildContext context) {
    // Set status bar text color to dark
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent, // Transparent status bar background
      statusBarIconBrightness:
          Brightness.dark, // Dark status bar icons (e.g., time)
    ));

    return Drawer(
      child: Column(
        children: [
          buildHeader(),
          buildMenuItems(context),
        ],
      ),
    );
  }

  Widget buildHeader() {
    return SizedBox(
      width: double.infinity,
      child: DrawerHeader(
        decoration: BoxDecoration(
          color: Colors.purple, // Custom background color
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "JAANTRADERS",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Powered by: CSS Infotech",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMenuItems(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: widget.menuItems.length,
        itemBuilder: (context, index) {
          final menuItem = widget.menuItems[index];
          return Column(
            children: [
              ListTile(
                leading: Icon(menuItem.icon),
                title: Text(menuItem.title),
                trailing: menuItem.dropdownItems != null
                    ? (openDropdownIndex == index
                        ? Icon(Icons.keyboard_arrow_down)
                        : Icon(Icons.keyboard_arrow_right))
                    : null,
                onTap: () {
                  if (menuItem.dropdownItems != null) {
                    setState(() {
                      if (openDropdownIndex == index) {
                        openDropdownIndex = null;
                      } else {
                        openDropdownIndex = index;
                      }
                    });
                  } else {
                    menuItem.onTap();
                  }
                },
              ),
              if (openDropdownIndex == index && menuItem.dropdownItems != null)
                Column(
                  children: menuItem.dropdownItems!
                      .map((dropdownItem) => ListTile(
                            leading: CircularCheckbox(
                              value: dropdownItem.isChecked,
                              onChanged: (bool value) {
                                performAction(dropdownItem);
                              },
                            ),
                            title: Text(dropdownItem.title),
                            onTap: () => performAction(dropdownItem),
                          ))
                      .toList(),
                ),
            ],
          );
        },
      ),
    );
  }

  void performAction(DropdownMenuItem dropdownItem) {
    setState(() {
      dropdownItem.isChecked = !dropdownItem.isChecked;
    });
    Future.delayed(Duration(milliseconds: 100), () {
      dropdownItem.onTap();
    });
  }
}

class DrawerMenuItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final List<DropdownMenuItem>? dropdownItems;

  DrawerMenuItem({
    required this.title,
    required this.icon,
    required this.onTap,
    this.dropdownItems,
  });
}

class DropdownMenuItem {
  final String title;
  final VoidCallback onTap;
  bool isChecked;

  DropdownMenuItem(
      {required this.title, required this.onTap, this.isChecked = false});
}

// Define global styles and colors
class AppStyles {
  static const double cardElevation = 4.0;
  static const EdgeInsetsGeometry cardPadding = EdgeInsets.all(16.0);
  static const double iconSize = 24.0;
  static const double titleFontSize = 18.0;
  static const double valueFontSize = 16.0;
  static const double subtitleFontSize = 14.0;
}

class AppColors {
  static const Color primaryColor = Colors.blue;
  static const Color accentColor = Colors.green;
}

class DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final String imageName;

  DashboardCard({
    required this.title,
    required this.value,
    required this.imageName,
    this.subtitle = '',
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppStyles.cardElevation,
      margin: AppStyles.cardPadding,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.grey[200],
              ),
              child: Center(
                child: Image.asset(
                  "assets/${imageName}",
                  width: 40,
                  height: 40,
                ),
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        fontSize: AppStyles.titleFontSize,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    value,
                    style: TextStyle(
                        fontSize: AppStyles.valueFontSize,
                        color: AppColors.accentColor),
                  ),
                  if (subtitle.isNotEmpty) ...[
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                          fontSize: AppStyles.subtitleFontSize,
                          color: Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PointsCard extends StatelessWidget {
  final String points;
  final String imageName;

  PointsCard({required this.points, required this.imageName});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppStyles.cardElevation,
      margin: AppStyles.cardPadding,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.grey[200],
              ),
              child: Center(
                child: Image.asset(
                  "assets/${imageName}",
                  width: 40,
                  height: 40,
                ),
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.star,
                size: AppStyles.iconSize, color: AppColors.accentColor),
            SizedBox(width: 8),
            Text(
              '$points Points',
              style: TextStyle(
                  fontSize: AppStyles.valueFontSize,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class CircularCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CircularCheckbox({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(!value);
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color.fromARGB(255, 113, 112, 112),
            width: .5,
          ),
          color: value ? Colors.blue : Colors.transparent,
        ),
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: value
              ? Icon(
                  Icons.check,
                  size: 11.0,
                  color: Colors.white,
                )
              : Icon(
                  Icons.check_box_outline_blank,
                  size: 16.0,
                  color: Colors.transparent,
                ),
        ),
      ),
    );
  }
}
