import 'package:brillianteducationproject/extension/navigator.dart';
import 'package:brillianteducationproject/view/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilSiswaScreen extends StatelessWidget {
  const ProfilSiswaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        centerTitle: true,
        backgroundColor: const Color(0xFFB23AEE),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(
                  'https://via.placeholder.com/120',
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Murid Cemerlang',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Text(
                'siswa@brillianteducation.com',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildProfileItem(
                      Icons.email,
                      'Email',
                      'siswa@brillianteducation.com',
                    ),
                    const Divider(height: 0),
                    _buildProfileItem(
                      Icons.phone,
                      'Nomor Telepon',
                      '+62 812-3456-7890',
                    ),
                    const Divider(height: 0),
                    _buildProfileItem(Icons.book, 'Kelas', 'XII IPA 1'),
                    const Divider(height: 0),
                    _buildProfileItem(
                      Icons.location_on,
                      'Lokasi',
                      'Jakarta, Indonesia',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB23AEE),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {},
                icon: const Icon(Icons.edit),
                label: const Text(
                  'Edit Profil',
                  style: TextStyle(
                    color: CupertinoColors.extraLightBackgroundGray,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  context.pushAndRemoveAll(LoginScreen());
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFB23AEE), size: 24),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
