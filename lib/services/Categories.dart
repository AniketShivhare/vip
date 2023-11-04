import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:e_commerce/services/tokenId.dart';

class Categories {

  static List<String> categories = [],
      subCategories = [];
  static int pindex=1;

  static Future<void> getAllCategory12() async {
    if (categories.length > 0) return;
    final apiUrl = "https://api.pehchankidukan.com/seller/category";
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${TokenId.token}',
      },
    );

    // if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    print(jsonData);
    categories = jsonData["data"][0]["category"];
    print("cattt");
    print(categories);
    // }
  }

  static Future<void> getSubCategories(category) async {
    category = category.replaceAll('&', '%26');
    final apiUrl = "https://api.pehchankidukan.com/seller/category?category=$category";
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${TokenId.token}',
      },
    );

    // if (response.statusCode == 200) {
    // final  Map<String,dynamic>jsonData = jsonDecode(response.body);
    // print(jsonData);
    // subCategories = jsonData["data"][0]["subCategory1"]as List<String>;
    final Map<String, dynamic> jsonData = jsonDecode(response.body);
    final List<dynamic> data = jsonData["data"];
    final List<String> stringData = data.map((item) => item.toString()).toList();
      //   if (data.isNotEmpty && data[0] is Map) {
      //     final subCategory1Data = data[0] as Map<String, dynamic>;
      //     if (subCategory1Data.containsKey("data") &&
      //         subCategory1Data["data"] is List) {
      //       subCategories = subCategory1Data["data"].map<String>((item) {
      //         if (item is String) {
      //           return item;
      //         } else {
      //           return item.toString(); // Handle non-string values gracefully
      //         }
      //       }).toList();
      //     }
      //   }
      // }
      //
      // if (subCategories.isEmpty) {
      //   // Handle the case where subCategories are empty or not found in the JSON data
      //   // You can set default values or show an error message.
      // }
    // print(jsonData);
      subCategories = stringData;
      //
      // print("cattt");
      print(subCategories);
      // return subCategories;

  }
}