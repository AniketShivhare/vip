class CategoryModel {
  String msg;
  List<String> data;

  CategoryModel({required this.msg, required this.data});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
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
