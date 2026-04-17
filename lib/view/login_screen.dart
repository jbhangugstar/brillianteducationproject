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

    final user = await FirebaseService.loginUser(
      email: emailController.text,
      password: passwordController.text,
    );

    if (user != null) {
      final prefs = PreferenceHandler();
      await prefs.init();
      await prefs.storingIsLogin(true);

      if (user.id != null) {
        await prefs.storingStudentId(user.id!);
        await prefs.storingTutorId(user.id!);
      }

      await prefs.storingUserEmail(user.email);

      if (!mounted) return;

      if (user.role == RoleHelper.siswa) {
        context.pushAndRemoveAll(const SiswaMainScreen());
      } else {
        context.pushAndRemoveAll(const TutorMainScreen());
      }
    } else {
      if (!mounted) return;
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
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  // LOGO
                  Image.asset(
                    "assets/image/brilliantlogo.png",
                    height: 220, // Ukuran dikurangi sedikit agar pas
                    width: 600,
                  ),

                  const Text(
                    "Your Dreams Matter",
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // FIELD EMAIL
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

                  // FIELD PASSWORD
                  TextFormField(
                    controller: passwordController,
                    obscureText: !isVisibility,
                    decoration: InputDecoration(
                      hintText: "Password",
                      prefixIcon: const Icon(Icons.key),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isVisibility
                              ? Icons.visibility
                              : Icons.visibility_off,
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

                  const SizedBox(height: 30),

                  // TOMBOL MASUK
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: loginUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.purple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "Masuk",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  const Text(
                    "Belum punya akun? Daftar",
                    style: TextStyle(color: Colors.white),
                  ),

                  const SizedBox(height: 12),

                  // TOMBOL DAFTAR
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        context.push(const RegisteroptionScreen());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.purple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "Daftar Sekarang",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // Jarak tambahan bawah agar tidak mentok saat scroll
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
