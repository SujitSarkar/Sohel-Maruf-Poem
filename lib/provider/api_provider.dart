import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:mukto_dhara/custom_classes/toast.dart';
import 'package:mukto_dhara/model/book.dart';
import 'package:mukto_dhara/model/book_list_model.dart';
import 'package:http/http.dart' as http;
import 'package:mukto_dhara/model/selected_book_model.dart';
import 'package:mukto_dhara/provider/theme_provider.dart';
import 'package:mukto_dhara/variables/static_variavles.dart';

class ApiProvider extends ChangeNotifier{

  BookListModel? _bookListModel;
  Book? _book;
  SelectedBook? _selectedBook;
  bool connected=true;

  get bookListModel => _bookListModel;
  get book => _book;
  get selectedBook => _selectedBook;

  void setSelectedBook(SelectedBook selectedBook) {
    _selectedBook = selectedBook;
    notifyListeners();
  }

  
  Future <void> getBookList(ThemeProvider themeProvider) async {
    try{
      var response = await http.get(Uri.parse(StaticVariables.baseUrl+'poem.php'));
      if(response.statusCode == 200){
        _bookListModel = bookListModelFromJson(response.body);
        notifyListeners();
      }
    }on SocketException{
      showToast('No internet connection!', themeProvider);
    }
    catch(error){
      // ignore: avoid_print
      print('getting book list error: $error');
    }
  }

  Future <void> getBookPoems(String bookId, ThemeProvider themeProvider) async {
    try{
      var response = await http.get(
          Uri.parse(StaticVariables.baseUrl+'poem_list.php?book=$bookId'));
      if(response.statusCode == 200){
        _book = bookFromJson(response.body);
        notifyListeners();
      }
    }on SocketException{
      showToast('No internet connection!', themeProvider);
    }catch(error){
      if (kDebugMode) {
        print('getting book poems error: $error');
      }
    }
  }

  Future<void> checkConnectivity()async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      connected=true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      connected=true;
    }else{
      connected=false;
    }
    notifyListeners();
  }

  Future<String?> getPageSettingResponse(dynamic pageValue)async{
    String url;
    if(pageValue==3){
      url= StaticVariables.baseUrl+'privacy.php';
    }else if(pageValue==4){
      url= StaticVariables.baseUrl+'terms.php';
    }else{
      url= StaticVariables.baseUrl+'copyright.php';
    }
    try{
      var response = await http.get(Uri.parse(url));
      if(response.statusCode==200){
        var jsonData = jsonDecode(response.body);
        return jsonData['result'].first['page_description'];
      }
    }catch(error){
      if(kDebugMode){
        print(error.toString());
        return null;
      }
    }
    return null;
  }


}