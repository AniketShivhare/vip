
import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:e_commerce/DataSaveClasses/ProductId.dart';
import 'package:e_commerce/apis/ReplacementModel.dart';
import 'package:e_commerce/services/filterData.dart';
import 'package:e_commerce/services/tokenId.dart';
import 'package:image_picker/image_picker.dart';
import '../apis/CustomDateRangeSalesReport.dart';
import '../apis/DailySales.dart';
import '../apis/MonthlySales.dart';
import '../apis/ProductModel.dart';
import '../apis/ProductRatingAndReviews.dart';
import '../apis/ProductSearchModel.dart';
import '../apis/RatingReviewProduct.dart';
import '../apis/ReturnModel.dart';
import '../apis/WeeklySales.dart';
import '../apis/orderModel.dart';
import 'package:http/http.dart' as http;
import 'Categories.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';

class UserApi {


  static Future<List<Product>> filterProduct(sort, queryyy, page) async {
    print("called filterrr function");
    print("id-${TokenId.id}");
    print("token-${TokenId.token}");
    String url = 'https://api.pehchankidukan.com/seller/${TokenId.id}/products?page=$page';
    int count=1;
    if(queryyy.length>0) {
      if(count==0) {
        url += '?';
        count++;
      } else
        url += '&';
      url+='keyword=$queryyy';
    }
    if(FilterOptions.changed==true)
    {
      if (FilterOptions.categories[0].isNotEmpty) {
        if(count==0) {
          url += '?';
          count++;
        } else
          url += '&';
        FilterOptions.categories[0] =
            FilterOptions.categories[0].replaceAll('&', '%26');
        url += 'category=${FilterOptions.categories[0]}';
        count++;
      }
      // if (FilterOptions.sortChanged == true) {
      //   if (count == 0) {
      //     url += '?';
      //     count++;
      //   } else
      //     url += '&';
      //   url += 'sort=${FilterOptions.sortName}';
      //   count++;
      // }
      if (FilterOptions.selectedSubCat) {
        if (count == 0) {
          url += '?';
          count++;
        } else url += '&';


        List<String>? subCategory =
            FilterOptions.subcategories[FilterOptions.categories[0]];
        print(subCategory);
        String? formattedSubCategories =
            subCategory?.map((category) => '"$category"').join(',');
        formattedSubCategories = formattedSubCategories?.replaceAll('&', '%26');
        url += 'subCategory1=[$formattedSubCategories]';
      }
    }
    if(sort.length>0) {
      if (count == 0) {
        url += '?';
        count++;
      } else url += '&';
      url += 'sort=$sort';
    }
    print("url12345");
    print(url);
    final uri = Uri.parse(url);
    final response = await http.get(uri,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${TokenId.token}'
      },
    );
    if(response.statusCode==200) {
      final body = response.body;
      final productJson = jsonDecode(body);
      print(response.statusCode);
      print(productJson);
      List<Product> products = (productJson['data'] as List<dynamic>?)
          ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList() ?? [];

      print(products);
      print("product");
      return products;
    }
    return[];
  }

  static Future<void> deleteProduct(id) async {
    print("iddiidd");
    print(id);
    final Url = 'https://api.pehchankidukan.com/seller/${TokenId.id}/products/$id';
    final url = Uri.parse(Url);

    final response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${TokenId.token}',
      },
    );
    if (response.statusCode == 200) {
      print("deletion successfull");
    } else {
      throw Exception('Failed to Delete product: ${response.reasonPhrase}');
    }
  }


  static Future<void> getAllCategory() async {
    if(Categories.categories.length>0) return;
    print("getallcategoryforfilter called");
    final apiUrl = "https://api.pehchankidukan.com/seller/category";
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${TokenId.token}',
      },
    );

    final jsonData = jsonDecode(response.body);
    print(jsonData);
    final data = (jsonData["data"]);
    // Assuming data is the JSON object you provided
    List<String> categoryList = [];
    List<String> imageURLList = [];

    for (var item in data) {
      categoryList.add(item['category']);
      // Assuming there's always at least one URL in the list
      imageURLList.add(item['categoryImageURL'][0]);
    }

// Now, you have two separate lists: categoryList and imageURLList

    Categories.categories = categoryList;
    Categories.images = imageURLList;
    // Categories.categories = jsonData["data"][0]["category"] as List<String>;
  }


  //search
  static Future<List<Product>> searchProducts(String keyword, token, id) async {
    final Url = 'https://api.pehchankidukan.com/seller/${TokenId.id}/products/search';
    final url = Uri.parse('$Url?searchTerm=$keyword');
    print("query123");
    print(keyword);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      // print(responseBody['status']);
      print("responseBody['length']");
      print(responseBody['length']);
      // print(responseBody['msg']);
      List<Product> products=[];
      try{
        List<Product> products = (responseBody['data'] as List<dynamic>?)?.map((e) =>
            Product.fromJson(e as Map<String, dynamic>)).toList() ?? [];
        print( "products.lengthnnjj");
        print( products.length);
        return products;
      } catch(e) {
        print("Error: $e");
      }
      // print(products[0].productName);
      // print(products[1].productName);
      print("products[0].globalProductID.productName");
      // print(products[0].globalProductID.productName);
      return products;
    } else {
      throw Exception('Failed to search products: ${response.reasonPhrase}');
    }
  }

  //sort and filter
    static Future<List<Product>> getSellerProducts(sort, token, id, currentPage
    ) async {
      // print(token);
    print("called recentlyadded $sort");
    print(TokenId.id);
      String baseUrl = 'https://api.pehchankidukan.com/seller/${TokenId.id}/products?sort=$sort&page=$currentPage';
      final count=1;
      print(FilterOptions.changed);
      if(FilterOptions.changed==true)
    {
      if (FilterOptions.categories[0].isNotEmpty) {
        baseUrl += '&';
        FilterOptions.categories[0] =
            FilterOptions.categories[0].replaceAll('&', '%26');
        baseUrl += 'category=${FilterOptions.categories[0]}';
      }
      if (FilterOptions.selectedSubCat) {
        List<String>? subCategory =
            FilterOptions.subcategories[FilterOptions.categories[0]];
        if (count > 1) baseUrl += '&';
        print(subCategory);
        String? formattedSubCategories =
            subCategory?.map((category) => '"$category"').join(',');
        formattedSubCategories = formattedSubCategories?.replaceAll('&', '%26');
        baseUrl += 'subCategory1=[$formattedSubCategories]';
      }
    }
    print(baseUrl);
        final url = Uri.parse(baseUrl);
        final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${TokenId.token}'
        },
      );

      final  responseBody = jsonDecode(response.body);
      print("gjfdcchvjb");
      print(responseBody['data']);
      print(responseBody['length']);
      List<Product> products=[];
    try{
      products = (responseBody['data'] as List<dynamic>?)
          ?.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList() ?? [];
      print("abcdefghijklmnop");
      return products;
    }
    catch (e){
      print("errorrr");
      print(e);
    }
      return products;
  }

  //Categories
  static Future<List<String>> getCategories(String? category, {String? subCategory1, String? subCategory2, int page = 1, int limit = 5}) async {

    final url = Uri.parse('http://api.pehchankidukan.com/seller/category');

    final Map<String, dynamic> queryParameters = {
      if (category != null) 'category': category,
      if (subCategory1 != null) 'subCategory1': subCategory1,
      if (subCategory2 != null) 'subCategory2': subCategory2,
      'page': page.toString(),
      'limit': limit.toString(),
    };

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{'queryString': queryParameters}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      return responseBody['data'];
    } else {
      throw Exception('Failed to get categories: ${response.reasonPhrase}');
    }
  }


  static Future registerPhone(var phone, var otp) async {
    final apiUrl = 'https://api.pehchankidukan.com/api/seller/register';

    Map<String, dynamic> json = {
      "phone":phone,
      "otp":otp,
    };
    var uri = Uri.parse(apiUrl);
    try {
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(json),
      );

      // if (response.statusCode == 201) {
      // } else {
      // }
    } catch (e) {

    }
  }

  //updateSeller
  static Future<void> updateSeller(token, id, Map<String, dynamic> updatedFields) async {
    // TokenId.token=token;
    // TokenId.id=id;
    final url = Uri.parse('https://api.pehchankidukan.com/seller/$id');
    print("id-$id");
    print("token-$token");
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    final response = await http.put(
      url,
      headers: headers,
      body: json.encode(updatedFields),
    );
      final data = jsonDecode(response.body);
      print("data");
      print(data);
    if (response.statusCode == 200) {
      print('Seller updated successfully');
    } else {
      print('Failed to update seller. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }


  // get all orders API
  static Future<List<Order>> fetchOrderData(filter) async {
    // final orderStreamController = StreamController<List<Order>>();
    try {
      var url = "https://api.pehchankidukan.com/seller/${TokenId.id}/orders?orderStatus=$filter";
      final uri = Uri.parse(url);
      final response = await http.get(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${TokenId.token}'
        },
      );

      if (response.statusCode == 200) {
        final body = response.body;
        final productJson = jsonDecode(body);
        List<Order> orders = (productJson['allOrders'] as List<dynamic>?)
            ?.map((e) => Order.fromJson(e as Map<String, dynamic>))
            .toList() ?? [];
        print("Order get successfulll");
        print({TokenId.token});
        return orders;
      } else {
        print('Failed to get orders. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error while fetching orders: $e');
    }
    return [];
  }


  //create Product API
  static Future<String> createProduct(Gpid, pName, category ,pSCategory1 ,pSCategory2, description, token, id, dummyProductList) async {
    final apiUrl = 'https://api.pehchankidukan.com/seller/${TokenId.id}/products';
    List<dynamic> itemOptionsMap = dummyProductList.map((item) {
      return {
        'mrpPrice': item.mrpPrice,
        'quantity': item.quantity,
        'unit': item.unit,
        'offerPrice': item.offerPrice,
        'maxOrderQuantity': item.maxOrderQuantity
      };
    }).toList();
    final Map<String, dynamic> productJson = {

      (ProductId.categoryCheck==true)?
      "globalProductID": Gpid:'',
      (ProductId.categoryCheck==false)?
      "productName": pName:'',
      (ProductId.categoryCheck==false)?
      "category": category:'',
      (ProductId.categoryCheck==false)?
      "subCategory1": pSCategory1:'',
      (ProductId.categoryCheck==false)?
      "subCategory2": pSCategory2:'',//pSCategory2,
      // "image": product.image,
      (ProductId.categoryCheck==false)?
      "description": description:'',
      "productDetails": itemOptionsMap,
    };
    var uri = Uri.parse(apiUrl);
    try {
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${TokenId.token}'
        },
        body: jsonEncode(productJson),
      );
        final body = jsonDecode(response.body);
      if (response.statusCode == 201) {
        print(body);
        print("product created succesfully");
        print(body);
        // print("body['id']");
        // print(body['data']['_id']);
        return body['message'];
      } else {
        print('Failed to create product. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print(e);
    }
    return "";
  }

  //update Product API
  static Future<void> updateProduct( pid, dummyProductList) async {
    print("called update product");
    print("pid-$pid");
    final apiUrl = 'https://api.pehchankidukan.com/seller/${TokenId.id}/products/$pid';

    List itemOptionsMap = dummyProductList.map((item) {
      return {
        'quantity': (item.quantity),
        'mrpPrice': (item.mrpPrice),
        'offerPrice': (item.offerPrice),
        'unit': item.unit,
        'maxOrderQuantity': (item.maxOrderQuantity),
        'maxOrderQuantity': (item.maxOrderQuantity),
        "inStock": true
      };
    }).toList();
    final Map<String, dynamic> productJson = {
      "productDetails": itemOptionsMap,
      "inStock": true,
    };
    print(itemOptionsMap);
    var uri = Uri.parse(apiUrl);
    try {
      final response = await http.put(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${TokenId.token}'
        },
        body: jsonEncode(productJson),
      );

      if (response.statusCode == 200) {
        print("product updated succesfully");

      } else {
        print('Failed to update product. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print(e);
    }
  }


  static Future<List<Product>> getProducts(token, id,currentPage) async {
    print("called getProducts12 function");
    print("id-> $id");
    print("token-> $token");
    final uri = Uri.parse('https://api.pehchankidukan.com/seller/${TokenId.id}/products?page=$currentPage');
    final response = await http.get(uri,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${TokenId.token}'
      },
    );
    final body = response.body;
    final productJson = jsonDecode(body);
    print(response.statusCode);
    print(productJson);
    try {
      print("bjbjbjbjbjbj");
      List<Product> products = (productJson['data'] as List<dynamic>?)?.map((e) =>
          Product.fromJson(e as Map<String, dynamic>)).toList() ?? [];
      print( "products.lengthnnjj");
      print( products.length);
      return products;
    } catch (e){
      print("Error $e");
    }
    return [];
  }

  static Future<void> uploadImage(XFile imageFile, String imageName) async {
    print(imageFile);
    print(imageName);
    final url1 = 'https://api.pehchankidukan.com/seller/${TokenId.id}';
    var request = http.MultipartRequest('PUT', Uri.parse(url1));
    request.headers['Authorization'] = 'Bearer ${TokenId.token}';
    int length = await imageFile.length();
    String fileName = basename(imageFile.path);
    request.files.add(http.MultipartFile(
      imageName,
      imageFile.readAsBytes().asStream(),
      length,
      filename: fileName,
      contentType: MediaType(
          'image', 'jpeg'), // Adjust content type accordingly
    ));
    final response = await request.send();
    if (response.statusCode == 200) {
      print('PUT images for $imageName request successful');
      print('Response: ${await response.stream.bytesToString()}');
    } else {
      print('Failed to make $imageName PUT request: ${response.statusCode}');
      print('Response: ${await response.stream.bytesToString()}');
    }
  }
  static Future<void> deleteImage(String url, String pid) async {
    print(url);
    print(pid);
    print(TokenId.id);

    final uri = Uri.parse('https://api.pehchankidukan.com/seller/${TokenId.id}/products/$pid?url=$url');
    final response = await http.delete(uri,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${TokenId.token}'
      },
    );
    if (response.statusCode == 200) {
      print('delete request successful');
      print('Response: ');
    } else {
      print('Failed to make delete request: ${response.statusCode}');
      print('Response: $response');
    }
  }

  static Future<List<Product2>> fetchGlobalProduct(String query) async {
    if(query=="")return [];
    final Url =
        'https://api.pehchankidukan.com/seller/${TokenId.id}/globalProducts/search';
    final url = Uri.parse('$Url?keyword=$query');
    print(url);
    print(query);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${TokenId.token}',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      // print(responseBody['status']);
      // print(responseBody['length']);
      // print(responseBody['message']);
      List<Product2> products = (responseBody['data'] as List<dynamic>?)
          ?.map((e) => Product2.fromJson(e as Map<String, dynamic>))
          .toList() ?? [];
      // print(products[0].productName);
      // print(products[1].productName);
      print(products);
      return products;
    } else {
      return [];
      throw Exception('Failed to search products: ${response.reasonPhrase}');
    }
  }


 static Future<void> changeOrderStatus(String newStatus, String orderId) async {
    const Url = 'https://api.pehchankidukan.com/seller/changeOrderStatus';
    final url = Uri.parse(Url);
    print(url);
    final productJson = {
      "orderId": orderId,
      "newOrderStatus": newStatus
    };
    final response = await http.patch(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${TokenId.token}',
      },
      body: jsonEncode(productJson),
    );

    if (response.statusCode == 201) {
      print("successfully changed status");
    } else {
      throw Exception('Failed to change status: ${response.reasonPhrase}');
    }
  }

  static Future<List<Return>> getAllReturn() async {
    final Url = 'https://api.pehchankidukan.com/seller/658931121dcf59fa471b9ce8/getAllReturn';
    final url = Uri.parse(Url);
    print(url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${TokenId.token}',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      List<Return> products = (responseBody['returns'] as List<dynamic>?)
          ?.map((e) => Return.fromJson(e as Map<String, dynamic>))
          .toList() ?? [];
      print(products);
      return products;
    } else {
      return [];
      throw Exception('Failed to get return products: ${response.reasonPhrase}');
    }
  }


  static Future<List<Replacement>> getAllReplacement() async {
    final Url = 'https://api.pehchankidukan.com/seller/658931121dcf59fa471b9ce8/getAllReplacement';
    final url = Uri.parse(Url);
    print(url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${TokenId.token}',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      List<Replacement> products = (responseBody['replacements'] as List<dynamic>?)
          ?.map((e) => Replacement.fromJson(e as Map<String, dynamic>))
          .toList() ?? [];
      print(products);
      return products;
    } else {
      return [];
      throw Exception('Failed to get return products: ${response.reasonPhrase}');
    }
  }

  static Future<List<Replacement>> getAllReplacementReturn() async {
    final Url = 'https://api.pehchankidukan.com/seller/658931121dcf59fa471b9ce8/getAllReturnReplacement';
    final url = Uri.parse(Url);
    print(url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${TokenId.token}',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      List<Replacement> products = (responseBody['replacements'] as List<dynamic>?)
          ?.map((e) => Replacement.fromJson(e as Map<String, dynamic>))
          .toList() ?? [];
      print(products);
      return products;
    } else {
      return [];
      throw Exception('Failed to get return products: ${response.reasonPhrase}');
    }
  }


  static Future<void> ReplacementFromSeller(Replacement rep) async {
    final Url = 'https://api.pehchankidukan.com/seller/${rep.productInstance?.productID}/ReplacementFromSeller/658931121dcf59fa471b9ce8';
    final url = Uri.parse(Url);
    print(url);
    final Map<String,dynamic> body = {
      "reasons": rep.reasons,
      "shippedBy": {
        "name": rep.shippedBy?.name,
        "phoneNumber": rep.shippedBy?.phoneNumber,
      },
      "isComplete": false,
      "requestStatus": "outgoing",
      "status":  "approved",
      "productInstance":rep.productInstance?.toJson(),
      "orderID":rep.orderID,
      "customerID":rep.customerID
    };
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${TokenId.token}',
      },
      body: jsonEncode(body)
    );
    final res = jsonDecode(response.body);
    print(res);
    if (response.statusCode == 200) {
      print("ReplacementFromSeller is successfull");
    } else {
      throw Exception('Failed to SellerReplacement: ${response.reasonPhrase}');
    }
  }

  static Future<List<ProductInfo>> GetAllReviewAndRating() async {
    final Url = 'https://api.pehchankidukan.com/seller/${TokenId.id}/getAllProductsRatings';
    final url = Uri.parse(Url);
    print(url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${TokenId.token}',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      List<ProductInfo> products = (responseBody['allProducts'] as List<dynamic>?)
          ?.map((e) => ProductInfo.fromJson(e as Map<String, dynamic>))
          .toList() ?? [];
      print(products);
      return products;
    } else {
      return [];
      throw Exception('Failed to get return products: ${response.reasonPhrase}');
    }
  }


  static Future<List<RatingReview>> GetCustomerReviewAndRating(String Pid) async {
    final Url = 'https://api.pehchankidukan.com/seller/${Pid}/productRatingReviews';
    final url = Uri.parse(Url);
    print(Pid);
    print(url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${TokenId.token}',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      List<RatingReview> products = (responseBody['allRatingReviews'] as List<dynamic>?)
          ?.map((e) => RatingReview.fromJson(e as Map<String, dynamic>))
          .toList() ?? [];
      print(products);
      return products;
    } else {
      return [];
      throw Exception('Failed to get return products: ${response.reasonPhrase}');
    }
  }

  static Future<OrderSummaryDaily> GetDailySales() async {
    final Url = 'https://api.pehchankidukan.com/seller/${TokenId.id}/dailySales';
    final url = Uri.parse(Url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${TokenId.token}',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      OrderSummaryDaily products =  OrderSummaryDaily.fromJson(responseBody);
      print(products);
      return products;
    } else {
      throw Exception('Failed to get return products: ${response.reasonPhrase}');
    }
  }

  static Future<OrderSummaryWeekly> GetWeeklySales() async {
    final Url = 'https://api.pehchankidukan.com/seller/${TokenId.id}/weeklySales';
    final url = Uri.parse(Url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${TokenId.token}',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      OrderSummaryWeekly products =  OrderSummaryWeekly.fromJson(responseBody);
      print(products);
      return products;
    } else {
      throw Exception('Failed to get return products: ${response.reasonPhrase}');
    }
  }

  static Future<OrderSummaryMonthly> GetMonthlySales() async {
    final Url = 'https://api.pehchankidukan.com/seller/${TokenId.id}/monthlySales';
    final url = Uri.parse(Url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${TokenId.token}',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      OrderSummaryMonthly products =  OrderSummaryMonthly.fromJson(responseBody);
      print(products);
      return products;
    } else {
      throw Exception('Failed to get return products: ${response.reasonPhrase}');
    }
  }
  static Future<TotalOrder> GetCustomSales(String start, String end) async {
    final Url = 'https://api.pehchankidukan.com/seller/${TokenId.id}/customeDurationSales?start=$start&end=$end';
    print(Url);
    final url = Uri.parse(Url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${TokenId.token}',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      TotalOrder products =  TotalOrder.fromJson(responseBody);
      print(products);
      return products;
    } else {
      throw Exception('Failed to get return products: ${response.reasonPhrase}');
    }
  }






}