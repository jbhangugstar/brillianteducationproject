import 'package:brillianteducationproject/view/tutorview/home_tutor.dart';
import 'package:brillianteducationproject/view/tutorview/kelas_tutor_screen.dart';
import 'package:flutter/material.dart';
import 'profil_tutor_screen.dart';

class TutorMainScreen extends StatefulWidget {
  const TutorMainScreen({super.key});

  @override
  State<TutorMainScreen> createState() => _TutorMainScreenState();
}

class _TutorMainScreenState extends State<TutorMainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeTutorScreen(),
    KelasTutorScreen(),
    ProfilTutorScreen(),
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
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Kelas'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
