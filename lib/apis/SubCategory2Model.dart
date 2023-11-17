class SubCategory2Model {
  String msg;
  List<String> data;

  SubCategory2Model({required this.msg, required this.data});

  factory SubCategory2Model.fromJson(Map<String, dynamic> json) {
    List<String> categoryList = [];
    for (var item in json['data']) {
      categoryList.add(item['subCategory2']);
    }
    return SubCategory2Model(
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
