import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:jaantradersindia/ApiHandler/networkConstant.dart';

class ApiResponse {
  String? success;
  dynamic data;
  String? message;

  ApiResponse();

  factory ApiResponse.fromJson(dynamic json) {
    ApiResponse model = ApiResponse();
    model.success = json['status'] == "true"?"true":"false";
    model.data = json['data'];
    model.message = json['message'];

    if (model.success != true &&
        model.data != null &&
        model.message?.isEmpty == true) {
      var errors = model.data['errors'];
      if (errors != null) {
        var messages = model.data['errors']['message'];
        if (messages != null) {
          model.message = (messages as List).first;
        } else {
          if (model.data['errors'] is Map) {
            List errors = (model.data['errors'] as Map).values.first;
            model.message = errors.first;
          }
        }
      }
    }

    return model;
  }
}

class ApiWrapper {
  final JsonDecoder _decoder = const JsonDecoder();

  Future<ApiResponse?> getApiWithoutToken({required String url}) async {
    String urlString = '${NetworkConstantsUtil.baseUrl}$url';

    return http.get(Uri.parse(urlString)).then((http.Response response) async {
      dynamic data = _decoder.convert(response.body);
      print(data);
      // Loader.dismiss();

      return ApiResponse.fromJson(data);
    });
  }

  Future<ApiResponse?> getApi({required String url}) async {
    // String? authKey = await SharedPrefs().getAuthorizationKey();
    String urlString = '${NetworkConstantsUtil.baseUrl}$url';

    print(urlString);
    // print(authKey);

    return http.get(Uri.parse(urlString), headers: {
      // "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      dynamic data = _decoder.convert(response.body);
      // Loader.dismiss();
      return ApiResponse.fromJson(data);
    });
  }

  Future<ApiResponse?> postApi({required String url, required dynamic param}) async {
  // String? authKey = await SharedPrefs().getAuthorizationKey();

  String urlString = '${NetworkConstantsUtil.baseUrl}$url';
  print('Request URL: $urlString');
  print('Request Params: ${jsonEncode(param)}');

  try {
    final response = await http.post(
      Uri.parse(urlString),
      body: jsonEncode(param),
      headers: {
        // "Authorization": "Bearer ${authKey!}",
        'Content-Type': 'application/json'
      },
    );

    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      dynamic data = jsonDecode(response.body);
      print("Data received from API call: $data");

      // Check if the data contains success: false
      if (data['success'] == false) {
        print('API response indicates failure: ${data['message']}');
        return null;
      }

      return ApiResponse.fromJson(data);
    } else {
      print('Server error: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error during API call: $e');
    return null;
  }
}



  Future<ApiResponse?> putApi(
      {required String url, required dynamic param}) async {
    // String? authKey = await SharedPrefs().getAuthorizationKey();
    // Loader.show(status: loadingString.tr);

    return http.put(Uri.parse('${NetworkConstantsUtil.baseUrl}$url'),
        body: jsonEncode(param),
        headers: {
          // "Authorization": "Bearer ${authKey!}",
          'Content-Type': 'application/json'
        }).then((http.Response response) async {
      dynamic data = _decoder.convert(response.body);
      // print(data);
      // Loader.dismiss();

      return ApiResponse.fromJson(data);
    });
  }

  Future<ApiResponse?> deleteApi({required String url}) async {
    // String? authKey = await SharedPrefs().getAuthorizationKey();
    // Loader.show(status: loadingString.tr);

    // print('${NetworkConstantsUtil.baseUrl}$url');
    return http.delete(Uri.parse('${NetworkConstantsUtil.baseUrl}$url'),
        headers: {
          // "Authorization": "Bearer $authKey",
          'Content-Type': 'application/json'
        }).then((http.Response response) async {
      dynamic data = _decoder.convert(response.body);
      // print(data);
      // Loader.dismiss();

      return ApiResponse.fromJson(data);
    });
  }

  Future<ApiResponse?> postApiWithoutToken(
      {required String url, required dynamic param}) async {
    // Loader.show(status: loadingString.tr);
    print(param);
    var uri = Uri.parse('${NetworkConstantsUtil.baseUrl}$url');
    print("========================>called $uri");

    return http.post(uri, body: param,).then((http.Response response) async {
      if (response.body.isEmpty) {
        // Handle the case where the response body is empty
        throw const FormatException("Response body is empty");
      }
      print("===================data after api hit response ${response.statusCode}");
      print('body: ${response.body}');
      dynamic data = _decoder.convert(response.body);


      // Loader.dismiss();

      return ApiResponse.fromJson(data);
    });
  }

  
 
}
