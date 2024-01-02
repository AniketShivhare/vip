// This helps to access the token and id from anywhere of the code

import 'package:e_commerce/services/tokenId.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Candidate {
   String token = TokenId.token,id=TokenId.id;

// Future<void> storeTokenId(token1, id1) async {
//   token = token1;
//   id = id1;
// }

static Future<bool> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }
}