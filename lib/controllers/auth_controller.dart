import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fishe_tender_fisher/models/auth/user_model.dart';
import 'package:fishe_tender_fisher/models/auth/logo_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';

class AuthController with ChangeNotifier {
  static Map<String, String> headers = {
    'Accept': 'application/json',
    'X-Requested-With': 'XMLHttpRequest'
  };

  // sendSmsVerfication function ;

  static Future sendSmsVerification(String phoneNumber) async {
    final Map<String, dynamic> loginData = {
      'phone': phoneNumber,
    };
    http.Response response = await http.post(
      Uri.parse(baseUrl + "authenticate"),
      body: loginData,
      headers: headers,
    );
    final Map<String, dynamic> responseData = json.decode(response.body);
    print(responseData);
    if (responseData.containsKey('success')) {
      return responseData;
    } else {
      return responseData;
    }
  }

  static Future<Map> deleteAcoount(String token, String message) async {
    final Map<String, dynamic> loginData = {
      'message': message,
    };
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    http.Response response = await http.post(
      Uri.parse(baseUrl + "delete_account"),
      body: loginData,
      headers: headers,
    );
    final Map<String, dynamic> responseData = json.decode(response.body);
    print(responseData);
    return responseData;
  }

  //phone number verification
  static Future<String> verifyPhoneNumber(
      String phoneNumber, String code) async {
    final Map<String, dynamic> codeVerificationData = {
      'phone': phoneNumber,
      'code': code,
    };
    http.Response response = await http.post(
      Uri.parse(baseUrl + "code-verification"),
      body: codeVerificationData,
      headers: headers,
    );
    FirebaseMessaging fcm;

    final Map<String, dynamic> responseData = json.decode(response.body);

    print(response.body);
    var prefs = await SharedPreferences.getInstance();
    if (responseData.containsKey('token')) {
      prefs.setString('token', responseData['token']);
      fcm = FirebaseMessaging.instance;
      fcm.getToken().then((value2) {
        if (value2 != null) {
          print(value2);
          AuthController.updateDeviceToken(responseData['token'], value2);
        }
      });

      return responseData["fisher"]["status"].toString();
      // save
    } else {
      return "error";
    }

    //logout
  }

  static Future updateDeviceToken(String token, String phoneToken) async {
    var headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    final Map<String, dynamic> codeVerificationData = {
      'device_token': phoneToken,
    };
    http.Response response = await http.post(
      Uri.parse(baseUrl + "update/device-token"),
      body: jsonEncode(codeVerificationData),
      headers: headers,
    );
    print("this is the it ---------------" + response.body);
  }

  static Future<String> logOut(String token) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'X-Requested-With': 'XMLHttpRequest',
      'Authorization': "Bearer $token",
    };
    http.Response response = await http.post(
      Uri.parse(baseUrl + "logout"),
      headers: headers,
    );
    print(response.body);
    print(response.statusCode);
    var prefs = await SharedPreferences.getInstance();

    if (response.statusCode == 200) {
      await prefs.clear();
      return 'success';
      // save
    } else {
      return 'error';
    }
  }

  static Future<User> getUser(String token) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'X-Requested-With': 'XMLHttpRequest',
      'Authorization': "Bearer $token",
    };
    Stopwatch stopwatch = new Stopwatch()..start();
    http.Response response = await http.get(
      Uri.parse(baseUrl + "me"),
      headers: headers,
    );
    print(stopwatch.elapsedMilliseconds / 1000);
    stopwatch.stop();
    Map<String, dynamic> responseData = json.decode(response.body);
    print(responseData);
    if (responseData.containsKey('fisher')) {
      responseData.addAll({"token": token});
      return User.fromMap(responseData);
    } else {
      if (responseData.containsKey("message")) {
        if (responseData["message"] == "Unauthenticated.")
          return User(id: "Unauthenticated");
      }
      return User(id: "0");
    }
  }

  //update user infoi

  static Future updateUser({
    required String token,
    required String name,
    required String nameAr,
    required String phoneNumber,
    required String email,
    required String iban,
    required String regestrNumber,
    required String adresse,
    required String startWorkTime,
    required String endWorkTime,
    required String bankName,
    required String city,
    required String latitude,
    required String longitude,
  }) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
    };
    final Map<String, dynamic> updateData = {
      'name': name,
      'name_ar': nameAr,
      'commercial_registration_number': regestrNumber,
      'iban': iban,
      //'phone': phoneNumber,
      'bank_name': bankName,
      'latitude': latitude,
      'longitude': longitude,
      'city': city,
      'address': adresse,
      'email': email,
      'start_work_time': startWorkTime,
      'end_work_time': endWorkTime,
    };
    http.Response response = await http.post(
      Uri.parse(baseUrl + 'update'),
      body: updateData,
      headers: headers,
    );
    final Map<String, dynamic> responseData = json.decode(response.body);
    print(responseData);
    if (responseData.containsKey('success')) {
      return 'success';
    } else {
      return responseData['errors'];
    }
  }

  static Future updateCommercialRegister(String token, File? file) async {
    var headers = {
      'Content-type': 'multipart/from-data',
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
    };
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(baseUrl + 'update/commercial-register'),
    );
    request.files.add(await http.MultipartFile.fromPath(
      'commercial_registration_pdf',
      file!.path,
    ));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    print(response.stream.bytesToString());
    if (response.statusCode == 200) {
      print(response.reasonPhrase);
    } else {
      print(response.reasonPhrase);
    }
  }

  static Future updateUserLogo({
    required String token,
    Logo? logo,
    File? file,
    required bool isAdding,
  }) async {
    var headers = {
      'Content-type': 'multipart/from-data',
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
    };
    var request =
        http.MultipartRequest('POST', Uri.parse(baseUrl + 'update/logo'));
    if (isAdding) {
      request.files.add(await http.MultipartFile.fromPath('link', file!.path));
    } else {
      request.fields.addAll({'logo': logo!.id.toString()});
    }
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    print(await response.stream.bytesToString());
    print(response.reasonPhrase);
    return response.reasonPhrase;
  }
}
