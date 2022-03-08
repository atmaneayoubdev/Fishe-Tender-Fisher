import 'dart:convert';
import 'package:fishe_tender_fisher/models/orders/order2_model.dart';
import 'package:fishe_tender_fisher/models/orders/order_count_model.dart';
import 'package:fishe_tender_fisher/models/orders/order_get_details_model.dart';
import 'package:fishe_tender_fisher/models/orders/order_model.dart';
import 'package:fishe_tender_fisher/models/orders/order_user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';

class OrderController extends ChangeNotifier {
  static Map<String, String> headers = {
    'Accept': 'application/json',
    'X-Requested-With': 'XMLHttpRequest'
  };
  static Future<List<Order>> getUserOrdersList(String token, int id) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
    };
    http.Response response = await http.get(
      Uri.parse(
        baseUrl + "users/$id/orders",
      ),
      headers: headers,
    );
    final Map<String, dynamic> responseData = json.decode(response.body);
    print(response.body);

    if (response.statusCode == 200) {
      print('fetProductsList conatins data');
      List<Order> orders = [];
      for (int i = 0; i < responseData['data'].length; i++) {
        orders.add(Order.fromMap(responseData['data'][i]));
      }
      print('length of getProductsList : ' + '${orders.length}');

      return orders;
    } else {
      return [];
    }
  }

  static Future<OrderUser> getUserDetails(String token, int id) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
    };
    http.Response response = await http.get(
      Uri.parse(
        baseUrl + 'users/$id',
      ),
      headers: headers,
    );
    final Map<String, dynamic> responseData = json.decode(response.body);

    if (response.statusCode == 200) {
      print('getUserDetails conatins data');
      print(response.body);
      OrderUser _userDetails;
      _userDetails = OrderUser.fromMap(responseData['data']);

      return _userDetails;
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  static Future getOrdersList(String token, int pageNumber) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
    };
    http.Response response = await http.get(
      Uri.parse(
        baseUrl + "orders?page=$pageNumber",
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
      print(response.body);
      List<Order2> orders = [];
      for (int i = 0; i < responseData['data'].length; i++) {
        orders.add(Order2.fromMap(responseData['data'][i]));
      }
      var next = responseData["links"]["next"];
      print(responseData);

      return {
        "data": orders,
        "next": next,
      };
    } else {
      return [];
    }
  }

  static Future<OrderGetDetail> getOrderDetails(String token, String id) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
    };
    http.Response response = await http.get(
      Uri.parse(
        baseUrl + 'orders/$id',
      ),
      headers: headers,
    );
    final Map<String, dynamic> responseData = json.decode(response.body);
    print(response.body);
    if (response.statusCode == 200) {
      print('getOrderDetails conatins data');
      OrderGetDetail _orderDetails;
      _orderDetails = OrderGetDetail.fromMap(responseData['data']);

      return _orderDetails;
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  static Future<String> updateOrderState(
    String token,
    String id,
    String state,
  ) async {
    var headers = {
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
      'X-Requested-With': 'XMLHttpRequest'
    };
    final Map<String, dynamic> product = {
      "state": '$state',
    };
    http.Response response = await http.put(
      Uri.parse(
        baseUrl + 'orders/$id',
      ),
      body: product,
      headers: headers,
    );
    final Map<String, dynamic> responseData = json.decode(response.body);
    print(responseData);
    return response.reasonPhrase.toString();
  }

  static Future<OrderCountModel> getOrderCount(String token) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
    };
    http.Response response = await http.get(
      Uri.parse(
        baseUrl + 'orders/count',
      ),
      headers: headers,
    );
    final Map<String, dynamic> responseData = json.decode(response.body);
    print(responseData);
    if (response.statusCode == 200) {
      OrderCountModel orderCountModel;
      orderCountModel = OrderCountModel.fromMap(
        responseData['data'][0],
      );
      return orderCountModel;
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  static Future cancelOrder(
      {required String token,
      required String id,
      required String message}) async {
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'X-Requested-With': 'XMLHttpRequest',
      'Authorization': "Bearer $token",
    };
    http.Response response = await http.post(
      Uri.parse(baseUrl + "orders/cancel"),
      body: jsonEncode({
        "order_id": id,
        "message": message,
      }),
      headers: headers,
    );
    print(response.body);
    print(response.statusCode);

    return response.reasonPhrase;
  }

  static Future orderReceived(
      {required String token, required String id}) async {
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'X-Requested-With': 'XMLHttpRequest',
      'Authorization': "Bearer $token",
    };
    http.Response response = await http.post(
      Uri.parse(baseUrl + "orders/receive"),
      body: jsonEncode({
        "order_id": id,
      }),
      headers: headers,
    );
    print(response.body);
    print(response.statusCode);

    return response.reasonPhrase;
  }

  static Future setDeliveryBy(
      {required String token,
      required String state,
      required String orderId}) async {
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'X-Requested-With': 'XMLHttpRequest',
      'Authorization': "Bearer $token",
    };
    http.Response response = await http.post(
      Uri.parse(baseUrl + "orders/set-delivery/$orderId"),
      body: jsonEncode({
        "delivery_by": state,
      }),
      headers: headers,
    );
    print(response.body);
    print(response.statusCode);
    return response.reasonPhrase;
  }

  static Future<String> getDeliveryPrice(String token) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
    };
    Stopwatch stopwatch = new Stopwatch()..start();

    http.Response response = await http.get(
      Uri.parse(
        baseUrl + 'fisher-delivery-price',
      ),
      headers: headers,
    );
    print(stopwatch.elapsedMilliseconds / 1000);
    stopwatch.stop();
    final Map<String, dynamic> responseData = json.decode(response.body);
    print(responseData);
    if (responseData.containsKey("success")) {
      return responseData["data"]["fisher_delivery_price"];
    } else {
      return 'error';
    }
  }
}
