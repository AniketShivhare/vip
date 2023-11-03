class SubCategory2Model {
  String msg;
  List<String> data;

  SubCategory2Model({required this.msg, required this.data});

  factory SubCategory2Model.fromJson(Map<String, dynamic> json) {
    return SubCategory2Model(
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
