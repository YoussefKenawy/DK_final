import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utility {
  static const String img_key = "Image_key";

  static Future<bool> saveImageToPrefrences(String value) async {
    final SharedPreferences prefrences = await SharedPreferences.getInstance();

    return prefrences.setString(img_key, value);
  }

  static Future<String> getImageFromPrefrences() async {
    final SharedPreferences prefrences = await SharedPreferences.getInstance();

    return prefrences.getString(img_key);
  }

  static String base64String(Uint8List data) {
    return base64Encode(data);
  }

  static Image imagefrombase64String(String base64String) {
    return Image.memory(base64Decode(base64String), fit: BoxFit.fill);
  }
}
