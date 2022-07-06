import 'dart:convert';

Book bookFromJson(String str) => Book.fromJson(json.decode(str));

class Book {
  Book({
    this.result,
  });

  List<Result>? result;

  factory Book.fromJson(Map<String, dynamic> json) => Book(
    result: List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
  );
}

class Result {
  Result({
    this.bookId,
    this.postId,
    this.poemName,
    this.firstLine,
    this.poem,
    this.poetName,
  });

  String? bookId;
  String? postId;
  String? poemName;
  String? firstLine;
  String? poem;
  String? poetName;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    bookId: json["book_id"],
    postId: json["post_id"],
    poemName: json["poem_name"],
    firstLine: json["first_line"],
    poem: json["poem"],
    poetName: json["poet_name"],
  );
}
