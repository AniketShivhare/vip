class CategoryModel {
  String msg;
  List<String> data;

  CategoryModel({ required this.msg, required this.data});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    List<String> categoryList = [];
    for (var item in json['data']) {
      categoryList.add(item['category']);
    }
    print("categoryList");
    print(categoryList);
      // Assuming there's always at least one URL in the list}
    return CategoryModel(
      msg: json['msg'],
      data: categoryList,//List<String>.from(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data,
    };
  }
}
