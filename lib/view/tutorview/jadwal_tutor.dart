import 'dart:io';
import 'package:brillianteducationproject/extension/navigator.dart';
import 'package:brillianteducationproject/view/tutorview/buat_kelas_baru.dart';
import 'package:brillianteducationproject/controller/kelas_controller.dart';
import 'package:brillianteducationproject/models/kelas_model.dart';
import 'package:brillianteducationproject/view/tutorview/manage_students_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class JadwalTutorScreen extends StatefulWidget {
  const JadwalTutorScreen({super.key});

  @override
  State<JadwalTutorScreen> createState() => _JadwalTutorScreenState();
}

class _JadwalTutorScreenState extends State<JadwalTutorScreen> {
  Future<List<Kelas>>? kelasFuture;

  @override
  void initState() {
    super.initState();
    loadTutorKelas();
  }

  // ============================
  // LOAD KELAS SESUAI TUTOR LOGIN
  // ============================
  void loadTutorKelas() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        kelasFuture = KelasController.getKelasByTutor(user.uid);
      });
    }
  }

  // ============================
  // REFRESH DATA
  // ============================
  void _refreshKelas() {
    loadTutorKelas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 223, 58, 238), Color(0xFF9966FF)],
            ),
          ),
        ),
        elevation: 0,
        title: const Text(
          "Jadwal Mengajar",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _refreshKelas,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push(const BuatKelasBaruScreen()).then((_) {
            _refreshKelas();
          });
        },
        backgroundColor: const Color(0xFF6C4FD8),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Buat Kelas", style: TextStyle(color: Colors.white)),
      ),
      body: kelasFuture == null
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<List<Kelas>>(
              future: kelasFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF6C4FD8)),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return _buildEmptyState();
                }

                final kelasList = snapshot.data!;

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: kelasList.length,
                  itemBuilder: (context, index) {
                    final kelas = kelasList[index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: kelasCard(
                        context: context,
                        kelas: kelas,
                        onRefresh: _refreshKelas,
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.class_outlined,
            size: 80,
            color: Colors.grey.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          const Text(
            "Anda belum memiliki kelas",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(String? fotoPath) {
    if (fotoPath == null || fotoPath.isEmpty) {
      return Container(
        width: double.infinity,
        height: 140,
        color: Colors.grey[200],
        child: const Icon(Icons.image_outlined, color: Colors.grey),
      );
    }

    if (fotoPath.startsWith('http://') || fotoPath.startsWith('https://')) {
      return Image.network(
        fotoPath,
        width: double.infinity,
        height: 140,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          color: Colors.grey[200],
          child: const Icon(Icons.broken_image, color: Colors.grey),
        ),
      );
    }

    final file = File(fotoPath);
    if (file.existsSync()) {
      return Image.file(
        file,
        width: double.infinity,
        height: 140,
        fit: BoxFit.cover,
      );
    }

    return Container(
      width: double.infinity,
      height: 140,
      color: Colors.grey[200],
      child: const Icon(Icons.image_outlined, color: Colors.grey),
    );
  }

  Widget kelasCard({
    required BuildContext context,
    required Kelas kelas,
    required VoidCallback onRefresh,
  }) {
    final title = kelas.namaKelas;
    final price = 'Rp ${kelas.harga}';
    final schedule = kelas.jadwal;
    final students = '${kelas.jumlahSiswa ?? 0} siswa';
    final status = kelas.status ?? 'aktif';

    Color statusColor = status.toLowerCase() == 'aktif'
        ? Colors.green
        : Colors.grey;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImage(kelas.foto),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        status.toUpperCase(),
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  schedule,
                  style: const TextStyle(
                    color: Color(0xFF6C4FD8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      price,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      students,
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
                const Divider(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          context.push(
                            ManageStudentsScreen(
                              kelasId: kelas.id!,
                              namaKelas: title,
                            ),
                          );
                        },
                        icon: const Icon(Icons.people_outline, size: 18),
                        label: const Text("Kelola Siswa"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C4FD8),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    PopupMenuButton<String>(
                      onSelected: (value) async {
                        if (value == "edit") {
                          context
                              .push(
                                BuatKelasBaruScreen(
                                  kelas: kelas,
                                  kelasId: kelas.id,
                                ),
                              )
                              .then((_) => onRefresh());
                        } else if (value == "delete") {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Hapus Kelas"),
                              content: const Text(
                                "Apakah Anda yakin ingin menghapus kelas ini?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text("Batal"),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  child: const Text(
                                    "Hapus",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            await KelasController.deleteKelas(kelas.id!);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Kelas berhasil dihapus"),
                              ),
                            );
                            onRefresh();
                          }
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: "edit",
                          child: Row(
                            children: [
                              Icon(Icons.edit, size: 20),
                              SizedBox(width: 8),
                              Text("Edit"),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: "delete",
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 20, color: Colors.red),
                              SizedBox(width: 8),
                              Text(
                                "Hapus",
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
