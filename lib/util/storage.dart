import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Storing {
  static Storing? _instance;

  String task = "ablaf";

  Storing._internal();

  factory Storing() {
    _instance ??= Storing._internal();
    return _instance!;
  }

  Future<void> initCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt('home') == null) {
      await prefs.setInt('home', 1);
    }
    if (prefs.getInt('school') == null) {
      await prefs.setInt('school', 1);
    }
  }

  Future<int?> getCounter(name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(name);
  }

  Future<void> updateCounter(name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? counter = await getCounter(name);
    await prefs.setInt(name, counter! + 1);
  }

  _addData(object, name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(name, jsonEncode(object));
  }
}
