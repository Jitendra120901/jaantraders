
import 'package:jaantradersindia/ApiHandler/appConfigConstant.dart';

//////******* Do not make any change in this file **********/////////

class NetworkConstantsUtil {
  static String baseUrl = AppConfigConstants.liveAppLink;

  // *************** Login and profile *************//
  static String login = 'data/loginVerify.php';
  static String logout = 'data/logout.php';
    static String forgetPasswod = 'data/forgetpass.php';
 static String resetPass = 'data/updatepass.php';

 // *************** Products *************//
 static String addproductpoint = 'data/addproductpoint.php';
 static String getallproductpoint = 'data/getallproductpoint.php';
 static String getSingleProduct="data/getsingleproductpointdetail.php";
 static String deleteProduct="data/deleteproductpoint.php";
 static String UpdateProduct="data/updateproductpoint.php";
 static String activateProduct="data/activateproductpoint.php";
 static String deactivateProduct="data/deactivateproductpoint.php";

  // *************** Scheme *************//
static String addNewScheme="data/addscheme.php";
static String allSchemes="data/getallscheme.php";
 static String UpdateScheme="data/updatescheme.php";
 static String SchemeDetail="data/getsinglescheme.php";
 static String activateScheme="data/activatescheme.php";
 static String deactivateScheme="data/deactivatescheme.php";
 

   // *************** Users  *************//
static String getAllUsers="data/getuserdetails.php";

   // *************** Distributor  *************//
static String addNewDistributor="data/addnewdistributor.php";
static String getAllDistributor="data/getalldistributor.php";
static String distributorDetail="data/getsingledistributor.php";
static String updateDistributor="data/updatedistributor.php";

   // *************** Mistri  *************//
static String addMistri="data/addmistri.php";
static String getallMistri="data/getallmistri.php";

// *************** Retailer  *************//
static String addRetailer="data/addretailer.php";
static String getAllRetailer="data/getallretailer.php";

// *************** Allocation  *************//
static String addAllocation ="data/addallocation.php";
static String getallAllocation="data/getallocation.php";
static  String deleteAllocation="data/delete-allocation.php";
static String activateAllocation="data/act-allocation.php";
static String getUsersByRole="data/allocgetusrbyrole.php";
static String getUsersByProduct="data/allocgetprdbyrole.php";

// *************** Dashboard *************//
static String dashboardData="data/dashboard.php";

// *************** common api User  *************//
static String deleteUser="data/deleteuser.php";
static String updateUser="data/updateusercommon.php";
static String activateUser="data/activateuser.php";
static String deactivateUser="data/deactivateuser.php";

 // *************** report section *************//
 static String schemeReport="data/schemereport.php";
 static String schemeReportList="data/getschemelistfor-report.php";
 static String userReportList="data/user-list-report.php";
 static String freehandReport="data/freehandreport.php";

}
