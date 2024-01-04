import 'dart:convert';
import 'dart:math';

import 'package:e_commerce/apis/ProductSearchModel.dart';
import 'package:e_commerce/services/tokenId.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchGlobalProduct {
  static Future<List<Product2>> filterProductByBarcode(barcodenumber) async {
    print("barcodenumber: ");
    print(barcodenumber);
    try {
      var url =
          "https://api.pehchankidukan.com/seller/65198bcd27548250067db402/globalProducts/search?barCode=$barcodenumber";
      final uri = Uri.parse(url);
      final response = await http.get(uri, headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY1OTZhMTM5YTM5MTgxODBjNjY2NTkwYyIsImlhdCI6MTcwNDM3MDQ5NywiZXhwIjoxNzA2OTYyNDk3fQ._aVuX9MXtBypvB_uEW9eJbVEvSOXHNMXqvp58r_Z5HY'
      });
      if (response.statusCode == 200) {
        final body = response.body;
        final searchProduct = jsonDecode(body);
        List<Product2> products = (searchProduct['data'] as List<dynamic>?)
                ?.map((e) => Product2.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [];
        print("productshgdfsdsfdggdfs");
        print(products);
        return products;
      } else {
        print('Failed to get orders. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('error: $e');
    }
    return [];
  }
}
