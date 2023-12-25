import 'package:http_parser/http_parser.dart';
import 'package:e_commerce/services/tokenId.dart';
import 'package:e_commerce/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'main_dashboard.dart';
import 'package:path/path.dart';




class UploadImages extends StatefulWidget {
  final token;
  final id;

  UploadImages({Key? key, required this.token, required this.id})
      : super(key: key); // Constructor

  @override
  _UploadImagesState createState() => _UploadImagesState();
}

bool isFinish = false;

class _UploadImagesState extends State<UploadImages> {
  XFile? ownerPhoto;
  XFile? gstImage;
  XFile? fssaiImage;
  XFile? cancelledCheckImage;
  XFile? shopImage;
  XFile? shopLogo;
  XFile? PANIMage;

   Future<void> uploadImage(XFile imageFile, String imageName) async {
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
            'image[]', 'jpeg'), // Adjust content type accordingly
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

  Future<void> _getImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery);

    if (pickedFile != null) {
      await uploadImage(pickedFile,"profilePhoto");
      setState(() {
        ownerPhoto = pickedFile;
      });
    } else {
      // User canceled image selection
    }
  }

  Future<void> _getShopImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery);

    if (pickedFile != null) {
      await uploadImage(pickedFile,"shopPhoto");
      setState(() {
        shopImage = pickedFile;
      });
    } else {
      // User canceled image selection
    }
  }

  Future<void> _getShopLogo() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery);

    if (pickedFile != null) {
      // await uploadImage(pickedFile,"gstinImage");
      setState(() {
        shopLogo = pickedFile;
      });
    } else {
      // User canceled image selection
    }
  }

  Future<void> _getGSTImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery);

    if (pickedFile != null) {
      await uploadImage(pickedFile,"gstinImage");
      setState(() {
        gstImage = pickedFile;
      });
    } else {
      // User canceled image selection
    }
  }

  Future<void> _getFSSAIImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery);

    if (pickedFile != null) {
      await uploadImage(pickedFile,"fssaiImageUrl");
      setState(() {
        fssaiImage = pickedFile;
      });
    } else {
      // User canceled image selection
    }
  }


  Future<void> _getCancelledCheque() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery);

    if (pickedFile != null) {
      await uploadImage(pickedFile,"cancelledCheckImage");
      setState(() {
        cancelledCheckImage = pickedFile;
      });
    } else {
      // User canceled image selection
    }
  }

  Future<void> _getPANImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      await uploadImage(pickedFile, "PANImage");
      setState(() {
        PANIMage = pickedFile;
      });
    } else {
      // User canceled image selection
    }
  }

  // Similarly, create functions for other image types and update their respective variables.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: const Text('Upload Details'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Your progress indicators here

              const SizedBox(height: 30),
              // const Text('Upload Images', style: TextStyle(fontSize: 18)),
              // const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _getImage,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    if (ownerPhoto != null)
                      Icon(Icons.check, color: Colors.green),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Upload Owner Photo'),
                  ],
                ),
              ),
              (ownerPhoto == null && isFinish)
                  ? Text(
                      'Please Upload Owner Photo.',
                      style: TextStyle(
                          color: Color.fromRGBO(183, 21, 9, 1), fontSize: 12),
                    )
                  : Text(''),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _getShopImage,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    if (shopImage != null)
                      Icon(Icons.check, color: Colors.green),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Upload Shop Image'),
                  ],
                ),
              ),
              (shopImage == null && isFinish)
                  ? Text(
                      'Please Upload Shop Image.',
                      style: TextStyle(
                          color: Color.fromRGBO(183, 21, 9, 1), fontSize: 12),
                    )
                  : Text(''),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _getShopLogo,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    if (shopLogo != null)
                      Icon(Icons.check, color: Colors.green),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Upload Shop Logo'),
                  ],
                ),
              ),
              (shopLogo == null && isFinish)
                  ? Text(
                      'Please Upload Shop Logo.',
                      style: TextStyle(
                          color: Color.fromRGBO(183, 21, 9, 1), fontSize: 12),
                    )
                  : Text(''),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _getGSTImage,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    if (gstImage != null)
                      Icon(Icons.check, color: Colors.green),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Upload GST Image'),
                  ],
                ),
              ),
              (gstImage == null && isFinish)
                  ? Text(
                      'Please Upload GST Image.',
                      style: TextStyle(
                          color: Color.fromRGBO(183, 21, 9, 1), fontSize: 12),
                    )
                  : Text(''),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _getFSSAIImage,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    if (fssaiImage != null)
                      Icon(Icons.check, color: Colors.green),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Upload FSSAI Image'),
                  ],
                ),
              ),
              (fssaiImage == null && isFinish)
                  ? Text(
                      'Please Upload FSSAI Image.',
                      style: TextStyle(
                          color: Color.fromRGBO(183, 21, 9, 1), fontSize: 12),
                    )
                  : Text(''),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _getCancelledCheque,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    if (cancelledCheckImage != null)
                      Icon(Icons.check, color: Colors.green),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Upload Cancelled Cheque Image'),
                  ],
                ),
              ),
              (cancelledCheckImage == null && isFinish)
                  ? Text(
                      'Please Upload Cancelled Cheque Image.',
                      style: TextStyle(
                          color: Color.fromRGBO(183, 21, 9, 1), fontSize: 12),
                    )
                  : Text(''),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _getPANImage,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    if (PANIMage != null)
                      Icon(Icons.check, color: Colors.green),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Upload PAN card Image'),
                  ],
                ),
              ),
              (PANIMage == null && isFinish)
                  ? Text(
                      'Please Upload PAN card Image.',
                      style: TextStyle(
                          color: Color.fromRGBO(183, 21, 9, 1), fontSize: 12),
                    )
                  : Text(''),
              const SizedBox(height: 50),
              Center(
                child: Container(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (true)
                      // (ownerPhoto != null &&
                      //     gstImage != null &&
                      //     fssaiImage != null &&
                      //     cancelledCheckImage != null &&
                      //     shopImage != null &&
                      //     shopLogo != null &&
                      //     PANIMage != null)
                      {
                        saveData();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MainDashboard(
                                token: widget.token,
                                id: widget.id,
                                pageIndex: 2,
                                sortt: "created_at"),
                          ),
                          (route) =>
                              false, // This line clears the navigator stack
                        );
                      } else {
                        setState(() {
                          isFinish = true;
                        });
                      }
                      // Process the form data and perform submission
                      // Process the form data and perform submission
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            5), // Set this to 0 for a square button
                      ),
                      backgroundColor:
                          Colors.blue, // Change this to the color you want
                    ),
                    child: const Text(
                      'Finish',
                      style: TextStyle(color: Colors.white),
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

  Future<void> saveData() async {
     print("(widget.token");
     print(widget.token);
    var sharedPref = await SharedPreferences.getInstance();
    await sharedPref.setBool(SplashScreenState.KEYLOGIN, true);
    await sharedPref.setString(SplashScreenState.KEYTOKEN, widget.token);
    await sharedPref.setString(SplashScreenState.KEYID, widget.id);
  }
}
