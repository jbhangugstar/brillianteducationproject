import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHandler {
  // Inisialisasi Singleton
  static final PreferenceHandler _instance = PreferenceHandler._internal();
  SharedPreferences? _preferences;
  factory PreferenceHandler() => _instance;
  PreferenceHandler._internal();

  // Method Init yang dipanggil di main.dart
  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // Keys (Daftar Label Penyimpanan)
  static const String _isLogin = 'isLogin';
  static const String _studentId = 'studentId';
  static const String _userEmail = 'userEmail';
  static const String _tutorId = 'tutorId';
  static const String _userRole = 'userRole'; // Key baru untuk Role

  // ==========================================
  // 1. FUNGSI SIMPAN DATA (SETTERS)
  // ==========================================

  Future<void> storingIsLogin(bool isLogin) async {
    await _preferences?.setBool(_isLogin, isLogin);
  }

  Future<void> storingStudentId(String id) async {
    await _preferences?.setString(_studentId, id);
  }

  Future<void> storingTutorId(String id) async {
    await _preferences?.setString(_tutorId, id);
  }

  Future<void> storingUserEmail(String email) async {
    await _preferences?.setString(_userEmail, email);
  }

  // Simpan Role (Siswa atau Tutor)
  Future<void> storingUserRole(String role) async {
    await _preferences?.setString(_userRole, role);
  }

  // ==========================================
  // 2. FUNGSI AMBIL DATA (GETTERS)
  // ==========================================

  // Perhatikan: Saya hilangkan 'static' agar konsisten menggunakan instance
  Future<bool?> getIsLogin() async {
    return _preferences?.getBool(_isLogin);
  }

  Future<String?> getStudentId() async {
    return _preferences?.getString(_studentId);
  }

  Future<String?> getTutorId() async {
    return _preferences?.getString(_tutorId);
  }

  Future<String?> getUserEmail() async {
    return _preferences?.getString(_userEmail);
  }

  // Ambil Role untuk navigasi di main.dart
  Future<String?> getUserRole() async {
    return _preferences?.getString(_userRole);
  }

  // ==========================================
  // 3. FUNGSI HAPUS DATA (LOGOUT)
  // ==========================================

  Future<void> clearAllPreferences() async {
    // Menghapus semua data yang tersimpan agar aman saat logout
    await _preferences?.clear();
  }
}
