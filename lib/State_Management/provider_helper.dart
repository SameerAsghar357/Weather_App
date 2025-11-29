import 'package:flutter/material.dart';
import 'package:news_app/api_Management/Get_Apis/news_Categories_Api_Call.dart';
import 'package:news_app/api_Management/Get_Apis/news_Headlines_Api_call.dart';
import 'package:news_app/api_Management/Models/newsCategoriesModel.dart';
import 'package:news_app/api_Management/Models/newsHeadlinesModel.dart';
import 'package:news_app/utils/utils.dart';

class ProviderHelper with ChangeNotifier {
  int myIndex = 0;
  String _category = 'general';
  String _Source = 'bbc-news';
  bool _loading = true;

  int get selectedIndex => myIndex;
  String get getSource => _Source;
  String get getCategory => _category;
  bool get getLoading => _loading;

  NewsHeadlinesApiCall newsHeadlinesApiCall = NewsHeadlinesApiCall();
  NewsCategoriesApiCall newsCategoriesApiCall = NewsCategoriesApiCall();
  newsHeadlinesModel headlines = newsHeadlinesModel();
  newsCategoriesModel categories = newsCategoriesModel();
  Utils utils = Utils();

  void updateHeadlineInstance(newValue) {
    headlines = newValue;
  }

  void updateCategoriesInstance(newValue) {
    categories = newValue;
  }

  void setLoading(value) {
    _loading = value;
    notifyListeners();
  }

  void selectedButton(int givenIndex) {
    myIndex = givenIndex;
    notifyListeners();
  }

  void selected_Category(String my_Category) {
    _category = my_Category;
    notifyListeners();
  }

  void selectedHeadline(String mySource) {
    _Source = mySource;
    getHeadlines(_Source);
    notifyListeners();
  }

  Future getHeadlines(String source) async {
    setLoading(true);
    await newsHeadlinesApiCall
        .getNewsHeadlines(source)
        .then((value) {
          updateHeadlineInstance(value);
          setLoading(false);
        })
        .onError((error, stackTrace) {
          utils.toastmessage(error.toString());
          setLoading(false);
        });
  }

  Future getCategories(String category) async {
    await newsCategoriesApiCall
        .getNewsCategories(category)
        .then((value) {
          updateCategoriesInstance(value);
        })
        .onError((error, stackTrace) {
          utils.toastmessage(error.toString());
        });
  }

  //   Future<newsCategoriesModel> selected_CategoryofNews(String mySource) async {
  //     var data = await NewsCategoriesApiCall().getNewsCategories(_category);
  //     notifyListeners();
  //     return data;
  //   }
}
