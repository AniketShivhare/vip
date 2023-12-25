import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:e_commerce/services/tokenId.dart';

import '../apis/orderModel.dart';

class Categories {

  static List<String> categories = [],
      subCategories = [],images=[];
  static int pindex=1;
  static List<Order> orders =[];
  static bool viewmore=false;
  static bool viewmore1=false;

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

    final Map<String, dynamic> jsonData = jsonDecode(response.body);
    List<dynamic> data = jsonData["data"];
    final List<String> stringData = data.map((item) => item.toString()).toList();
    List<String> subCat  = data.map((item) => item["subCategory1"].toString()).toList();
    subCategories = subCat;

    print("cattt");
      print(subCategories);
      // return subCategories;

  }
}