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
  static const String _tutorId = 'tutorId';

  //CREATE - Store Login Status
  Future<void> storingIsLogin(bool isLogin) async {
    _preferences.setBool(_isLogin, isLogin);
  }

  //CREATE - Store Student ID
  Future<void> storingStudentId(String id) async {
    _preferences.setString(_studentId, id);
  }

  //CREATE - Store Tutor ID
  Future<void> storingTutorId(String id) async {
    _preferences.setString(_tutorId, id);
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
  static Future<String?> getStudentId() async {
    final prefs = await SharedPreferences.getInstance();
    var data = prefs.getString(_studentId);
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

  // ========================
  // GET TUTOR ID
  // ========================
  static Future<String?> getTutorId() async {
    final prefs = await SharedPreferences.getInstance();
    var data = prefs.getString(_tutorId);
    return data;
  }

  // ========================
  // SET TUTOR ID (misal saat login)
  // ========================
  static Future<void> setTutorId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tutorId, id);
  }
}
