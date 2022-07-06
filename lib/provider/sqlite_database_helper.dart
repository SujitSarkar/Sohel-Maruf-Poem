import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mukto_dhara/model/book_list_model.dart';
import 'package:mukto_dhara/model/favourite_poem_model.dart';
import 'package:mukto_dhara/offline/model/book_list_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';

class DatabaseHelper extends ChangeNotifier{

  final List<OfflineBookModel> _offlineBookList = [];
  final List<FavouritePoemModel> _favouritePoemList = [];
  final List<FavouritePoemModel> _allOfflinePoemList = [];
  final List<String> _favouritePoemIdList = [];

  get offlineBookList => _offlineBookList;
  get favouritePoemList => _favouritePoemList;
  get allOfflinePoemList => _allOfflinePoemList;
  get favouritePoemIdList => _favouritePoemIdList;


  static DatabaseHelper? _databaseHelper; // singleton DatabaseHelper
  static Database? _database; // singleton Database

  String favouritePoemsTable = 'favouritePoemTable';
  String allOfflinePoemsTable = 'allPoemTable';
  String allBookTable = 'allBookTable';

  String colId = 'id';
  String colPostId = 'postId';
  String colPoemName = 'poemName';
  String colFirstLine = 'firstLine';
  String colPoem = 'poem';
  String colPoetName = 'poetName';
  String colBookId = 'bookId';

  ///All bool column
  String colCatId='categoryId';
  String colCatName='categoryName';
  String colCatDescription='categoryDescription';
  String colCatImage='catImage';

  DatabaseHelper._createInstance(); //Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {
    _databaseHelper ??= DatabaseHelper._createInstance();
    return _databaseHelper!;
  }

  void _createDB(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $favouritePoemsTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, '
            '$colPostId TEXT, $colPoemName TEXT, $colFirstLine TEXT, $colPoem TEXT, $colBookId TEXT, $colPoetName TEXT)');

    await db.execute(
        'CREATE TABLE $allOfflinePoemsTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, '
            '$colPostId TEXT, $colPoemName TEXT, $colFirstLine TEXT, $colPoem TEXT, $colBookId TEXT, $colPoetName TEXT)');

    await db.execute(
        'CREATE TABLE $allBookTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, '
            '$colCatId TEXT, $colCatName TEXT, $colCatDescription TEXT, $colCatImage TEXT)');
  }

  Future<Database> initializeDatabase() async {
    //Get the directory path for both android and iOS
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'favouriteBook.db';
    var noteDatabase =
    await openDatabase(path, version: 1, onCreate: _createDB);
    return noteDatabase;
  }

  Future<Database> get database async {
    _database ??= await initializeDatabase();
    return _database!;
  }

  ///Fetch Favourite poems Map list from DB
  Future<List<Map<String, dynamic>>> getFavouritePoemsMapList() async {
    Database db = await database;
    var result = await db.query(favouritePoemsTable, orderBy: '$colId ASC');
    return result;
  }

  ///Get Favourite poem List
  Future<void> getFavouritePoems() async {
    _favouritePoemList.clear();
    _favouritePoemIdList.clear();
    var favouritePoemMapList = await getFavouritePoemsMapList();
    int count = favouritePoemMapList.length;
    for (int i = 0; i < count; i++) {
      _favouritePoemList.add(FavouritePoemModel.fromMapObject(favouritePoemMapList[i]));
      _favouritePoemIdList.add(FavouritePoemModel.fromMapObject(favouritePoemMapList[i]).postId);
    }
    notifyListeners();
  }

  ///Favourite Insert operation
  Future<int> insertFavouritePoem(FavouritePoemModel favouritePoemModel) async {
    Database db = await database;
    var result = await db.insert(favouritePoemsTable, favouritePoemModel.toMap());
    await getFavouritePoems();
    return result;
  }

  ///Favourite Delete operation
  Future<int> deleteFavouritePoem(String postId, int index) async {
    Database db = await database;
    var result =
    await db.rawDelete('DELETE FROM $favouritePoemsTable WHERE $colPostId = $postId');
    _favouritePoemIdList.removeAt(index);
    await getFavouritePoems();
    notifyListeners();
    return result;
  }

  ///...................................................................




  ///Fetch All Offline poems Map list from DB
  Future<List<Map<String, dynamic>>> getAllOfflinePoemsMapList(String bookID) async {
    Database db = await database;
    var result = await db.query(allOfflinePoemsTable,
        where: '$colBookId = ?',
        whereArgs: [bookID],
        orderBy: '$colId ASC');
    return result;
  }

  ///Get Offline Poem List
  Future<void> getOfflinePoemList(String bookID) async {
    _allOfflinePoemList.clear();
    var offlinePoemMapList = await getAllOfflinePoemsMapList(bookID);
    int count = offlinePoemMapList.length;
    for (int i = 0; i < count; i++) {
      _allOfflinePoemList.add(FavouritePoemModel.fromMapObject(offlinePoemMapList[i]));
    }
    //print('Offline List: ${_allOfflinePoemList.length}');
    notifyListeners();
  }

  ///Offline poem Insert operation
  Future<int> insertOfflinePoem(FavouritePoemModel favouritePoemModel) async {
    Database db = await database;
    var result = await db.insert(allOfflinePoemsTable, favouritePoemModel.toMap());
    return result;
  }

  ///Offline poem Delete operation
  Future<int> deleteOfflinePoem(String bookID) async {
    Database db = await database;
    var result = await db.delete(allOfflinePoemsTable,where: '$colBookId = ?',
        whereArgs: [bookID]);
    return result;
  }

  ///Store All poem List To Offline
  Future<void> storeAllPoemsToOffline(List<dynamic> poemList,String bookID)async{
    //await getOfflinePoemList(bookID);
    await deleteOfflinePoem(bookID);

    //print('List: ${poemList.length}');
    await Future.forEach(poemList, (dynamic element)async{
      FavouritePoemModel poemModel = FavouritePoemModel(
          element.postId,
          element.poemName,
          element.firstLine??'',
          element.poem,
          element.bookId,
          element.poetName);
      await insertOfflinePoem(poemModel);
      });
    await getOfflinePoemList(bookID);

    //print('Offline Poem List: ${_allOfflinePoemList.length}');
  }

  ///...................................................................




  ///Fetch Books Map list from DB
  Future<List<Map<String, dynamic>>> getAllBookMapList() async {
    Database db = await database;
    var result = await db.query(allBookTable, orderBy: '$colId ASC');
    return result;
  }

  ///Get All Book 'Map List' and convert it to 'Cart List
  Future<void> getOfflineBookList() async {
    _offlineBookList.clear();
    var allBookMapList = await getAllBookMapList();
    int count = allBookMapList.length;
    for (int i = 0; i < count; i++) {
      _offlineBookList.add(OfflineBookModel.fromMapObject(allBookMapList[i]));
    }
    notifyListeners();
    //print('Offline Book list: ${_offlineBookList.length}');
  }

  ///Book Insert operation
  Future<int> insertOfflineBook(OfflineBookModel offlineBookModel) async {
    Database db = await database;
    var result = await db.insert(allBookTable, offlineBookModel.toMap());
    await getOfflineBookList();
    return result;
  }

  ///Book Delete operation
  Future<int> deleteBookList() async {
    Database db = await database;
    var result = await db.delete(allBookTable);
    await getOfflineBookList();
    notifyListeners();
    return result;
  }

  ///Store All Book List To Offline
  Future<void> storeAllBookToOffline(List<Result> bookList)async{
    await deleteBookList();
    await Future.forEach(bookList, (Result element)async{
      final ByteData imageData = await NetworkAssetBundle(Uri.parse(element.catImage!)).load("");
      final Uint8List bytes = imageData.buffer.asUint8List();
      final String base64Image = base64.encode(bytes);

      ///insert into offline database
      OfflineBookModel offlineBookModel = OfflineBookModel(
          element.categoryId,
          element.categoryName,
          element.categoryDescription,
          base64Image);
      await insertOfflineBook(offlineBookModel);
    });
  }

}