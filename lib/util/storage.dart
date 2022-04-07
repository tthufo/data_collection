import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Storing {
  static Storing? _instance;

  Storing._internal();

  factory Storing() {
    _instance ??= Storing._internal();
    return _instance!;
  }

  Future<void> initCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('pre');

    print(prefs.getInt('homeIndex'));
    if (prefs.getInt('homeIndex') == null) {
      await prefs.setInt('homeIndex', 1);
    }
    if (prefs.getInt('schoolIndex') == null) {
      await prefs.setInt('schoolIndex', 1);
    }
    print('post');

    print(prefs.getInt('homeIndex'));
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

  void addData(object, name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList(name) == null) {
      var list = [jsonEncode(object)];
      await prefs.setStringList(name, list);
    } else {
      var list = prefs.getStringList(name);
      list?.add(jsonEncode(object));
      await prefs.setStringList(name, list!);
    }
  }

  Future<dynamic> getAllData(name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? result = prefs.getStringList(name) ?? [];
    return result;
  }

  Future<dynamic> getDataAt(index, name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? result = prefs.getStringList(name) ?? [];
    return result[index];
  }

  void delDataAt(index, name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? result = prefs.getStringList(name) ?? [];
    result.removeAt(index);
    prefs.setStringList(name, result);
  }

  void addString(string, name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(name, string);
  }

  Future<dynamic> getString(name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String result = prefs.getString(name) ?? "";
    return result;
  }

  void delString(name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(name);
  }
}
