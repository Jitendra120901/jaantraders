import 'package:jaantradersindia/ApiHandler/apiWrapper.dart';

class AuthControllers {
  static Future<ApiResponse?> login(String apiName, Object payload) async {
    try {
      final result = await ApiWrapper().postApi(url: apiName, param: payload);
      print("result in controller class ${result!.success}");
      return result;
    } catch (e) {
      print("Error fetching plan provider data: $e");
      return null;
    }
  }}