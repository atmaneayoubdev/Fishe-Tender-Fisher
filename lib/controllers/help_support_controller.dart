import 'package:fishe_tender_fisher/models/FAQ/subject_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../constants.dart';

class HelpSupportController extends ChangeNotifier {



  
  static Future<List<Subject>> getFaqList(String token) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
    };
    http.Response response = await http.get(
      Uri.parse(
        baseUrl + "faq",
      ),
      headers: headers,
    );
    final Map<String, dynamic> responseData = json.decode(response.body);
    print(response.body);

    if (response.statusCode == 200) {
      print('getCategories conatins data');

      List<Subject> _subjects = [];
      for (int i = 0; i < responseData['data']['subjects'].length; i++) {
        _subjects.add(Subject.fromMap(responseData['data']['subjects'][i]));
      }
      print('length of getFaqList : ' + '${_subjects.length}');
      return _subjects;
    } else {
      return [];
    }
  }

  static Future<String> addAsk(
      String token, Subject subject, String question) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'X-Requested-With': 'XMLHttpRequest',
      'Authorization': "Bearer $token",
    };
    Map<String, String> data = {
      'f_a_q_subject_id': '${subject.id}',
      'question': question,
    };
    http.Response response = await http.post(
      Uri.parse(baseUrl + "faq"),
      body: data,
      headers: headers,
    );
    print(response.body);
    final Map<String, dynamic> responseData = json.decode(response.body);
    if (responseData.containsKey("success")) {
      print(responseData);
      return 'success';
    } else {
      print(responseData);
      return responseData["errors"]["question"][0];
    }
  }

  static Future<List<dynamic>> getPrivacyPolicy(String token) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
    };
    http.Response response = await http.get(
      Uri.parse(
        baseUrl + "privacy-policy",
      ),
      headers: headers,
    );
    final Map<String, dynamic> responseData = json.decode(response.body);
    print(response.body);
    if (response.statusCode == 200) {
      var result = responseData['data'];
      return result;
    } else {
      return [];
    }
  }

  static Future<List<dynamic>> getTermsOfUse(String token) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
    };
    http.Response response = await http.get(
      Uri.parse(
        baseUrl + "terms-of-use",
      ),
      headers: headers,
    );
    final Map<String, dynamic> responseData = json.decode(response.body);
    print(response.body);
    if (response.statusCode == 200) {
      var result = responseData['data'];
      return result;
    } else {
      return [];
    }
  }

  static Future<List<dynamic>> getAbout(String token) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
    };
    http.Response response = await http.get(
      Uri.parse(
        baseUrl + "about-us",
      ),
      headers: headers,
    );
    final Map<String, dynamic> responseData = json.decode(response.body);
    print(response.body);
    if (response.statusCode == 200) {
      var result = responseData['data'];
      return result;
    } else {
      return [];
    }
  }

  static Future getInstructons(String token) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
    };
    http.Response response = await http.get(
      Uri.parse(
        baseUrl + "instruction",
      ),
      headers: headers,
    );
    final Map<String, dynamic> responseData = json.decode(response.body);
    print(response.body);
    if (response.statusCode == 200) {
      var result = responseData['data']["instruction"];
      print(result);
      return result;
    } else {
      return [];
    }
  }
}
