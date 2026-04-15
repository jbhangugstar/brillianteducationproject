import 'dart:io';
import 'package:brillianteducationproject/extension/navigator.dart';
import 'package:brillianteducationproject/view/login_screen.dart';
import 'package:brillianteducationproject/models/user_model.dart';
import 'package:brillianteducationproject/service/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilTutorScreen extends StatefulWidget {
  const ProfilTutorScreen({super.key});

  @override
  State<ProfilTutorScreen> createState() => _ProfilTutorScreenState();
}

class _ProfilTutorScreenState extends State<ProfilTutorScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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

  void _showEditProfileDialog(UserModel user) {
    final nameController = TextEditingController(text: user.nama);
    final bioController = TextEditingController(text: user.bio);
    final schoolController = TextEditingController(text: user.school);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Profil"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Nama Lengkap"),
              ),
              TextField(
                controller: schoolController,
                decoration: const InputDecoration(
                  labelText: "Spesialisasi/Sekolah",
                ),
              ),
              TextField(
                controller: bioController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: "Tentang Saya"),
              ),
            ],
          ),
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
                nama: nameController.text,
                bio: bioController.text,
                school: schoolController.text,
                role: user.role,
                photoUrl: user.photoUrl,
                phone: user.phone,
                location: user.location,
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
    final authUser = FirebaseAuth.instance.currentUser;

    if (authUser == null) {
      return const Scaffold(body: Center(child: Text("Silakan login kembali")));
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(authUser.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Scaffold(
            body: Center(child: Text("Data tidak ditemukan")),
          );
        }

        final userData = UserModel.fromMap(
          snapshot.data!.data() as Map<String, dynamic>,
        );

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: const Color(0xFFF2F3F7),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text("Profil", style: TextStyle(color: Colors.black)),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: IconButton(
                  icon: const Icon(Icons.settings, color: Colors.black),
                  onPressed: () {
                    _scaffoldKey.currentState!.openEndDrawer();
                  },
                ),
              ),
            ],
          ),
          endDrawer: Drawer(
            child: SafeArea(
              child: Column(
                children: [
                  const DrawerHeader(
                    child: Column(
                      children: [
                        Icon(Icons.settings, size: 50),
                        SizedBox(height: 10),
                        Text(
                          "Settings",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text(
                      "Logout",
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () {
                      FirebaseService.logout();
                      context.pushAndRemoveAll(const LoginScreen());
                    },
                  ),
                ],
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(255, 199, 196, 201),
                    Color.fromARGB(255, 197, 84, 235),
                    Color.fromARGB(255, 214, 80, 210),
                  ],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// HEADER IMAGE & PHOTO
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Image.asset(
                            "assets/images/library.jpg",
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            bottom: -40,
                            left: 20,
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                CircleAvatar(
                                  radius: 45,
                                  backgroundColor: Colors.white,
                                  child: CircleAvatar(
                                    radius: 42,
                                    backgroundImage: userData.photoUrl != null
                                        ? NetworkImage(userData.photoUrl!)
                                        : const AssetImage(
                                                'assets/images/tutor.jpg',
                                              )
                                              as ImageProvider,
                                    child: _isUploading
                                        ? const CircularProgressIndicator()
                                        : null,
                                  ),
                                ),
                                CircleAvatar(
                                  radius: 15,
                                  backgroundColor: Colors.purple,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.camera_alt,
                                      size: 15,
                                      color: Colors.white,
                                    ),
                                    onPressed: () => _pickImage(authUser.uid),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 50),

                      /// PROFILE INFO
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userData.nama ?? 'Tutor Name',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              userData.school ?? "Kategori Belum Diisi",
                              style: const TextStyle(
                                color: Color.fromARGB(255, 8, 69, 119),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  size: 16,
                                  color: Color.fromARGB(255, 6, 109, 58),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  userData.location ?? "Indonesia",
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 43, 28, 177),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            /// BUTTON
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () =>
                                        _showEditProfileDialog(userData),
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                                    label: const Text(
                                      "Edit Profil",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                        255,
                                        166,
                                        87,
                                        206,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            /// TENTANG
                            const Text(
                              "Tentang",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              userData.bio ?? "Belum ada deskripsi profil.",
                              style: const TextStyle(color: Colors.black87),
                            ),
                            const SizedBox(height: 24),

                            /// REUSABLE SECTION PLACEHOLDERS
                            const Text(
                              "Informasi Lainnya",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 14),
                            infoItem(
                              icon: Icons.email,
                              title: "Email",
                              value: userData.email,
                            ),
                            const SizedBox(height: 12),
                            infoItem(
                              icon: Icons.phone,
                              title: "Telepon",
                              value: userData.phone ?? "Belum diisi",
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget infoItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF4A5BD4)),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(value, style: const TextStyle(color: Colors.black87)),
          ],
        ),
      ],
    );
  }
}
