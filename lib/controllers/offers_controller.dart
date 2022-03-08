import 'dart:convert';
import 'dart:io';
import 'package:fishe_tender_fisher/models/offer/offer_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class OffersController with ChangeNotifier {
  static Future getOffers(String token, int pageNumber) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
    };
    http.Response response = await http.get(
      Uri.parse(
        baseUrl + "offers?page=$pageNumber",
      ),
      headers: headers,
    );
    final Map<String, dynamic> responseData = json.decode(response.body);
    if (responseData.containsKey("message")) {
      if (responseData["message"] == "Unauthenticated.") {
        print("zadzadazd");
        return {
          "data": "Unauthenticated",
        };
      }
    }
    if (response.statusCode == 200) {
      print('getOffers conatins data');
      List<Offer> _offers = [];
      for (int i = 0; i < responseData['data'].length; i++) {
        _offers.add(Offer.fromMap(responseData['data'][i]));
      }
      print('length of getOffers : ' + '${_offers.length}');
      var next = responseData["links"]["next"];
      return {
        "data": _offers,
        "next": next,
      };
    } else {
      return "error";
    }
  }

  static Future getOfferPricePerDay(String token) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
    };
    http.Response response = await http.get(
      Uri.parse(
        baseUrl + "offer/price",
      ),
      headers: headers,
    );
    final Map<String, dynamic> responseData = json.decode(response.body);
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print('getOfferPricePerDay');
      print(responseData["data"]["offer_price_per_day"]);
      return responseData["data"]['offer_price_per_day'];
    }
  }

  static Future<String> addOffer({
    required String token,
    File? file,
    required String categoryId,
    required String type,
  }) async {
    Map<String, String> headers = {
      'Content-type': 'multipart/from-data',
      "Accept": "application/json",
      'Authorization': "Bearer $token",
    };
    Map<String, String> data = {
      'category_id': categoryId,
      "type": type,
    };
    http.MultipartRequest request = http.MultipartRequest(
      'POST',
      Uri.parse(baseUrl + 'offers'),
    )
      ..fields.addAll(data)
      ..headers.addAll(headers);
    if (file != null)
      request.files.add(await http.MultipartFile.fromPath('link', file.path));
    http.StreamedResponse response = await request.send();
    print(await response.stream.bytesToString());
    print(response.statusCode);
    print(response.reasonPhrase);
    if (response.reasonPhrase == "Created") return "success";
    return "error";
  }

  static Future getSlidingPrice(String token) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
    };
    http.Response response = await http.get(
      Uri.parse(
        baseUrl + "offer-slide-price",
      ),
      headers: headers,
    );
    final Map<String, dynamic> responseData = json.decode(response.body);
    print(response.body);
    print(response.statusCode);
    return responseData["data"]['offer_slide_price'];
  }

  static Future getPromotionPrice(String token) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
    };
    http.Response response = await http.get(
      Uri.parse(
        baseUrl + "offer-promotion-price",
      ),
      headers: headers,
    );
    final Map<String, dynamic> responseData = json.decode(response.body);
    print(response.body);
    print(response.statusCode);
    print(responseData["data"]["offer_promotion_price"]);
    return responseData["data"]['offer_promotion_price'];
  }
}
