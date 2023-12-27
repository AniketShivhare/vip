import 'dart:io';
import 'package:e_commerce/services/User_api.dart';
import 'package:e_commerce/services/sellerApi.dart';
import 'package:e_commerce/services/sellerTokenId.dart';
import 'package:e_commerce/services/tokenId.dart';
import 'package:e_commerce/uploadmages.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'apis/sellerProfile.dart';

class SellerProfilePersonalDetails extends StatefulWidget {
  const SellerProfilePersonalDetails({super.key});
  // final String title;

  @override
  State<SellerProfilePersonalDetails> createState() =>
      _SellerProfilePersonalDetailsState();
}

class _SellerProfilePersonalDetailsState
    extends State<SellerProfilePersonalDetails> {
  late SellerProfile seller;
  String sellerId = Candidate().id;
  String sellerToken = Candidate().token;

  @override
  initState() {
    fetchSeller();
  }

  var nameController = TextEditingController();
  var phoneController = TextEditingController();

  Future<void> fetchSeller() async {
    seller = await SellerApi().getSellerProfile(sellerToken, sellerId);

    setState(() {
      if(seller.data.profilePhoto.isNotEmpty) {
        imageUrl = seller.data.profilePhoto;
      }
    });
    // print("asfdfds");
    // print(imageUrl);
    if (seller.data.profilePhoto.isNotEmpty) {
      imageUrl = seller.data.profilePhoto;
    }
    print("asfdfds");
    print(imageUrl);
    // print(seller.data.profilePhoto);
    nameController.text = seller.data.ownerName;
    phoneController.text = seller.data.phone;

    // print(imageUrl);
    // print(imageUrl);
    print("phone");

  }

  Future<void> postPersonalDetails() async {
    Map<String, dynamic> json = {
      "ownerName": nameController.text,
      // "phone": phoneController.text,
    };
    final response =
        await SellerApi().updateProfile(json, TokenId.id, TokenId.token);
    if (imageFile1 != null) {
      await UserApi.uploadImage(imageFile1!, "profilePhoto");
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Profile Updated")));
    Navigator.pop(context);
  }

  String? imageUrl =
      'https://media.istockphoto.com/id/1644722689/photo/autumn-decoration-with-leafs-on-rustic-background.jpg?s=2048x2048&w=is&k=20&c=dZFmEik-AnmQJum5Ve8GbQj-cjkPsFTJP26lPY5RTJg=';
  String heroTag = "sellerProfile";
  File? imageFile;
  XFile? imageFile1;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        imageFile1 = (pickedFile);
        imageUrl = null;
        isImageEdited = true;
      });
    }
  }

  bool isImageEdited = false;
  bool isUserNameEdited = false;
  bool isMobileNoEdited = false;

  Future<bool> _onWillPop() async {
    if (isImageEdited || isUserNameEdited || isMobileNoEdited) {
      return await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Unsaved Changes'),
                content:
                    Text('You have unsaved changes. Do you want to save them?'),
                actions: <Widget>[
                  TextButton(
                    child: Text('Discard'),
                    onPressed: () {
                      Navigator.of(context)
                          .pop(true); // Discard changes and go back
                    },
                  ),
                  TextButton(
                    child: Text('Save'),
                    onPressed: () {
                      postPersonalDetails;
                      Navigator.of(context).pop(true);
                    },
                  ),
                ],
              );
            },
          ) ??
          false;
    }
    return true; // If no changes are made, allow navigation without a dialog
  }

  List<String> additionalMobileNumbers = ["1234567890", "9876543210"];
  bool showMoreNumbers = false;

  List<Widget> buildAdditionalMobileNumberWidgets() {
    List<Widget> widgets = [];

    for (int i = 0; i < additionalMobileNumbers.length; i++) {
      widgets.add(Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 5),
                  color: Colors.deepOrange.withOpacity(.2),
                  spreadRadius: 2,
                  blurRadius: 10,
                ),
              ],
            ),
            child: TextFormField(
              initialValue: additionalMobileNumbers[i],
              // readOnly: true,
              decoration: InputDecoration(
                labelText: 'Other Mobile Number',
                hintText: 'Enter your  other mobile number',
                prefixIcon: const Icon(Icons.phone),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              keyboardType: TextInputType.phone,
              onChanged: (value) {
                setState(() {
                  isMobileNoEdited = true;
                });
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ));
    }
    return widgets;
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text("Edit profile page"),
          ),
          body: SingleChildScrollView(
            child: Container(
              color: Colors.white12,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => HeroImageDetail(
                                    imageFile: imageFile,
                                    imageUrl: imageUrl,
                                    heroTag: heroTag),
                              ),
                            );
                          },
                          child: Hero(
                            tag: heroTag,
                            child: Stack(
                              children: [
                                Container(
                                  width: 80, // Adjust the width as needed
                                  height: 80, // Adjust the height as needed
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        5), // Adjust the border radius as needed
                                    child: Image(
                                      image: imageFile != null
                                          ? FileImage(imageFile!)
                                          : imageUrl != null
                                              ? NetworkImage(imageUrl!)
                                              : AssetImage(
                                                      'assets/placeholder.png')
                                                  as ImageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 55,
                                  left: 55,
                                  child: Stack(children: [
                                    Container(
                                      height: 25,
                                      width: 25,
                                      color: Colors.white,
                                    ),
                                    Positioned(
                                        top: -10,
                                        left: -11,
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.camera_alt_outlined,
                                            color: Colors.black,
                                          ),
                                          onPressed: () {
                                            // Handle the edit image action here
                                            _pickImage();
                                          },
                                        )),
                                  ]),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Text('Profile Image')
                      ],
                    ),
                    const SizedBox(height: 40),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 5),
                                color: Colors.deepOrange.withOpacity(.2),
                                spreadRadius: 2,
                                blurRadius: 10)
                          ]),
                      child: TextFormField(
                        controller: nameController,
                        onChanged: (value) {
                          setState(() {
                            isUserNameEdited = true;
                          });
                        },
                        validator: (value) {
                          if (value!.length < 5) {
                            return "username length must be 5";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'username',
                          hintText: '  enter username',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 5),
                                color: Colors.deepOrange.withOpacity(.2),
                                spreadRadius: 2,
                                blurRadius: 10)
                          ]),
                      child: TextFormField(
                          controller: phoneController,
                          decoration: InputDecoration(
                            labelText: 'Mobile Number',
                            hintText: 'Enter your mobile number',
                            prefixIcon: const Icon(Icons.phone),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                          ),
                          keyboardType: TextInputType.phone,
                          onChanged: (value) {
                            setState(() {
                              isMobileNoEdited = true;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Please enter a mobile number';
                            } else if (value.length != 10) {
                              return "number must be 10 digit long";
                            }
                            return null;
                          }),
                    ),
                    if (additionalMobileNumbers.length > 0)
                      Column(
                        children: [
                          const SizedBox(height: 20),
                          showMoreNumbers
                              ? Column(
                                  children:
                                      buildAdditionalMobileNumberWidgets(),
                                )
                              : ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      showMoreNumbers = true;
                                    });
                                  },
                                  child: const Text('View all Mobile Numbers'),
                                ),
                        ],
                      ),
                    const SizedBox(height: 40),
                    if (isImageEdited || isUserNameEdited || isMobileNoEdited)
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: postPersonalDetails,
                          style: ElevatedButton.styleFrom(
                            // primary: isImageEdited ? Colors.greenAccent : null,
                            backgroundColor: Colors.blue.shade900,
                          ),
                          child: const Text(
                            'Save Profile',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}

class HeroImageDetail extends StatelessWidget {
  final File? imageFile;
  final String? imageUrl;
  final String heroTag;

  HeroImageDetail(
      {required this.imageFile, required this.imageUrl, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              Icons.close,
              size: 30,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],

        automaticallyImplyLeading: false, // Remove the back arrow
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Hero(
                tag: heroTag,
                child: PhotoView(
                  imageProvider: imageFile != null
                      ? FileImage(imageFile!) as ImageProvider
                      : NetworkImage(imageUrl!) as ImageProvider,
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 2,
                  backgroundDecoration: BoxDecoration(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
