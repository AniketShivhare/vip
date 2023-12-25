class SellerProfile {
  String message;
  SellerProfileData data;

  SellerProfile({required this.message, required this.data});

  factory SellerProfile.fromJson(Map<String, dynamic> json) {
    return SellerProfile(
      message: json['message'],
      data: SellerProfileData.fromJson(json['data']),
    );
  }
}

class SellerProfileData {
  GSTIN gstin;
  Address address;
  PanCard panCard;
  BankDetails bankDetails;
  List<String> offDays;
  bool isOnline;
  String id;
  String ownerName;
  String phone;
  String businessType;
  String shopName;
  String photo;
  String fssaiImageUrl;
  String fssaiImages3Url;
  String profilePhoto;
  double marginCharged;
  String shopCategory;
  String panImage;
  String passbookImage;
  String shopPhoto;
  String shopPhotoUrl;
  String profilePhotoUrl;

  SellerProfileData({
    required this.gstin,
    required this.address,
    required this.panCard,
    required this.bankDetails,
    required this.offDays,
    required this.isOnline,
    required this.id,
    required this.ownerName,
    required this.phone,
    required this.fssaiImageUrl,
    required this.passbookImage,
    required this.panImage,
    required this.shopPhoto,
    required this.shopPhotoUrl,
    required this.profilePhoto,
    required this.businessType,
    required this.shopName,
    required this.photo,
    // required this.shopTimings,
    required this.marginCharged,
    required this.shopCategory,
    required landlineNumber,
    required this.fssaiImages3Url,
    required this.profilePhotoUrl,
  });

  factory SellerProfileData.fromJson(Map<String, dynamic> json) {
    return SellerProfileData(
      gstin: GSTIN.fromJson(json['GSTIN']),
      address: Address.fromJson(json['address']),
      panCard: PanCard.fromJson(json['panCard']),
      bankDetails: BankDetails.fromJson(json['bankDetails']),
      offDays: List<String>.from(json['offDays'])??[],
      isOnline: json['isOnline']??false,
      id: json['_id'],
      ownerName: json['ownerName'],
      phone: json['phone'],
      fssaiImageUrl: json['fssaiImageUrl']["s3url"] ?? '',
      fssaiImages3Url: json['fssaiImageUrl']["url"] ?? '',
      passbookImage: json['passbookImage'] ?? '',
      panImage: json['panImage'] ?? '',
      shopPhoto: (json['shopPhoto']!=null) ? json['shopPhoto']["s3url"] ?? '' : '',
      shopPhotoUrl: (json['shopPhoto']!=null) ? json['shopPhoto']["url"] ?? '' : '',

      profilePhoto: json['profilePhoto']["url"] ?? '',
      profilePhotoUrl: json['profilePhoto']["s3url"] ?? '',
      landlineNumber: json['landlineNumber'] ?? '',
      businessType: json['businessType'] ?? '',
      shopName: json['shopName'] ?? '',
      photo: json['photo'] ?? '',
      // shopTimings: List<ShopTimings>.from(
      //     json['shopTimings'].map((x) => ShopTimings.fromJson(x))),
      marginCharged: json['marginCharged'].toDouble(),
      shopCategory: json['shopCategory'] ?? '',
    );
  }
}

class GSTIN {
  String gstinNo;
  String gstinImageUrl;
  String gstinImage;

  GSTIN({required this.gstinNo, required this.gstinImage, required this.gstinImageUrl});

  factory GSTIN.fromJson(Map<String, dynamic> json) {
    return GSTIN(
      gstinNo: json['gstinNo'] ?? '',
      gstinImage: json['gstinImage']["s3url"] ?? 'assets/images/a1.png',
      gstinImageUrl: json['gstinImage']["url"] ?? 'assets/images/a1.png',
    );
  }
}

class Address {
  String addressLine;
  String city;
  String state;
  String pincode;
  String location;

  Address({
    required this.addressLine,
    required this.city,
    required this.state,
    required this.pincode,
    required this.location,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      addressLine: json['addressLine'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      pincode: json['pincode'] ?? '',
      location: json['location'] ?? '',
    );
  }
}

class PanCard {
  String panNo;
  String panImageUrl;
  String panImage;

  PanCard({required this.panNo, required this.panImage, required this.panImageUrl});

  factory PanCard.fromJson(Map<String, dynamic> json) {
    return PanCard(
      panNo: json['panNo'] ?? '',
      panImageUrl: json['panImage']["url"] ?? 'assets/images/a1.png',
      panImage: json['panImage']["s3url"] ?? 'assets/images/a1.png',
    );
  }
}

class BankDetails {
  String accountNo;
  String ifscCode;
  String bankName;
  String branchName;
  String passbookImage;
  String cancelledCheckImage;


  BankDetails({
    required this.accountNo,
    required this.ifscCode,
    required this.bankName,
    required this.branchName,
    required this.passbookImage,
    required this.cancelledCheckImage,
  });

  factory BankDetails.fromJson(Map<String, dynamic> json) {
    return BankDetails(
      accountNo: json['accountNo'] ?? '',
      ifscCode: json['ifscCode'] ?? '',
      bankName: json['bankName'] ?? '',
      branchName: json['branchName'] ?? '',
      passbookImage: json['passbookImage'] ?? 'assets/images/a1.png',
      cancelledCheckImage: json['cancelledCheckImage'] ?? 'assets/images/a1.png',    );
  }
}
