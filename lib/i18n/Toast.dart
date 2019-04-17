import 'package:fluttertoast/fluttertoast.dart';
class Toaster{
  static show(String msg) {
    Fluttertoast.showToast(msg: msg, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER);
  }
  static showLong(String msg) {
    Fluttertoast.showToast(msg: msg, toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.CENTER);
  }
}