

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class Storage{
static const String key ="user_task";

static Future<void> saveUser(List<User> users)async {
final prefs = await SharedPreferences.getInstance();
final encoded = jsonEncode(users.map((u)=> u.toJson()).toList());
await prefs.setString(key, encoded);

}

static Future<List<User>> getUser() async {
  final prefs = await SharedPreferences.getInstance();
  final saved = prefs.getString(key);
  if(saved != null){
    final List decoded = jsonDecode(saved);
    return decoded.map((e)=> User.fromJson(e)).toList();
  }
  return [];
}
}

















