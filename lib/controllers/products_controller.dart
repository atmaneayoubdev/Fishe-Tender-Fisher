import 'dart:convert';
import 'dart:io';
import 'package:fishe_tender_fisher/models/products/categorie_model.dart';
import 'package:fishe_tender_fisher/models/products/fisher_product_detail_model.dart';
import 'package:fishe_tender_fisher/models/products/fisher_products_model.dart';
import 'package:fishe_tender_fisher/models/products/product_model.dart';
import 'package:fishe_tender_fisher/models/products/section_model.dart';
import 'package:fishe_tender_fisher/models/products/service_model.dart';
import 'package:fishe_tender_fisher/models/products/services_addition_model.dart';
import 'package:fishe_tender_fisher/models/products/unit_model.dart';
import 'package:fishe_tender_fisher/models/products/units_addition_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';

class ProductsControlller extends ChangeNotifier {
  static Map<String, String> headers = {
    'Accept': 'application/json',
    'X-Requested-With': 'XMLHttpRequest'
  };
  static Future getCategories({
    String? token,
    int? sectionId,
    String? fisherId,
    required int pageNumber,
    required bool bySection,
  }) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
      'X-Requested-With': 'XMLHttpRequest'
    };
    http.Response response = await http.get(
      Uri.parse(
        bySection
            ? baseUrl + "categories?section=$sectionId&page=$pageNumber"
            : baseUrl + "categories?fisher=$fisherId&page=$pageNumber",
      ),
      headers: headers,
    );
    final Map<String, dynamic> responseData = json.decode(response.body);

    if (response.statusCode == 200) {
      print('getCategories conatins data');

      print(response.body);
      List<Categorie> categories = [];
      for (int i = 0; i < responseData['data'].length; i++) {
        categories.add(Categorie.fromMap(responseData['data'][i]));
      }
      var next = responseData['links']['next'];
      print(next);
      print('length of getCategories : ' + '${categories.length}');

      return {
        'data': categories,
        'next': next,
      };
    } else {
      return {};
    }
  }

  static getunits(String token, int page) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
      'X-Requested-With': 'XMLHttpRequest'
    };
    http.Response response = await http.get(
      Uri.parse(
        baseUrl + "units?page=$page",
      ),
      headers: headers,
    );
    final Map<String, dynamic> responseData = json.decode(response.body);
    print(response.body);
    if (response.statusCode == 200) {
      print('getunits conatins data');
      print(response.body);
      List<Unit> units = [];
      for (int i = 0; i < responseData['data'].length; i++) {
        units.add(Unit.fromMap(responseData['data'][i]));
      }

      var next = responseData['links']['next'];
      print(next);

      return {
        'data': units,
        'next': next,
      };
    } else {
      return [];
    }
  }

  static Future getService(String token, int page) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
      'X-Requested-With': 'XMLHttpRequest'
    };
    http.Response response = await http.get(
      Uri.parse(
        baseUrl + "services?page=$page",
      ),
      headers: headers,
    );
    final Map<String, dynamic> responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      print('getServices conatins data');
      print(response.body);
      List<Service> seriveces = [];
      for (int i = 0; i < responseData['data'].length; i++) {
        seriveces.add(Service.fromMap(responseData['data'][i]));
      }
      print('length of getService : ' + '${seriveces.length}');

      var next = responseData['links']['next'];
      print(next);

      return {
        'data': seriveces,
        'next': next,
      };
    } else {
      return [];
    }
  }

  static Future getProductsList(
      {String? token, int? categoryId, required int page}) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
    };
    http.Response response = await http.get(
      Uri.parse(
        baseUrl + "products?category=$categoryId&page=$page",
      ),
      headers: headers,
    );
    final Map<String, dynamic> responseData = json.decode(response.body);
    print(response.body);

    if (response.statusCode == 200) {
      print('fetProductsList conatins data');
      List<Product> products = [];
      for (int i = 0; i < responseData['data'].length; i++) {
        products.add(Product.fromMap(responseData['data'][i]));
      }
      print('length of getProductsList : ' + '${products.length}');
      //var next = responseData['links']['next'];
      //print(next);
      return {
        'data': products,
        'next': null,
      };
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  static Future getFisherProducts({
    required String token,
    required int pageNumber,
    required int categoryId,
    required bool isAll,
  }) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
    };
    http.Response response = await http.get(
      Uri.parse(
        isAll
            ? baseUrl + "fisher-products?page=$pageNumber"
            : baseUrl + "fisher-products?page=$pageNumber&category=$categoryId",
      ),
      headers: headers,
    );
    final Map<String, dynamic> responseData = json.decode(response.body);

    if (response.statusCode == 200) {
      print('getFisherProducts conatins data');
      print(response.body);
      List<FisherProducts> fisherProducts = [];

      for (int i = 0; i < responseData['data'].length; i++) {
        fisherProducts.add(FisherProducts.fromMap(responseData['data'][i]));
      }
      print('length of getFisherProducts : ' + '${fisherProducts.length}');

      var next = responseData['links']['next'];
      print(next);
      return {
        'data': fisherProducts,
        'next': next,
      };
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  static Future getFisherProductDetails(
    String token,
    int id,
  ) async {
    var headers = {
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
    };
    http.Response response = await http.get(
      Uri.parse(
        baseUrl + 'fisher-products/$id',
      ),
      headers: headers,
    );
    final Map<String, dynamic> responseData = json.decode(response.body);
    print(response.body);

    if (response.statusCode == 200) {
      print('getFisherProductDetails conatins data');

      FisherProductsDetails fisherProductDetail =
          FisherProductsDetails.fromMap(responseData['data']);
      print(fisherProductDetail.services);
      return fisherProductDetail;
    } else {
      print('getFisherProductDetails does not conatin data');
      throw Exception(response.reasonPhrase);
    }
  }

  static Future deleteFisherProduct(String token, int id) async {
    var headers = {
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
    };
    http.Response response = await http.delete(
      Uri.parse(
        baseUrl + 'fisher-products/$id',
      ),
      headers: headers,
    );
    final Map<String, dynamic> responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      print(responseData);
    } else {
      print(response.reasonPhrase);
    }
  }

  static Future addFisherProduct({
    required String? token,
    required String? productId,
    required List<int> images,
    required List<AddUnit> units,
    required List<AddService> services,
    required List<File> fileImages,
  }) async {
    Dio dio = new Dio();

    Map<String, String> headers = {
      'Content-type': 'multipart/from-data',
      "Accept": "application/json",
      'Authorization': "Bearer $token",
    };
    var _units = units.map((item) {
      return {
        "unit": double.parse(item.id).toInt(),
        "price": double.parse(item.price),
      };
    }).toList();
    var _services = services.map((item) {
      return {
        "service": double.parse(item.id).toInt(),
        "price": double.parse(item.price)
      };
    }).toList();

    List<MultipartFile> files = [];
    for (var item in fileImages) {
      String fileName = item.path.split('/').last;
      files.add(await MultipartFile.fromFile(
        item.path,
        filename: fileName,
      ));
    }
    print(files);
    FormData formData = FormData.fromMap({
      'product_id': productId,
      "images[]": images,
      "units": _units,
      "services": _services,
      'new_images[]': files,
    });
    print(formData);
    for (var item in formData.fields) {
      print(item);
    }
    var response = await dio.post(baseUrl + "fisher-products",
        data: formData,
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ));
    print(response.data);
    print(response.statusCode);
    return response.statusMessage!;
  }

  static Future updateFisherProduct({
    required String token,
    required String id,
    required String productId,
    required List<int> images,
    required List<AddUnit> units,
    required List<AddService> services,
    required List<File> fileImages,
  }) async {
    Dio dio = new Dio();

    Map<String, String> headers = {
      "Accept": "application/json",
      'Authorization': "Bearer $token",
    };
    var _units = units.map((item) {
      return {
        "unit": double.parse(item.id).toInt(),
        "price": double.parse(item.price),
      };
    }).toList();
    var _services = services.map((item) {
      return {
        "service": double.parse(item.id).toInt(),
        "price": double.parse(item.price)
      };
    }).toList();

    List<MultipartFile> files = [];
    for (var item in fileImages) {
      String fileName = item.path.split('/').last;
      files.add(await MultipartFile.fromFile(
        item.path,
        filename: fileName,
      ));
    }
    print(files);

    FormData formData = FormData.fromMap({
      'product_id': productId,
      "images[]": images,
      "units": _units,
      "services": _services,
      'new_images[]': files,
    });
    print('formdata :' + formData.toString());
    for (var item in formData.fields) {
      print(item);
    }

    var response = await dio.post(baseUrl + "fisher-products/$id",
        data: formData,
        options: Options(
          responseType: ResponseType.json,
          followRedirects: false,
          validateStatus: (status) => true,
          headers: headers,
        ));

    print(response.data);
    print(response.statusCode);
    print(response.statusMessage);

    return response.statusMessage!;
  }

  static Future<List<Section>> getSectionList(String token) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
    };
    Stopwatch stopwatch = new Stopwatch()..start();
    http.Response response = await http.get(
      Uri.parse(
        baseUrl + 'sections',
      ),
      headers: headers,
    );
    print(stopwatch.elapsedMilliseconds / 1000);
    stopwatch.stop();
    final Map<String, dynamic> responseData = json.decode(response.body);
    print(response.body);
    if (response.statusCode == 200) {
      print('getFisherProducts conatins data');
      List<Section> _sections = [];
      for (int i = 0; i < responseData['data'].length; i++) {
        _sections.add(Section.fromMap(responseData['data'][i]));
      }
      print('length of getSectionList : ' + '${_sections.length}');
      return _sections;
    } else {
      return [];
    }
  }

  static Future updateActiveStatus(
    String token,
    int id,
    String status,
  ) async {
    var headers = {
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
    };
    final Map<dynamic, dynamic> product = {
      "is_active": status,
    };
    http.Response response = await http.put(
      Uri.parse(
        baseUrl + "fisher-product/$id/active",
      ),
      body: product,
      headers: headers,
    );
    final Map<String, dynamic> responseData = json.decode(response.body);
    print(response.body);

    print(responseData);
    if (responseData.containsKey("success")) {
      return responseData["data"]["product"]["is_active"];
    }
  }
}
