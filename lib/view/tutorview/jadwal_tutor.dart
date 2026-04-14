import 'dart:io';
import 'package:brillianteducationproject/database/preference.dart';
import 'package:brillianteducationproject/extension/navigator.dart';
import 'package:brillianteducationproject/view/tutorview/buat_kelas_baru.dart';
import 'package:brillianteducationproject/controller/kelas_controller.dart';
import 'package:brillianteducationproject/models/kelas_model.dart';
import 'package:brillianteducationproject/view/tutorview/manage_students_screen.dart';
import 'package:flutter/material.dart';

class JadwalTutorScreen extends StatefulWidget {
  const JadwalTutorScreen({super.key});

  @override
  State<JadwalTutorScreen> createState() => _JadwalTutorScreenState();
}

class _JadwalTutorScreenState extends State<JadwalTutorScreen> {
  Future<List<Kelas>>? kelasFuture;
  String? tutorId;

  @override
  void initState() {
    super.initState();
    loadTutorKelas();
  }

  // ============================
  // LOAD KELAS SESUAI TUTOR LOGIN
  // ============================
  Future<void> loadTutorKelas() async {
    tutorId = await PreferenceHandler.getTutorId();
    if (tutorId != null) {
      setState(() {
        kelasFuture = KelasController.getKelasByTutor(tutorId!);
      });
    }
  }

  // ============================
  // REFRESH DATA
  // ============================
  void _refreshKelas() {
    if (tutorId != null) {
      setState(() {
        kelasFuture = KelasController.getKelasByTutor(tutorId!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),

      appBar: AppBar(
        backgroundColor: const Color(0xFFB23AEE),
        elevation: 0,
        title: const Text(
          "Jadwal Tutor",
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
        icon: const Icon(Icons.add),
        label: const Text("Kelas Baru"),
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
                  return const Center(child: Text("Belum ada kelas"));
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

  Widget kelasCard({
    required BuildContext context,
    required Kelas kelas,
    required VoidCallback onRefresh,
  }) {
    final id = kelas.id ?? 0;
    final title = kelas.namaKelas;
    final price = 'Rp ${kelas.harga}';
    final schedule = kelas.jadwal;
    final students = '${kelas.jumlahSiswa ?? 0} siswa';
    final kategori = kelas.kategori;
    final status = kelas.status ?? 'aktif';

    Color statusColor;

    switch (status.toLowerCase()) {
      case 'aktif':
        statusColor = Colors.green;
        break;
      case 'selesai':
        statusColor = Colors.blue;
        break;
      case 'batal':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            color: Colors.black.withOpacity(0.08),
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFF6C4FD8),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
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
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),

                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// GAMBAR
          if (kelas.foto != null && kelas.foto!.isNotEmpty)
            ClipRRect(
              child: Image.file(
                File(kelas.foto!),
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(12),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  price,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 6),

                Text(schedule),

                const SizedBox(height: 6),

                Text(students),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          context.push(
                            ManageStudentsScreen(kelasId: id, namaKelas: title),
                          );
                        },

                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C4FD8),
                        ),

                        child: const Text(
                          "Kelola Kelas",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == "edit") {
                          context
                              .push(
                                BuatKelasBaruScreen(
                                  kelas: kelas,
                                  kelasId: kelas.id,
                                ),
                              )
                              .then((_) => onRefresh());
                        }

                        if (value == "delete") {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Hapus Kelas"),
                              content: const Text(
                                "Apakah yakin ingin menghapus kelas ini?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Batal"),
                                ),

                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),

                                  onPressed: () async {
                                    Navigator.pop(context);

                                    if (kelas.id != null) {
                                      await KelasController.deleteKelas(
                                        kelas.id!,
                                      );

                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Kelas berhasil dihapus",
                                          ),
                                        ),
                                      );

                                      onRefresh();
                                    }
                                  },

                                  child: const Text("Hapus"),
                                ),
                              ],
                            ),
                          );
                        }
                      },

                      itemBuilder: (context) => const [
                        PopupMenuItem(value: "edit", child: Text("Edit")),
                        PopupMenuItem(value: "delete", child: Text("Hapus")),
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
