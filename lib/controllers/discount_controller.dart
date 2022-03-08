import 'dart:convert';
import 'package:fishe_tender_fisher/models/discount/discount_list_item_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';

class DiscountConroller extends ChangeNotifier {
  static Map<String, String> headers = {
    'Accept': 'application/json',
    'X-Requested-With': 'XMLHttpRequest'
  };

  static Future getDiscountList(String token, int pageNumber) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
    };
    http.Response response = await http.get(
      Uri.parse(
        baseUrl + "discounts?page=$pageNumber",
      ),
      headers: headers,
    );
    final Map<String, dynamic> responseData = json.decode(response.body);
    print('this is getDiscountList response : ' + response.body);
    if (response.statusCode == 200) {
      List<Discountlist> discounts = [];
      for (int i = 0; i < responseData['data'].length; i++) {
        discounts.add(Discountlist.fromMap(responseData['data'][i]));
      }
      print('length of getDiscountList : ' + '${discounts.length}');
      var next = responseData['links']['next'];
      print(next);
      return {
        'data': discounts,
        'next': next,
      };
    } else {
      return {};
    }
  }

  static Future<Map<String, dynamic>> postDiscount({
    required String token,
    required int value,
    required String from,
    required String to,
    required int produtId,
  }) async {
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
    };
    http.Response response = await http.post(
      Uri.parse(baseUrl + 'discounts'),
      headers: headers,
      body: jsonEncode(
        {
          'value': value,
          'from': from,
          'to': to,
          'fisher_product_id': produtId,
        },
      ),
    );
    final Map<String, dynamic> responseData = json.decode(response.body);
    print(response.reasonPhrase);
    print(responseData);
    return responseData;
  }

  static Future editDiscount({
    required String token,
    required String value,
    required String from,
    required String to,
    required String discountId,
  }) async {
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
    };
    http.Response response = await http.put(
      Uri.parse(baseUrl + 'discounts/$discountId'),
      headers: headers,
      body: jsonEncode(
        {
          'value': double.parse(value).toInt(),
          'from': from,
          'to': to,
        },
      ),
    );
    print(response.body);
    return response.reasonPhrase;
  }

  static Future deleteDiscount(String token, int id) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'X-Requested-With': 'XMLHttpRequest',
      'Authorization': "Bearer $token",
    };

    http.Response response = await http.delete(
      Uri.parse(baseUrl + "discounts/$id"),
      headers: headers,
    );
    print(response.body);
    print(response.statusCode);

    return response.reasonPhrase;
  }
}
