import 'package:brillianteducationproject/view/siswaview/jadwal_siswa.dart';
import 'package:brillianteducationproject/view/siswaview/kelas_siswa_screen.dart';
import 'package:flutter/material.dart';
import 'home_siswa.dart';
import 'profil_siswa_screen.dart';

class SiswaMainScreen extends StatefulWidget {
  const SiswaMainScreen({super.key});

  @override
  State<SiswaMainScreen> createState() => _SiswaMainScreenState();
}

class _SiswaMainScreenState extends State<SiswaMainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeSiswaScreen(),
    KelasSiswaScreen(),
    JadwalSiswaScreen(),
    ProfilSiswaScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: const Color(0xFFB23AEE),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Kelas'),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Jadwal Saya',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
