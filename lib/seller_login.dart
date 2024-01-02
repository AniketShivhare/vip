import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:e_commerce/main_dashboard.dart';
import 'package:e_commerce/services/tokenId.dart';
import 'package:e_commerce/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Regestration.dart';
import 'package:telephony/telephony.dart';
import 'package:permission_handler/permission_handler.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Telephony telephony = Telephony.instance;
  // OtpFieldController otpbox = OtpFieldController();

// Request permissions (Android only)

  String newtoken = "";
  bool isRememberMe = false;
  bool isOtpTrue = false;
  late int _secondsRemaining;
  late Timer _timer;
  bool isLogIn = false;
  bool isOtp = false;

  TextEditingController phone_controller = TextEditingController();
  var otp_controller = TextEditingController();
  Future<void> postSeller() async {
    isLogIn = true;
    Map<String, dynamic> jsonData = {
      "phone": phone_controller.text,
      "otp": otp_controller.text
    };
    print(jsonData);

    var apiurl = "https://api.pehchankidukan.com/seller/verifyOtp";
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
      print("response.statusCode");
      print(response.statusCode);
      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        print("responseData");
        print(responseData);

        token = responseData['token'];
        id = responseData['id'];
        print(responseData['message']);
        TokenId.token = token;
        TokenId.id = id;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Regest(token: token, id: id)),
          (route) => false,
        );
      }
      else if(response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        print("responseData");
        print(responseData);

        token = responseData['token'];
        id = responseData['id'];
        print(responseData['message']);
        TokenId.token = token;
        TokenId.id = id;
        var sharedPref = await SharedPreferences.getInstance();
        await sharedPref.setBool(SplashScreenState.KEYLOGIN, true);
        await sharedPref.setString(SplashScreenState.KEYTOKEN, token);
        await sharedPref.setString(SplashScreenState.KEYID, id);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => MainDashboard(
                    token: '',
                    id: '',
                    pageIndex: 2,
                    sortt: '',
                  )),
          (route) => false,
        );
      } else {
        print('Error: ${response.statusCode}');
        final snackBar = SnackBar(
          content: const Text('Enter Correct Details'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      print('Error: $e');
    }
    print("token is printing");
    print("token is ${token}");
    print(id);
    TokenId.token = token;
    TokenId.id = id;
  }

  Future<void> registerUser() async {
    try {
      var status = await Permission.sms.status;
      // bool? permissionsGranted = await telephony.requestPhoneAndSmsPermissions;

      if (status.isDenied || status.isPermanentlyDenied) {
        // Request SMS permissions
        // var result = await Permission.sms.request();
        bool? permissionsGranted =
            await telephony.requestPhoneAndSmsPermissions;

        // Check the result after the request
        // if (result.isDenied || result.isPermanentlyDenied)
        if (!permissionsGranted!) {
          // Handle denied or permanently denied status
          print("SMS permission denied. Certain features won't be available.");
          // Show a message to the user or take alternative actions.
          // return; // Don't proceed further if permission is denied.
        }
      }

      // Proceed with user registration or other actions
      // ...
    } catch (e) {
      // Handle exceptions here
      print("Exception during permission handling: $e");
    }

    Map<String, dynamic> jsonData = {
      "phone": phone_controller.text,
    };
    print(jsonData);

    var apiurl = "https://api.pehchankidukan.com/seller/login";
    try {
      final response = await http.post(
        Uri.parse(apiurl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(jsonData),
      );
      final body = jsonDecode(response.body);
      print(body['message']);
    } catch (e) {
      print("User not register");
    }
    _secondsRemaining = 60;
    startTimer();
    setState(() {
      // FocusScope.of(context).requestFocus(OtpField);
      OtpField.requestFocus();
      isOtpTrue = true;
    });
  }

  Future<void> ResendOtp() async {
    Map<String, dynamic> jsonData = {
      "phone": phone_controller.text,
    };
    print(jsonData);

    var apiurl = "https://api.pehchankidukan.com/seller/resendOtp";
    try {
      final response = await http.post(
        Uri.parse(apiurl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(jsonData),
      );
      final body = jsonDecode(response.body);
      print(body['message']);
    } catch (e) {
      print("User not register");
    }
    _secondsRemaining = 60;
    startTimer();
    setState(() {
      isOtpTrue = true;
    });
  }

  // void getDeviceToken() {
  //   _firebaseMessaging.getToken().then((token) {
  //     print("Device Token: $token");
  //     newtoken = token!;
  //   });
  // }

  Widget customPhoneTextField({String? title, String? hint, controller1}) {
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
          // autofocus: true,
          focusNode: phoneField,
          controller: controller1,
          keyboardType: TextInputType.number,
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

  Widget customOtpTextField({String? title, String? hint, controller1}) {
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
          autofocus: true,
          focusNode: OtpField,
          controller: controller1,
          keyboardType: TextInputType.number,
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    phoneField.dispose();
    OtpField.dispose();
    _timer.cancel();
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
    // getDeviceToken();
    telephony.listenIncomingSms(
      onNewMessage: (SmsMessage message) {
        print(message.address); // +977981******67, sender nubmer
        print(message.body); // Your OTP code is 34567
        print(message.date); // 1659690242000, timestamp

        // get the message
        String sms = message.body.toString();

        if (message.body!.contains('Persistent Digital Commerce')) {
          // verify SMS is sent for OTP with sender number
          String otpcode = sms.replaceAll(new RegExp(r'[^0-9]'), '');
          // prase code from the OTP sms
          // otpbox.set(otpcode.split(""));
          // split otp code to list of number
          // and populate to otb boxes
          setState(() {
            // refresh UI
            otp_controller.text = otpcode;
          });
          if (otp_controller.text.length == 6) {
            postSeller();
          }
        } else {
          print("Normal message.");
        }
      },
      listenInBackground: false,
    );
  }

  FocusNode phoneField = FocusNode();
  FocusNode OtpField = FocusNode();

  @override
  Widget build(BuildContext context) {
    var _mediaQuery = MediaQuery.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Stack(
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
                        customPhoneTextField(
                            hint: 'Phone Number',
                            title: 'Phone Number',
                            controller1: phone_controller),
                        isOtpTrue
                            ? customOtpTextField(
                                hint: 'Enter OTP',
                                title: 'Enter OTP',
                                controller1: otp_controller)
                            : Container(),
                        isOtpTrue
                            ? Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    if (_secondsRemaining == 0) {
                                      ResendOtp();
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
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              'Try again in $_secondsRemaining seconds',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            Text(
                                              'Resend OTP',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
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
                                        'Login / SignUp',
                                        style: TextStyle(
                                          fontFamily: GoogleFonts.comfortaa()
                                              .fontFamily,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(
                                        'Send OTP',
                                        style: TextStyle(
                                          fontFamily: GoogleFonts.comfortaa()
                                              .fontFamily,
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
      ),
    );
  }
}
