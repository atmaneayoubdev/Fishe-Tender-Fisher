import 'package:fishe_tender_fisher/models/products/image_model.dart';
import 'package:fishe_tender_fisher/models/auth/logo_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import 'dart:convert';

class ImageLogoController with ChangeNotifier {
  static Future getImage(
      {required String token, String? name, required int pageNumber}) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
      'X-Requested-With': 'XMLHttpRequest'
    };
    http.Response response = await http.get(
      Uri.parse(name == null
          ? baseUrl + "images?type=1&page=$pageNumber"
          : baseUrl + "images?type=1&search=$name&page=$pageNumber"),
      headers: headers,
    );
    final Map<String, dynamic> responseData = json.decode(response.body);
    print(responseData);

    print(response.body);

    if (response.statusCode == 200) {
      print('response conatins data');

      List<Img> images = [];
      for (int i = 0; i < responseData['data'].length; i++) {
        images.add(Img.fromMap(responseData['data'][i]));
      }

      print('length of images : ' + ' ${images.length}');
      var next = responseData['links']['next'];
      print(responseData);
      print(next);
      return {
        'data': images,
        'next': next,
      };
    } else {
      return [];
    }
  }

  static Future getLogo({
    required String token,
    String? name,
    required int pageNumber,
  }) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
      'X-Requested-With': 'XMLHttpRequest'
    };
    http.Response response = await http.get(
      Uri.parse(
        name == null
            ? baseUrl + "images?type=2&page=$pageNumber"
            : baseUrl + "images?type=2&search=$name&page=$pageNumber",
      ),
      headers: headers,
    );
    final Map<String, dynamic> responseData = json.decode(response.body);
    print(responseData);

    print(response.body);
    if (response.statusCode == 200) {
      print('response conatins data');

      List<Logo> logos = [];
      for (int i = 0; i < responseData['data'].length; i++) {
        logos.add(Logo.fromMap(responseData['data'][i]));
      }
      var next = responseData['links']['next'];
      print(next);

      return {
        'data': logos,
        'next': next,
      };
    } else {
      return [];
    }
  }
}
