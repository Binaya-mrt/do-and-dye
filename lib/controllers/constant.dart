import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  SharedPreferences? getSharedPrefs() {
    SharedPreferences.getInstance().then((prefs) {
      return prefs;
    });
    return null;
  }
}
