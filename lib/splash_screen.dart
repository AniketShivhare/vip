// import 'package:e_commerce/app/screens/user_login_screen/userLoginScreen.dart';
import 'package:e_commerce/seller_login.dart';
import 'package:e_commerce/services/tokenId.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main_dashboard.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {

  static const String KEYLOGIN = "login";
  static const String KEYTOKEN = "keytoken";
  static const String KEYID = "keyid";

  bool isRememberMe = false;
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    whereToGo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration:
                    // BoxDecoration(
                    //   color: Colors.white
                    // ),

                    BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                      Color(0xff7091F5),
                      Colors.white,
                      // Color(0x99FFA500),
                      // Color(0xccFFA500),
                      // Color(0xffFFA500),
                    ])),
                child: Center(
                  child: Container(
                    child: Image.asset(
                      "assets/images/logo.png",
                      height: 60,
                      width: 180,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void whereToGo() async {
    // String keyTo="";
    // String keyI="";
    // TokenId.id = "656b0aca0baf2e623bad1d0f";
    // TokenId.token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY1NmIwYWNhMGJhZjJlNjIzYmFkMWQwZiIsImlhdCI6MTcwMzUwODM2NCwiZXhwIjoxNzA2MTAwMzY0fQ.EIBVX5wl9qtIl6XaFohx1BfttDPPXTUXVI_Jg6EKTUY";
    // Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) =>  MainDashboard(token: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY1NmIwYWNhMGJhZjJlNjIzYmFkMWQwZiIsImlhdCI6MTcwMzUwODM2NCwiZXhwIjoxNzA2MTAwMzY0fQ.EIBVX5wl9qtIl6XaFohx1BfttDPPXTUXVI_Jg6EKTUY', id: '656b0aca0baf2e623bad1d0f', pageIndex: 2,sortt:""),
    //     ));

    var sharedPref = await SharedPreferences.getInstance();

    var isLoggedIn = sharedPref.getBool(KEYLOGIN);

    String keyToken;
    keyToken = sharedPref.getString(KEYTOKEN) ?? "tt";

    String keyId;
    keyId = sharedPref.getString(KEYID) ?? "tt";
    TokenId.token=keyToken;
    //
    TokenId.id=keyId;

    Future.delayed(const Duration(seconds: 2), () {
      print(KEYTOKEN);
      print(KEYID);
      if(isLoggedIn!=null) {
        if(isLoggedIn==true) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>  MainDashboard(token: keyToken, id: keyId, pageIndex: 2,sortt:""),
              ));
        } else{
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ));
        }
      } else{
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ));
      }
    });
  }
}
