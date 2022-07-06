import 'dart:convert';

BookListModel bookListModelFromJson(String str) => BookListModel.fromJson(json.decode(str));


class BookListModel {
  BookListModel({
    this.result,
  });

  List<Result>? result;

  factory BookListModel.fromJson(Map<String, dynamic> json) => BookListModel(
    result: List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
  );
}

class Result {
  Result({
    this.categoryId,
    this.categoryName,
    this.categoryDescription,
    this.catImage,
  });

  String? categoryId;
  String? categoryName;
  String? categoryDescription;
  String? catImage;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    categoryId: json["category_id"],
    categoryName: json["category_name"],
    categoryDescription: json["category_description"],
    catImage: json["cat_image"],
  );
}
