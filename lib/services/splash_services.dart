import 'package:flutter/material.dart';
import 'package:news_app/Screens/HomeScreen.dart';
import 'package:news_app/State_Management/provider_helper.dart';
import 'package:news_app/utils/utils.dart';
import 'package:provider/provider.dart';

class SplashServices {
  void getAuthetication(BuildContext context) async {
    final provider = Provider.of<ProviderHelper>(context, listen: false);
    final source = provider.getSource;
    final category = provider.getCategory;

    await provider.getCategories(category).whenComplete(() async {
      await provider
          .getHeadlines(source)
          .whenComplete(() {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Homescreen()),
            );
          })
          .onError((error, stackTrace) {
            Utils().toastmessage(error.toString());
          });
    });
  }
}
