import 'package:fluttertoast/fluttertoast.dart';

class Utils {
  void toastmessage(String message) {
    Fluttertoast.showToast(
      msg: message
    );
  }
}
