class OfflineBookModel{
  int? id;
  String? categoryId;
  String? categoryName;
  String? categoryDescription;
  String? catImage;

  OfflineBookModel(this.categoryId,this.categoryName,this.categoryDescription,this.catImage);

  //Convert a note object to mop object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    if (id != null) {map['id'] = id;}
    map['categoryId'] = categoryId;
    map['categoryName'] = categoryName;
    map['categoryDescription'] = categoryDescription;
    map['catImage'] = catImage;
    return map;
  }

  //Extract a note object from a map object
  OfflineBookModel.fromMapObject(Map<String, dynamic> map) {
    id = map['id'];
    categoryId = map['categoryId'];
    categoryName = map['categoryName'];
    categoryDescription = map['categoryDescription'];
    catImage = map['catImage'];
  }
}