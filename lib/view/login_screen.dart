import 'package:brillianteducationproject/extension/navigator.dart';
import 'package:brillianteducationproject/service/firebase_service.dart';
import 'package:brillianteducationproject/database/preference.dart';
import 'package:brillianteducationproject/helper/role_helper.dart';
import 'package:brillianteducationproject/view/register_option.dart';
import 'package:brillianteducationproject/view/siswaview/siswa_main_screen.dart';
import 'package:brillianteducationproject/view/tutorview/tutor_main_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  bool isVisibility = false;

  void visibilityOnOff() {
    setState(() {
      isVisibility = !isVisibility;
    });
  }

  Future<void> loginUser() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email dan password wajib diisi')),
      );
      return;
    }

    // LOGIN USER MENGGUNAKAN FIREBASE SERVICE
    final user = await FirebaseService.loginUser(
      email: emailController.text,
      password: passwordController.text,
    );

    if (user != null) {
      final prefs = PreferenceHandler();

      // INIT SHARED PREFERENCE
      await prefs.init();

      // SIMPAN STATUS LOGIN
      await prefs.storingIsLogin(true);

      // SIMPAN STUDENT ID
      if (user.id != null) {
        await prefs.storingStudentId(user.id!);
      }
      // simpan tutorId
      if (user.id != null) {
        await prefs.storingTutorId(user.id!);
      }

      // SIMPAN EMAIL
      await prefs.storingUserEmail(user.email);

      // DEBUG UNTUK CEK ID
      final checkId = await PreferenceHandler.getStudentId();
      print("STUDENT ID TERSIMPAN: $checkId");

      if (!mounted) return;

      // NAVIGASI BERDASARKAN ROLE
      if (user.role == RoleHelper.siswa) {
        context.pushAndRemoveAll(const SiswaMainScreen());
      } else {
        context.pushAndRemoveAll(const TutorMainScreen());
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email atau password salah')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFB23AEE),
              Color(0xFFB23AEE),
              Color.fromARGB(255, 179, 8, 170),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 60),

              Image.asset("assets/image/brilliantlogo.png", height: 300),

              const Text(
                "Your Dreams Matter",
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              // EMAIL
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Masukkan Email",
                  labelText: "Email",
                  prefixIcon: const Icon(Icons.email),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // PASSWORD
              TextFormField(
                controller: passwordController,
                obscureText: !isVisibility,
                decoration: InputDecoration(
                  hintText: "Password",
                  prefixIcon: const Icon(Icons.key),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isVisibility ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: visibilityOnOff,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // BUTTON LOGIN
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: loginUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Masuk",
                    style: TextStyle(
                      color: Colors.purple,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                "Belum punya akun? Daftar",
                style: TextStyle(color: Colors.white),
              ),

              const SizedBox(height: 8),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    context.push(const RegisteroptionScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Daftar Sekarang",
                    style: TextStyle(
                      color: Colors.purple,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
