import 'package:brillianteducationproject/extension/navigator.dart';
import 'package:brillianteducationproject/view/login_screen.dart';
import 'package:brillianteducationproject/view/siswaview/registersiswa_screen.dart';
import 'package:brillianteducationproject/view/tutorview/registertutor_screen.dart';
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
          padding: const EdgeInsets.all(100.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Icon
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,
                child: Icon(Icons.school, size: 40, color: Colors.purple),
              ),

              const SizedBox(height: 16),

              // Judul
              const Text(
                "Brilliant Education",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 50),

              ElevatedButton(
                onPressed: () {
                  context.push(RegistertutorScreen());
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
                    borderRadius: BorderRadius.circular(10), // bikin melengkung
                    side: const BorderSide(
                      color: const Color.fromARGB(
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
                  "Daftar sebagai tutor",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: () {
                  context.push((RegisterSiswaScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // warna tombol
                  foregroundColor: Colors.deepPurple, // warna teks
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // bikin melengkung
                    side: const BorderSide(
                      color: Colors.deepPurple, // warna border
                      width: 2, // tebal border
                    ),
                  ),
                ),
                child: const Text(
                  "Daftar sebagai siswa",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),

              SizedBox(height: 200),

              ElevatedButton(
                child: const Text("Kembali ke Login"),
                onPressed: () {
                  context.push((LoginScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
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
