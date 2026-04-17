import 'dart:io';
import 'package:brillianteducationproject/extension/navigator.dart';
import 'package:brillianteducationproject/view/login_screen.dart';
import 'package:brillianteducationproject/models/user_model.dart';
import 'package:brillianteducationproject/service/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:brillianteducationproject/helper/image_helper.dart';
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
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
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
    final phoneController = TextEditingController(text: user.phone);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "Edit Profil",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(nameController, "Nama Lengkap", Icons.person),
              const SizedBox(height: 12),
              _buildTextField(
                schoolController,
                "Spesialisasi/Sekolah",
                Icons.school,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                phoneController,
                "Nomor Telepon",
                Icons.phone,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                bioController,
                "Tentang Saya",
                Icons.info_outline,
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
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
                phone: phoneController.text,
                location: user.location,
              );
              await FirebaseService.updateUserProfile(updatedUser);
              if (context.mounted) Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9966FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text("Simpan", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
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
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text(
              "Brilliant Education",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: const CircleAvatar(
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.settings, color: Colors.white),
                ),
                onPressed: () => _scaffoldKey.currentState!.openEndDrawer(),
              ),
              const SizedBox(width: 8),
            ],
          ),
          endDrawer: _buildDrawer(context),
          body: Container(
            width: double.infinity,
            height: double.infinity,
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(userData, authUser.uid),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
                    child: Column(
                      children: [
                        _buildMainInfoCard(userData),
                        const SizedBox(height: 20),
                        _buildAboutCard(userData),
                        const SizedBox(height: 20),
                        _buildContactCard(userData),
                        const SizedBox(height: 40),
                      ],
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

  Widget _buildHeader(UserModel userData, String uid) {
    return SizedBox(
      height: 275,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: 220,
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              image: DecorationImage(
                image: AssetImage("assets/images/library.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                color: Colors.black.withValues(alpha: 0.3),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: ImageHelper.getImageProvider(userData.photoUrl),
                    child: _isUploading
                        ? const CircularProgressIndicator()
                        : null,
                  ),
                ),
                GestureDetector(
                  onTap: () => _pickImage(uid),
                  child: const CircleAvatar(
                    radius: 18,
                    backgroundColor: Color(0xFF9966FF),
                    child: Icon(Icons.camera_alt, size: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainInfoCard(UserModel userData) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 15),
        ],
      ),
      child: Column(
        children: [
          Text(
            userData.nama ?? 'Tutor Name',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(
            userData.school ?? "Kategori Belum Diisi",
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on, size: 18, color: Colors.redAccent),
              const SizedBox(width: 4),
              Text(
                userData.location ?? "Indonesia",
                style: const TextStyle(color: Colors.black54),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showEditProfileDialog(userData),
              icon: const Icon(Icons.edit_note, color: Colors.white),
              label: const Text(
                "Edit Profil",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C4FD8),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutCard(UserModel userData) {
    return _buildSectionCard(
      title: "Tentang",
      content: Text(
        userData.bio ?? "Belum ada deskripsi profil.",
        style: const TextStyle(color: Colors.black87, height: 1.5),
      ),
    );
  }

  Widget _buildContactCard(UserModel userData) {
    return _buildSectionCard(
      title: "Informasi Kontak",
      content: Column(
        children: [
          _buildInfoRow(Icons.email_outlined, "Email", userData.email),
          const Divider(height: 24),
          _buildInfoRow(
            Icons.phone_android_outlined,
            "Telepon",
            userData.phone ?? "Belum diisi",
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({required String title, required Widget content}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color(0xFF6C4FD8),
            ),
          ),
          const SizedBox(height: 15),
          content,
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: const Color(0xFF6C4FD8).withValues(alpha: 0.1),
          child: Icon(icon, size: 18, color: const Color(0xFF6C4FD8)),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF6C4FD8)),
            accountName: Text("Pengaturan Akun"),
            accountEmail: Text("Brilliant Education"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.settings, color: Color(0xFF6C4FD8)),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              "Logout",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              FirebaseService.logout();
              context.pushAndRemoveAll(const LoginScreen());
            },
          ),
        ],
      ),
    );
  }
}
