import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jaantradersindia/ApiHandler/apiWrapper.dart';

class AuthControllers {

static   void saveCredential( String keyName,String value,) async {
    final fluttersecureStorage = FlutterSecureStorage();
    var writtendata =
        await fluttersecureStorage.write(key: keyName, value: value);
    return writtendata;
  }

static  void deleteCredential(String keyName) async {
    final fluttersecureStorage = FlutterSecureStorage();
    var writtendata = await fluttersecureStorage.delete(
      key: keyName,
    );
    return writtendata;
  }

static Future<String?> readCredentialData(String keyName) async {
    final flutterSecureStorage = FlutterSecureStorage();
    var readDataFound = await flutterSecureStorage.read(key: keyName);
    return readDataFound;
  }

  static Future<ApiResponse?> post(String apiName, Object payload) async {
    print("payload sent to the server api ${payload}");
    try {
      final result = await ApiWrapper().postApi(url: apiName, param: payload);
      print("result in controller class ${result!.success}");
        
 
      return result;
    } catch (e) {
      print("Error fetching plan provider data: $e");
      return null;
    }
  }


 static Future<ApiResponse?> commonforGetApicall(String apiName, ) async {
    try {
      final result = await ApiWrapper().getApi(url: apiName, );
      print("result in controller class ${result!.success}");
        
 
      return result;
    } catch (e) {
      print("Error fetching plan provider data: $e");
      return null;
    }
  }

  static Future<ApiResponse?> logout(String apiName, Object payload) async {
    try {
      final result = await ApiWrapper().postApi(url: apiName, param: payload);
      print("result in controller class ${result!.success}");
      return result;
    } catch (e) {
      print("Error fetching plan provider data: $e");
      return null;
    }
  }


  static Future<ApiResponse?> forgetPasswod(String apiName, Object payload) async {
    try {
      final result = await ApiWrapper().postApi(url: apiName, param: payload);
      print("result in controller class ${result!.success}");
      return result;
    } catch (e) {
      print("Error fetching plan provider data: $e");
      return null;
    }
  }

   static Future<ApiResponse?> resetPass(String apiName, Object payload) async {
    try {
      final result = await ApiWrapper().postApi(url: apiName, param: payload);
      print("result in controller class ${result!.success}");
      return result;
    } catch (e) {
      print("Error fetching plan provider data: $e");
      return null;
    }
  }
}
