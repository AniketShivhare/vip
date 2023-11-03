class SubCategoryModel {
  String msg;
  List<String> data;

  SubCategoryModel({required this.msg, required this.data});

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      msg: json['msg'],
      data: List<String>.from(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'msg': msg,
      'data': data,
    };
  }
}
