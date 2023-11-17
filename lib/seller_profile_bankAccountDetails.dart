import 'dart:convert';
// import 'dart:html';
import 'dart:io';

import 'package:e_commerce/services/sellerApi.dart';
import 'package:e_commerce/services/sellerTokenId.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_project/apis/sellerProfile.dart';
// import 'package:flutter_project/registeration.dart';
import 'package:e_commerce/services/User_api.dart';
// import 'package:flutter_project/services/sellerApi.dart';
// import 'package:flutter_project/services/sellerTokenId.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'apis/Seller.dart';
import 'apis/sellerProfile.dart';

class BankAccountDetails extends StatefulWidget {
  const BankAccountDetails({super.key});
  // final String title;

  @override
  State<BankAccountDetails> createState() => _BankAccountDetailsState();
}

class _BankAccountDetailsState extends State<BankAccountDetails> {
  var Bank_Account_HolderName_Controller = TextEditingController();
  var Bank_Account_Controller = TextEditingController();
  var Bank_IFSC_Controller = TextEditingController();
  var Pan_Card_Controller = TextEditingController();

  String sellerId = Candidate().id;
  String sellerToken = Candidate().token;
  late SellerProfile seller;

  @override
  initState() {
    fetchSeller();
  }

  Future<void> fetchSeller() async {
    seller = await SellerApi().getSellerProfile(sellerToken, sellerId);
    // if(seller.data.bankDetails.cancelledCheckImage.isNotEmpty) {
    //   imageUrl = seller.data.bankDetails.cancelledCheckImage;
    // }
    // print(imageUrl);
    // print(imageUrl);
    Bank_Account_Controller.text = seller.data.bankDetails.accountNo;
    Bank_IFSC_Controller.text = seller.data.bankDetails.ifscCode;
    Pan_Card_Controller.text = seller.data.panCard.panNo;
  }

  Future<void> postBankDetails() async {
    Map<String, dynamic> json = {
      "accountNo": Bank_Account_Controller.text,
      "ifscCode": Bank_IFSC_Controller.text,
      "panNo": Pan_Card_Controller.text,
    };
    final response =
    await SellerApi().updateBankDetails(json, sellerId, sellerToken);
    if(imageFile1!=null) {
      await UserApi.uploadImage(imageFile1!, "cancelledCheckImage");
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Bank Account Details Updated")));
    Navigator.pop(context);
  }


  String? imageUrl = 'https://media.istockphoto.com/id/1464561797/photo/artificial-intelligence-processor-unit-powerful-quantum-ai-component-on-pcb-motherboard-with.jpg?s=2048x2048&w=is&k=20&c=_h_lwe5-Xb4AK-w3nUfa0m3ZNPDZSqhQhkitrtdTpFQ=';
  String heroTag =  "sellerBankDetails";
  File? imageFile;
  XFile? imageFile1;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        imageFile1 = pickedFile;
        imageUrl = null;// Store the selected image
        isImageEdited = true;
      });
    }
  }

  bool isImageEdited = false;
  bool isBankAccountHolderName = false;
  bool isBankAccountNo = false;
  bool isIFSCCode = false;
  bool isPANCardNo = false;

  Future<bool> _onWillPop() async {
    if (isImageEdited || isBankAccountNo || isIFSCCode || isPANCardNo || isBankAccountHolderName) {
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
                  postBankDetails;
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
            title: Text("Edit Bank Details"),
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
                                builder: (context) => cancelchequeImageExpand(imageFile: imageFile, imageUrl: imageUrl, heroTag: heroTag),
                              ),
                            );
                          },
                          child:Hero(
                            tag: heroTag,
                            child: Stack(
                              children: [
                                Container(
                                  width: 80, // Adjust the width as needed
                                  height: 80, // Adjust the height as needed
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5), // Adjust the border radius as needed
                                    child: Image(
                                        image: imageFile != null
                                                      ? FileImage(imageFile!)
                                                      : imageUrl != null
                                                      ? NetworkImage(imageUrl!)
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
                                                _pickImage();
                                              },
                                            )),
                                      ]

                                  ),
                                ),

                              ],

                            ),

                          ),
                        ),
                        Text('Cancelled Cheque Image')
                      ],
                    ), // Adjus


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
                          controller: Bank_Account_HolderName_Controller,
                          decoration: InputDecoration(
                            labelText: 'Bank Account Holder Name',
                            hintText: 'Enter your Account Holder Name',
                            prefixIcon: const Icon(Icons.account_circle),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                          ),
                          // keyboardType: TextInputType.phone,
                          onChanged:(value){
                            setState(() {
                              isBankAccountHolderName=true ;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Please enter Bank Account Holder Name';
                            } else if (value.length > 1) {
                              return "Bank Account Holder Name must be greater than 1 characters";
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
                          controller: Bank_Account_Controller,
                          decoration: InputDecoration(
                            labelText: 'Bank Account Number',
                            hintText: 'Enter your Account number',
                            prefixIcon: const Icon(Icons.account_balance),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                          ),
                          keyboardType: TextInputType.phone,
                          onChanged:(value){
                            setState(() {
                              isBankAccountNo=true ;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Please enter Bank Account Number';
                            } else if (value.length > 10) {
                              return "Bank Account Number must be greater than 10 digit long";
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
                        controller: Bank_IFSC_Controller,
                        onChanged:(value){
                          setState(() {
                            isPANCardNo=true ;
                          });
                        },
                        // validator: (value) {
                        //   if(value!.length<5) {
                        //     return "username length must be 5";
                        //   } else {
                        //     return null;
                        //   }
                        // },
                        decoration: InputDecoration(
                          labelText: 'IFSC Code',
                          hintText: '  Enter IFSC Code',
                          prefixIcon: Icon(Icons.account_balance),
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
                        controller: Pan_Card_Controller,
                        onChanged:(value){
                          setState(() {
                            isBankAccountNo=true ;
                          });
                        },
                        // validator: (value) {
                        //   if(value!.length<5) {
                        //     return "username length must be 5";
                        //   } else {
                        //     return null;
                        //   }
                        // },
                        decoration: InputDecoration(
                          labelText: 'PAN Card Number',
                          hintText: '  Enter PAN Card Number',
                          prefixIcon: Icon(Icons.credit_card),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                    ),
                    // const SizedBox(
                    //     height: 20
                    // ),

                    SizedBox(height: 60),
                    if(isImageEdited || isBankAccountNo || isIFSCCode || isPANCardNo || isBankAccountHolderName)
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: postBankDetails,
                        child: Text('Save Bank Details',style:TextStyle(color: Colors.white),),

                        style: ElevatedButton.styleFrom(
                          // primary: (isImageEdited || isBankAccountNo || isIFSCCode || isPANCardNo ) ? Colors.greenAccent : null,
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


class cancelchequeImageExpand extends StatelessWidget {
  final File? imageFile;
  final String? imageUrl;
  final String heroTag;

  cancelchequeImageExpand({required this.imageFile, required this.imageUrl, required this.heroTag});

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
