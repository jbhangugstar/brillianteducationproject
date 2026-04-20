import 'package:brillianteducationproject/extension/navigator.dart';
import 'package:brillianteducationproject/view/login_screen.dart';
import 'package:brillianteducationproject/view/siswaview/registersiswa_screen.dart';
import 'package:brillianteducationproject/view/tutorview/register_tutor.dart';
import 'package:flutter/material.dart';

class RegisteroptionScreen extends StatelessWidget {
  const RegisteroptionScreen({super.key});

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
          padding: const EdgeInsets.all(100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Logo
              Image.asset(
                "assets/image/brilliantlogo.png",
                height: 300,
                width: 800,
              ),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        context.push(const RegisterSiswaScreen());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // warna tombol
                        foregroundColor: const Color.fromARGB(
                          255,
                          179,
                          8,
                          170,
                        ), // warna teks
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            10,
                          ), // bikin melengkung
                          side: const BorderSide(
                            color: Color.fromARGB(
                              255,
                              179,
                              8,
                              170,
                            ), // warna border
                            width: 2, // tebal border
                          ),
                        ),
                      ),
                      child: const Text(
                        "Daftar sebagai siswa",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        context.push((const RegistertutorScreen()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // warna tombol
                        foregroundColor: Colors.deepPurple, // warna teks
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            10,
                          ), // bikin melengkung
                          side: const BorderSide(
                            color: Colors.deepPurple, // warna border
                            width: 2, // tebal border
                          ),
                        ),
                      ),
                      child: const Text(
                        "Daftar sebagai tutor",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 50),

              ElevatedButton(
                onPressed: () {
                  context.push((const LoginScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text("Kembali"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
