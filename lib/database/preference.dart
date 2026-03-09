import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHandler {
  //Inisialisasi Shared Preference
  static final PreferenceHandler _instance = PreferenceHandler._internal();
  late SharedPreferences _preferences;
  factory PreferenceHandler() => _instance;
  PreferenceHandler._internal();
  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  //Keys
  static const String _isLogin = 'isLogin';
  static const String _studentId = 'studentId';
  static const String _userEmail = 'userEmail';

  //CREATE - Store Login Status
  Future<void> storingIsLogin(bool isLogin) async {
    _preferences.setBool(_isLogin, isLogin);
  }

  //CREATE - Store Student ID
  Future<void> storingStudentId(int id) async {
    _preferences.setInt(_studentId, id);
  }

  //CREATE - Store User Email
  Future<void> storingUserEmail(String email) async {
    _preferences.setString(_userEmail, email);
  }

  //GET - Login Status
  static Future<bool?> getIsLogin() async {
    final prefs = await SharedPreferences.getInstance();
    var data = prefs.getBool(_isLogin);
    return data;
  }

  //GET - Student ID
  static Future<int?> getStudentId() async {
    final prefs = await SharedPreferences.getInstance();
    var data = prefs.getInt(_studentId);
    return data;
  }

  //GET - User Email
  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    var data = prefs.getString(_userEmail);
    return data;
  }

  //DELETE - Clear All
  Future<void> clearAllPreferences() async {
    await _preferences.remove(_isLogin);
    await _preferences.remove(_studentId);
    await _preferences.remove(_userEmail);
  }
}
