import 'dart:async';
import 'dart:convert';

import 'package:e_commerce/services/tokenId.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'Regestration.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String newtoken = "";
  bool isRememberMe = false;
  bool isOtpTrue = false;
  late int _secondsRemaining;
  late Timer _timer;
  bool isLogIn = false;
  bool isOtp = false;

  var phone_controller = TextEditingController();
  var otp_controller = TextEditingController();
  Future<void> postSeller() async {
    isLogIn = true;
    Map<String, dynamic> jsonData = {"phone": "9111766052", "otp": "1234"};

    var apiurl = "https://api.pehchankidukan.com/seller/verify-otp";
    var uri = Uri.parse(apiurl);
    var token = '';
    var id = '';
    try {
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(jsonData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        token = responseData['token'];
        id = responseData['id'];
        print(responseData['message']);
        TokenId.token = token;
        TokenId.id = id;
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
    print("token is printing");
    print("token is ${token}");
    print(id);
    TokenId.token = token;
    TokenId.id = id;
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Regest(token: token, id: id)));
  }

  Future<void> registerUser() async {
    // Map<String, dynamic> jsonData = {
    //   "phone": phone_controller.text,
    // };

    // var apiurl = "https://api.pehchankidukan.com/buyer/register";
    // try {
    //   final response = await http.post(
    //     Uri.parse(apiurl),
    //     headers: {
    //       'Content-Type': 'application/json',
    //     },
    //     body: jsonEncode(jsonData),
    //   );
    // } catch (e) {
    //   print("User not register");
    // }
    _secondsRemaining = 60;
    startTimer();
    setState(() {
      isOtpTrue = true;
    });
  }

  void getDeviceToken() {
    _firebaseMessaging.getToken().then((token) {
      print("Device Token: $token");
      newtoken = token!;
    });
  }

  Widget customTextField({String? title, String? hint, controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title!,
          style: TextStyle(
            fontFamily: GoogleFonts.comfortaa().fontFamily,
            color: Colors.blue.shade900,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontFamily: GoogleFonts.comfortaa().fontFamily,
              color: Color.fromRGBO(209, 209, 209, 1),
            ),
            isDense: true,
            fillColor: Color.fromRGBO(239, 239, 239, 1),
            filled: true,
            border: InputBorder.none,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue.shade900),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        _timer.cancel();
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getDeviceToken();
  }

  @override
  Widget build(BuildContext context) {
    var _mediaQuery = MediaQuery.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            height: _mediaQuery.size.height * 0.4,
            color: Colors.blue.shade900,
          ),
          Container(
            height: _mediaQuery.size.height * 0.4,
            color: Colors.blue.shade900,
            child: Image.asset(
              'assets/images/bgpng.png',
              width: 300,
            ),
          ),
          Center(
            child: Column(
              children: [
                SizedBox(height: _mediaQuery.size.height * 0.12),
                Container(
                  padding: const EdgeInsets.all(8),
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: Image.asset(
                    "assets/images/logo.png",
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  "Log in to PechanKiDukan",
                  style: TextStyle(
                    fontFamily: GoogleFonts.comfortaa().fontFamily,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  width: _mediaQuery.size.width - 70,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 5.0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      customTextField(
                          hint: 'Phone Number',
                          title: 'Phone Number',
                          controller: phone_controller),
                      isOtpTrue
                          ? customTextField(
                              hint: 'Enter OTP',
                              title: 'Enter OTP',
                              controller: otp_controller)
                          : Container(),
                      isOtpTrue
                          ? Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  if (_secondsRemaining == 0) {
                                    _secondsRemaining = 60;
                                    startTimer();
                                  } else {
                                    print(_secondsRemaining);
                                  }
                                },
                                child: _secondsRemaining == 0
                                    ? Text(
                                        'Resend OTP',
                                        style: TextStyle(
                                            color: Colors.blue.shade900),
                                      )
                                    : Text(
                                        '$_secondsRemaining - Resend OTP',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                              ),
                            )
                          : Container(),
                      SizedBox(height: 10),
                      SizedBox(
                        width: _mediaQuery.size.width - 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue.shade900,
                            padding: const EdgeInsets.all(12),
                          ),
                          onPressed: isOtpTrue ? postSeller : registerUser,
                          child: isLogIn
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : isOtpTrue
                                  ? Text(
                                      'Login',
                                      style: TextStyle(
                                        fontFamily:
                                            GoogleFonts.comfortaa().fontFamily,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      'Send OTP',
                                      style: TextStyle(
                                        fontFamily:
                                            GoogleFonts.comfortaa().fontFamily,
                                        color: Colors.white,
                                      ),
                                    ),
                        ),
                        // child
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
