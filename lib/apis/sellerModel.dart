import 'dart:core';

class UpdateSeller {
  String ownerName;
  String phone;
  String addressOfShop;
  String city;
  String state;
  String pincode;
  String location;
  String shopName;
  String shopOpeningTime;
  String shopClosingTime;
  String landlineNumber;
  String fssaiLicenseNumber;
  String gstNumber;
  String panNo;
  String panImage;
  String accountNo;
  String ifscCode;
  String bankName;
  String branchName;
  String passbookImage;
  String marginCharged;
  String shopCategory;

  UpdateSeller({
    this.ownerName = '',
    this.phone = '',
    this.addressOfShop = '',
    this.city = '',
    this.state = '',
    this.pincode = '',
    this.location = '',
    this.shopName='',
    this.shopOpeningTime = '',
    this.shopClosingTime = '',
    this.fssaiLicenseNumber = '',
    this.gstNumber = '',
    this.landlineNumber='',
    this.panNo = '',
    this.panImage = '',
    this.accountNo = '',
    this.ifscCode = '',
    this.bankName = '',
    this.branchName = '',
    this.passbookImage = '',
    this.marginCharged = '',
    this.shopCategory = '',
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      "ownerName": ownerName,
      "phone": phone,
      "addressLine2": addressOfShop,
      "city": city,
      "state": state,
      "pincode": pincode,
      "location": location,
      "shopName": shopName,
      "shopOpeningTime": shopOpeningTime,
      "shopClosingTime": shopClosingTime,
      "fssaiLicenseNumber": fssaiLicenseNumber,
      "gstNumber": gstNumber,
      "panNo": panNo,
      "panImage": panImage,
      "accountNo": accountNo,
      "ifscCode": ifscCode,
      "bankName": bankName,
      "branchName": branchName,
      "passbookImage": passbookImage,
      "marginCharged": marginCharged,
      "shopCategory": shopCategory,
    };

    // Excluding empty fields
    json.removeWhere((key, value) => value == '');

    return json;
  }
}

