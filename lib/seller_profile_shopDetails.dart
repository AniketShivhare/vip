import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:e_commerce/apis/sellerProfile.dart';
import 'package:e_commerce/Regestration.dart';
import 'package:e_commerce/services/User_api.dart';
import 'package:e_commerce/services/sellerApi.dart';
import 'package:e_commerce/services/sellerTokenId.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'apis/Seller.dart';
import 'dialog_of_registration.dart';

class SellerProfileShopDetails extends StatefulWidget {
  const SellerProfileShopDetails({super.key});
  // final String title;

  @override
  State<SellerProfileShopDetails> createState() =>
      _SellerProfileShopDetailsState();
}

class _SellerProfileShopDetailsState extends State<SellerProfileShopDetails> {
  var shopNameController = TextEditingController();
  var GSTController = TextEditingController();
  var FSSAIController = TextEditingController();
  var LandlineController = TextEditingController();
  var shopOpenController = TextEditingController();
  var shopCloseController = TextEditingController();
  var shopAddressController = TextEditingController();
  String GstImage = "";

  String sellerId = Candidate().id;
  String sellerToken = Candidate().token;
  late SellerProfile seller;

  @override
  initState() {
    fetchSeller();
  }
 String url ='';
  Future<void> fetchSeller() async {
    seller = await SellerApi().getSellerProfile(sellerToken, sellerId);
url = seller.data.fssaiImageUrl;
print("urlaesaserasfasdfadfasfasfasdfasdfasf");
print(url);
    shopNameController.text = seller.data.shopName;
    GSTController.text = seller.data.gstin.gstinNo;
    // GstImage = seller.data.gstin.gstinImage;
    shopAddressController.text = seller.data.address.addressLine;
    LandlineController.text = seller.data.phone;
    // FSSAIController.text = seller.data.;
    // LandlineController.text = seller.data.;
    // shopOpenController.text = seller.data.shopTimings.;
    print(shopOpenController.text);
    setState(() {

    });
    // shopCloseController.text = seller.data.shopTimings as String;
  }

  Future<void> postShopDetails() async {
    Map<String, dynamic> json = {
      "shopName": shopNameController.text,
      "gstNumber": GSTController.text,
      // "licenseNumber": FSSAIController,
      "phone": LandlineController.text,
      // "shopOpeningTime": shopOpenController,
      // "shopClosingTime": shopCloseController,
        "addressLine": shopAddressController.text,
    };
    print("shopAddressController.text");
    print(shopAddressController.text);
    final response =
    await SellerApi().updateBankDetails(json, sellerId, sellerToken);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Shop Details Updated")));
    Navigator.pop(context);
    print("response is priintingggg");
    print(response.data.address.addressLine);
  }

  bool addMoreShopImages =false;


  void showCameraImageExpansion(int index) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Expanded Image'),
            ),
            body: Center(
              child: Hero(
                  tag: 'image_$index',
                  child: Image.file(
                    File(imageFileList![index].path),
                    fit: BoxFit.cover,
                  )),
            ),
          );
        },
      ),
    );
  }

  Future<void> showCameraDeleteConfirmationDialog(int index) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Image?'),
          content: Text('Are you sure you want to delete this image?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                removeCameraImage(index); // Remove the image from the list
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void removeCameraImage(int index) {
    setState(() {
      imageFileList!.removeAt(index);
    });
  }


  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? imageFileList = [];
  void selectImages() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      isAddShopImagesEdited = true;
      imageFileList!.addAll(selectedImages);
    }
    print("Image List Length:" + imageFileList!.length.toString());
    setState(() {});
  }


  final List<String> imgList = [
    'https://media.istockphoto.com/id/1644722689/photo/autumn-decoration-with-leafs-on-rustic-background.jpg?s=2048x2048&w=is&k=20&c=dZFmEik-AnmQJum5Ve8GbQj-cjkPsFTJP26lPY5RTJg=',
    'https://media.istockphoto.com/id/1464561797/photo/artificial-intelligence-processor-unit-powerful-quantum-ai-component-on-pcb-motherboard-with.jpg?s=2048x2048&w=is&k=20&c=_h_lwe5-Xb4AK-w3nUfa0m3ZNPDZSqhQhkitrtdTpFQ=',
    'https://media.istockphoto.com/id/1486626509/photo/woman-use-ai-to-help-work-or-use-ai-everyday-life-at-home-ai-learning-and-artificial.jpg?s=2048x2048&w=is&k=20&c=I9i1MwJ29M2yQBC8BBLOfWyHJ3hlBpYoSmqSXAKFlZM='
  ];

  void removeImage(int index) {
    setState(() {
      imgList.removeAt(index);
    });
  }

  Future<void> showDeleteConfirmationDialog(int index) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Image?'),
          content: Text('Are you sure you want to delete this image?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                isDeleteShopImageEdited=true;
                removeImage(index); // Remove the image from the list
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void showImageExpansion(int index) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Expanded Image'),
            ),
            body: Center(
              child: Hero(
                tag: 'image_$index',
                child: Image.network(
                  imgList[index],
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String? GSTimageUrl =  'https://media.istockphoto.com/id/1464561797/photo/artificial-intelligence-processor-unit-powerful-quantum-ai-component-on-pcb-motherboard-with.jpg?s=2048x2048&w=is&k=20&c=_h_lwe5-Xb4AK-w3nUfa0m3ZNPDZSqhQhkitrtdTpFQ=';
  String? FSSAIimageUrl =    'https://media.istockphoto.com/id/1464561797/photo/artificial-intelligence-processor-unit-powerful-quantum-ai-component-on-pcb-motherboard-with.jpg?s=2048x2048&w=is&k=20&c=_h_lwe5-Xb4AK-w3nUfa0m3ZNPDZSqhQhkitrtdTpFQ=';
      String? ShopLogoUrl =    'https://media.istockphoto.com/id/1486626509/photo/woman-use-ai-to-help-work-or-use-ai-everyday-life-at-home-ai-learning-and-artificial.jpg?s=2048x2048&w=is&k=20&c=I9i1MwJ29M2yQBC8BBLOfWyHJ3hlBpYoSmqSXAKFlZM=';


  String GSTheroTag = "sellerGstImage";
  String FSSAIheroTag = "sellerFSSAIImage";
  String ShopLogoheroTag = "sellerShopLogo";

  File? GSTimageFile;
  File? FSSAIimageFile;
  File? ShopLogoFile;

  Future<void> _pickGSTImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        GSTimageFile = File(pickedFile.path);
        GSTimageUrl = null;// Store the selected image
        isGSTImageEdited = true;
      });
    }
  }
  Future<void> _pickFSSAIImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        FSSAIimageFile = File(pickedFile.path);
        FSSAIimageUrl = null;// Store the selected image
        isFSSAIImageEdited = true;
      });
    }
  }
  Future<void> _pickShopLogo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        ShopLogoFile = File(pickedFile.path);
        ShopLogoUrl = null;// Store the selected image
        isShopLogoEdited = true;
      });
    }
  }


  bool isGSTImageEdited = false;
  bool isFSSAIImageEdited = false;
  bool isShopLogoEdited = false;
  bool isDeleteShopImageEdited = false;
  bool isAddShopImagesEdited = false;
  bool isShopNameEdited = false;
  bool isLandLineNoEdited = false;
  bool isShopAddressEdited = false;
  bool isGSTNoEdited = false;
  bool isFSSAILicenseEdited = false;
  bool isShopOpenTimeEdited = false;
  bool isShopCloseTimeEdited = false;
  bool isShopTimeEdited = false;

  Future<bool> _onWillPop() async {
    if (isGSTImageEdited || isFSSAIImageEdited || isShopLogoEdited || isDeleteShopImageEdited || isAddShopImagesEdited || isShopNameEdited || isLandLineNoEdited || isShopAddressEdited || isGSTNoEdited || isFSSAILicenseEdited || isShopOpenTimeEdited || isShopCloseTimeEdited || isShopTimeEdited) {
      return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Unsaved Changes'),
            content: Text('You have unsaved changes. Do you want to save them?'),
            actions: <Widget>[
              TextButton(
                child: Text('Discard'),
                onPressed: () {
                  Navigator.of(context).pop(true); // Discard changes and go back
                },
              ),
              TextButton(
                child: Text('Save'),
                onPressed: () {
                  postShopDetails;
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        },
      ) ?? false;
    }
    return true; // If no changes are made, allow navigation without a dialog
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text("Edit Shop Details"),
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

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => GSTImageExpand(imageFile: GSTimageFile, imageUrl: GSTimageUrl, heroTag: GSTheroTag),
                                  ),
                                );
                              },
                              child:Hero(
                                  tag: GSTheroTag,
                                  child: Stack(
                                    children: [
                                      Container(
                                      width: 80, // Adjust the width as needed
                                      height: 80, // Adjust the height as needed
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5), // Adjust the border radius as needed
                                        child: Image(
                                          image: GSTimageFile != null
                                              ? FileImage(GSTimageFile!)
                                              : GSTimageUrl != null
                                              ? NetworkImage(GSTimageUrl!)
                                              : AssetImage('assets/placeholder.png') as ImageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                      Positioned(
                                        top: 55,
                                        left: 55,
                                        child: Stack(
                                          children:[
                                            Container(
                                              height: 25,
                                              width: 25,
                                              color: Colors.white,
                                            ),
                                            Positioned(
                                                top: -10,
                                                left: -11,
                                                child:IconButton(
                                                  icon: Icon(
                                                    Icons.camera_alt_outlined,
                                                    color: Colors.black,
                                                  ),
                                                  onPressed: () {
                                                    // Handle the edit image action here
                                                    _pickGSTImage();
                                                  },
                                                )),
                                          ]

                                        ),
                                      ),

                                    ],

                                  ),

                              ),
                            ),
                            Text('GST Image')
                          ],
                        ), // Adjus

                        const SizedBox(width: 20),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => FSSAIImageExpand(imageFile: FSSAIimageFile, imageUrl: FSSAIimageUrl, heroTag: FSSAIheroTag),
                                  ),
                                );
                              },
                              child:Hero(
                                tag: FSSAIheroTag,
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 80, // Adjust the width as needed
                                      height: 80, // Adjust the height as needed
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5), // Adjust the border radius as needed
                                        child: Image(
                                          image: FSSAIimageFile != null
                                              ? FileImage(FSSAIimageFile!)
                                              : FSSAIimageUrl != null
                                              ? NetworkImage(FSSAIimageUrl!)
                                              : AssetImage('assets/placeholder.png') as ImageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    // Positioned(
                                    //     top: 45,
                                    //     left: 43,
                                    //     child:IconButton(
                                    //       icon: Icon(
                                    //         Icons.camera_alt_sharp,
                                    //         color: Colors.cyanAccent,
                                    //       ),
                                    //       onPressed: () {
                                    //         // Handle the edit image action here
                                    //         _pickFSSAIImage();
                                    //       },
                                    //     )),
                                    Positioned(
                                      top: 55,
                                      left: 55,
                                      child: Stack(
                                          children:[
                                            Container(
                                              height: 25,
                                              width: 25,
                                              color: Colors.white,
                                            ),
                                            Positioned(
                                                top: -10,
                                                left: -11,
                                                child:IconButton(
                                                  icon: Icon(
                                                    Icons.camera_alt_outlined,
                                                    color: Colors.black,
                                                  ),
                                                  onPressed: () {
                                                    // Handle the edit image action here
                                                    _pickFSSAIImage();
                                                  },
                                                )),
                                          ]

                                      ),
                                    ),

                                  ],

                                ),

                              ),
                            ),
                            Text('FSSAI Image')
                          ],
                        ),
                        const SizedBox(width: 20),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => shopLogoExpand(imageFile: ShopLogoFile, imageUrl: ShopLogoUrl, heroTag: ShopLogoheroTag),
                                  ),
                                );
                              },
                              child:Hero(
                                tag: ShopLogoheroTag,
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 80, // Adjust the width as needed
                                      height: 80, // Adjust the height as needed
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5), // Adjust the border radius as needed
                                        child: Image(
                                          image: ShopLogoFile != null
                                              ? FileImage(ShopLogoFile!)
                                              : ShopLogoUrl != null
                                              ? NetworkImage(ShopLogoUrl!)
                                              : AssetImage('assets/placeholder.png') as ImageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    // Positioned(
                                    //     top: 45,
                                    //     left: 43,
                                    //     child:IconButton(
                                    //       icon: Icon(
                                    //         Icons.camera_alt_sharp,
                                    //         color: Colors.cyanAccent,
                                    //       ),
                                    //       onPressed: () {
                                    //         // Handle the edit image action here
                                    //         _pickShopLogo();
                                    //       },
                                    //     )),
                                    Positioned(
                                      top: 55,
                                      left: 55,
                                      child: Stack(
                                          children:[
                                            Container(
                                              height: 25,
                                              width: 25,
                                              color: Colors.white,
                                            ),
                                            Positioned(
                                                top: -10,
                                                left: -11,
                                                child:IconButton(
                                                  icon: Icon(
                                                    Icons.camera_alt_outlined,
                                                    color: Colors.black,
                                                  ),
                                                  onPressed: () {
                                                    // Handle the edit image action here
                                                    _pickShopLogo();
                                                  },
                                                )),
                                          ]

                                      ),
                                    ),

                                  ],

                                ),

                              ),
                            ),
                            Text('Shop Logo')
                          ],
                        ),
                      ],
                    ),

                    // Padding(
                    //   padding: const EdgeInsets.only(left: 8.0),
                    //   child: Container(
                    //     // margin: EdgeInsets.only(right: 20, top: 20, left: 20),
                    //     child: Text(
                    //       'Choose Images',
                    //       style: TextStyle(
                    //         fontSize: 18,
                    //         fontFamily: 'Poppins',
                    //         color: Colors.black87,
                    //       ),
                    //     ),
                    //   ),
                    // ),


                    SizedBox(height: 10,),
                    Text("Shop Images",style: TextStyle(fontSize: 18),),
                    Container(
                      height: 100,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: imgList.length,
                            gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                mainAxisSpacing: 5),
                            itemBuilder:
                                (BuildContext context, int index) {
                              return Stack(

                                children: [
                                  Container(
                                    height:80,
                                    width: 80,
                                    child: Hero(
                                      tag: 'image_$index',
                                      child: GestureDetector(
                                        onTap: () {
                                          showImageExpansion(index);
                                        },
                                        child: Image.network(
                                          imgList[index],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: -10,
                                    right: -5,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.cancel_outlined,
                                        color: Colors.cyanAccent,
                                      ),
                                      onPressed: () {
                                        showDeleteConfirmationDialog(
                                            index);
                                        // removeImage(index);
                                      },
                                    ),
                                  ),
                                ],
                              );
                            }),
                      ),
                    ),

                    Container(
                      height: 20,
                      width: 220,
                      child: ElevatedButton(onPressed: (){
                            setState(() {
                              addMoreShopImages=true;
                            });
                          }, child: Row(
                            children: [
                              Icon(Icons.add,size: 20,),
                              Text("Add More Shop Images"),
                            ],
                          ),
                    ),
                    ),
                    SizedBox(height: 10,),

                    if(addMoreShopImages)
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              selectImages();
                            },
                            child: Container(
                                height: 80,
                                width: 80,
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, top: 10, bottom: 5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(13)),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.camera_alt),
                                    Icon(Icons.add_circle_outline),
                                    Text('Shop Image',style: TextStyle(fontSize: 10),),
                                  ],
                                )),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            height: 100,
                            width: 90,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GridView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: imageFileList!.length,
                                  gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 1,
                                      mainAxisSpacing: 5),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Stack(
                                      children: [
                                        Container(
                                          height:80,
                                          width: 80,
                                          child: Hero(
                                            tag: 'image_$index',
                                            child: GestureDetector(
                                                onTap: () {
                                                  showCameraImageExpansion(
                                                      index);
                                                },
                                                child: Image.file(
                                                  File(imageFileList![index]
                                                      .path),
                                                  fit: BoxFit.cover,
                                                )),
                                          ),
                                        ),
                                        Positioned(
                                          top: -10,
                                          right: -5,
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.cancel_outlined,
                                              color: Colors.cyanAccent,
                                            ),
                                            onPressed: () {
                                              showCameraDeleteConfirmationDialog(
                                                  index);
                                              // removeImage(index);
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),
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
                        controller: shopNameController,
                        onChanged:(value){
                          setState(() {
                            isShopNameEdited=true ;
                          });
                        },
                        validator: (value) {
                          if (value!.length < 5) {
                            return "shopname length must be 5";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'Shop Name',
                          hintText: '  Enter shop Name',
                          prefixIcon: Icon(Icons.store),
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
                          controller: LandlineController,
                          decoration: InputDecoration(
                            labelText: 'Landline Number',
                            hintText: 'Enter your Landline number',
                            prefixIcon: const Icon(Icons.phone),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                          ),
                          keyboardType: TextInputType.phone,
                          onChanged:(value){
                            setState(() {
                              isLandLineNoEdited=true ;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Please enter Landline number';
                            } else if (value.length != 10) {
                              return "number must be 10 digit long";
                            }
                            return null;
                          }),
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
                        controller: shopAddressController,
                        onChanged:(value){
                          setState(() {
                            isShopAddressEdited=true ;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Shop Address here',
                          hintText: 'Enter your Shop Address',
                          prefixIcon: const Icon(Icons.location_on),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
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
                        controller: GSTController,
                        onChanged:(value){
                          setState(() {
                            isGSTNoEdited=true ;
                          });
                        },
                        validator: (value) {
                          if (value!.length < 5) {
                            return "GST Number length must be greater than 5";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'GST Number',
                          hintText: '  Enter GST Number',
                          prefixIcon: Icon(Icons.percent),
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
                        controller: FSSAIController,
                        onChanged:(value){
                          setState(() {
                            isFSSAILicenseEdited=true ;
                          });
                        },
                        validator: (value) {
                          if (value!.length < 5) {
                            return "FSSAI License length must be greater than 5";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'FSSAI License (Optional)',
                          hintText: '  Enter FSSAI License Number',
                          prefixIcon: Icon(Icons.card_membership),
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
                        controller: shopOpenController,
                        onChanged:(value){
                          setState(() {
                            isShopOpenTimeEdited=true ;
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
                          labelText: 'Shop Opening Time',
                          hintText: 'Enter Shop Opening Time',
                          prefixIcon: Icon(Icons.access_time),
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
                        controller: shopCloseController,
                        onChanged:(value){
                          setState(() {
                            isShopCloseTimeEdited=true ;
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
                          labelText: 'Shop Closing Time',
                          hintText: 'Enter Shop Closing Time',
                          prefixIcon: Icon(Icons.access_time),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Container(
                      child: ElevatedButton(
                        child: Text('Edit Shop Time'),
                        onPressed: () {

                           showDialog(
                               context: context,
                               barrierDismissible: false,
                               builder: (BuildContext context) {
                                 return SimpleCustomAlert();
                               });
                           setState(() {
                             isShopTimeEdited=true ;
                           });

                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.grey.shade300)),
                      ),
                    ),
                    SizedBox(height: 40),
                    if (isGSTImageEdited || isFSSAIImageEdited || isShopLogoEdited || isDeleteShopImageEdited || isAddShopImagesEdited || isShopNameEdited || isLandLineNoEdited || isShopAddressEdited || isGSTNoEdited || isFSSAILicenseEdited || isShopOpenTimeEdited || isShopCloseTimeEdited || isShopTimeEdited)
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: postShopDetails,
                        child: Text('Save Shop Details',style:TextStyle(color: Colors.white),),
                        style: ElevatedButton.styleFrom(

                          backgroundColor: Colors.blue.shade900,
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


class GSTImageExpand extends StatelessWidget {
  final File? imageFile;
  final String? imageUrl;
  final String heroTag;

  GSTImageExpand({required this.imageFile, required this.imageUrl, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        actions:[
          IconButton(
            icon: Icon(Icons.close,size: 30,color: Colors.black,),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],

        automaticallyImplyLeading: false, // Remove the back arrow
      ),
      body:  Center(
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

class FSSAIImageExpand extends StatelessWidget {
  final File? imageFile;
  final String? imageUrl;
  final String heroTag;

  FSSAIImageExpand({required this.imageFile, required this.imageUrl, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        actions:[
          IconButton(
            icon: Icon(Icons.close,size: 30,color: Colors.black,),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],

        automaticallyImplyLeading: false, // Remove the back arrow
      ),
      body:  Center(
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


class shopLogoExpand extends StatelessWidget {
  final File? imageFile;
  final String? imageUrl;
  final String heroTag;

  shopLogoExpand({required this.imageFile, required this.imageUrl, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        actions:[
          IconButton(
            icon: Icon(Icons.close,size: 30,color: Colors.black,),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],

        automaticallyImplyLeading: false, // Remove the back arrow
      ),
      body:  Center(
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

