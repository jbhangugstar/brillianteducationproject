import 'dart:io';
import 'package:brillianteducationproject/extension/navigator.dart';
import 'package:brillianteducationproject/view/login_screen.dart';
import 'package:brillianteducationproject/models/user_model.dart';
import 'package:brillianteducationproject/service/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:brillianteducationproject/helper/image_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilSiswaScreen extends StatefulWidget {
  const ProfilSiswaScreen({super.key});

  @override
  State<ProfilSiswaScreen> createState() => _ProfilSiswaScreenState();
}

class _ProfilSiswaScreenState extends State<ProfilSiswaScreen> {
  final _picker = ImagePicker();
  bool _isUploading = false;

  Future<void> _pickImage(String uid) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _isUploading = true);
      await FirebaseService.uploadProfileImage(File(image.path), uid);
      setState(() => _isUploading = false);
    }
  }

  void _showEditNameDialog(UserModel user) {
    final controller = TextEditingController(text: user.nama);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Nama"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Masukkan nama baru"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () async {
              final updatedUser = UserModel(
                id: user.id,
                email: user.email,
                password: user.password,
                nama: controller.text,
                role: user.role,
                photoUrl: user.photoUrl,
              );
              await FirebaseService.updateUserProfile(updatedUser);
              if (mounted) Navigator.pop(context);
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: Text("Silakan login kembali")));
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Scaffold(body: Center(child: Text("Data tidak ditemukan")));
        }

        final userData = UserModel.fromMap(
          snapshot.data!.data() as Map<String, dynamic>,
        );

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
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage: ImageHelper.getImageProvider(userData.photoUrl),
                        child: _isUploading
                            ? const CircularProgressIndicator()
                            : null,
                      ),
                      CircleAvatar(
                        backgroundColor: const Color(0xFFB23AEE),
                        radius: 18,
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt,
                              size: 16, color: Colors.white),
                          onPressed: () => _pickImage(user.uid),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    userData.nama ?? 'User',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    userData.email,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
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
                          userData.email,
                        ),
                        const Divider(height: 0),
                        _buildProfileItem(
                          Icons.phone,
                          'Nomor Telepon',
                          userData.phone ?? 'Belum diisi',
                        ),
                        const Divider(height: 0),
                        _buildProfileItem(
                          Icons.book,
                          'Sekolah/Kelas',
                          userData.school ?? 'Belum diisi',
                        ),
                        const Divider(height: 0),
                        _buildProfileItem(
                          Icons.location_on,
                          'Lokasi',
                          userData.location ?? 'Belum diisi',
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
                    onPressed: () => _showEditNameDialog(userData),
                    icon: const Icon(Icons.edit, color: Colors.white),
                    label: const Text(
                      'Edit Profil',
                      style: TextStyle(color: Colors.white),
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
                      FirebaseService.logout();
                      context.pushAndRemoveAll(const LoginScreen());
                    },
                    icon: const Icon(Icons.logout, color: Colors.white),
                    label: const Text(
                      'Logout',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFB23AEE), size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
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
          ),
        ],
      ),
    );
  }
}
