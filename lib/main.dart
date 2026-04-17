import 'package:brillianteducationproject/database/preference.dart';
import 'package:brillianteducationproject/firebase_options.dart';
import 'package:brillianteducationproject/helper/role_helper.dart'; // Import RoleHelper
import 'package:brillianteducationproject/view/login_screen.dart';
import 'package:brillianteducationproject/view/siswaview/siswa_main_screen.dart'; // Import Screen Siswa
import 'package:brillianteducationproject/view/tutorview/tutor_main_screen.dart'; // Import Screen Tutor
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    debugPrint("== STARTING INITIALIZATION ==");

    // 1. Inisialisasi Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // 2. Inisialisasi Preferences
    final prefs = PreferenceHandler();
    await prefs.init().timeout(const Duration(seconds: 5));

    // 3. Ambil Status Login dan Role
    bool isLoggedIn = await prefs.getIsLogin() ?? false;
    String? role = await prefs.getUserRole();

    debugPrint("Auth Status: $isLoggedIn, Role: $role");

    // 4. Jalankan Aplikasi dengan data yang sudah didapat
    runApp(MyApp(isLoggedIn: isLoggedIn, role: role));
  } catch (e, stackTrace) {
    debugPrint("CRITICAL ERROR: $e");
    // Tampilan Error jika inisialisasi gagal (kode kamu sudah bagus di sini)
    runApp(
      MaterialApp(
        home: Scaffold(body: Center(child: Text("Gagal Memuat Aplikasi: $e"))),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final String? role;

  const MyApp({super.key, required this.isLoggedIn, this.role});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Brilliant Education',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // LOGIKA NAVIGASI ROLE DI SINI
      home: _getHome(),
    );
  }

  Widget _getHome() {
    // Jika belum login, ke Login Screen
    if (!isLoggedIn) {
      return const LoginScreen();
    }

    // Jika sudah login, cek rolenya
    if (role == RoleHelper.siswa) {
      return const SiswaMainScreen();
    } else if (role == RoleHelper.tutor) {
      return const TutorMainScreen();
    } else {
      // Jaga-jaga jika role kosong tapi status login true
      return const LoginScreen();
    }
  }
}
