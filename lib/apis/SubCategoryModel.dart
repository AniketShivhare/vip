class SubCategoryModel {
  String msg;
  List<String> data;

  SubCategoryModel({required this.msg, required this.data});

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    List<String> categoryList = [];
    for (var item in json['data']) {
      categoryList.add(item['subCategory1']);
    }
    return SubCategoryModel(
      msg: json['msg'],
      data: categoryList,//List<String>.from(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'msg': msg,
      'data': data,
    };
  }
}