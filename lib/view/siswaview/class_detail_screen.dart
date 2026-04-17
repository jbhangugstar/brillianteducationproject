import 'package:brillianteducationproject/models/kelas_model.dart';
import 'package:brillianteducationproject/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:brillianteducationproject/controller/kelas_controller.dart';
import 'package:brillianteducationproject/controller/enrollment_controller.dart';
import 'package:brillianteducationproject/widget/student_enrollment_card.dart';
import 'package:brillianteducationproject/models/enrollment_model.dart';
import 'package:brillianteducationproject/helper/currency_helper.dart';

class ClassDetailScreen extends StatefulWidget {
  final String kelasId;
  final String namaKelas;

  const ClassDetailScreen({
    super.key,
    required this.kelasId,
    required this.namaKelas,
  });

  @override
  State<ClassDetailScreen> createState() => _ClassDetailScreenState();
}

class _ClassDetailScreenState extends State<ClassDetailScreen> {
  late Future<Kelas?> kelasFuture;
  late Future<List<EnrollmentModel>> studentsFuture;

  @override
  void initState() {
    super.initState();
    kelasFuture = KelasController.getKelasById(widget.kelasId);
    studentsFuture = EnrollmentController.getEnrollmentsByClass(widget.kelasId);
  }

  Future<void> daftarKelas(Kelas kelas) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Silakan login terlebih dahulu"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!userDoc.exists) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Data user tidak ditemukan"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final userData = UserModel.fromMap(userDoc.data()!);

    bool sudahDaftar = await EnrollmentController.isStudentEnrolled(
      user.uid,
      widget.kelasId,
    );

    if (sudahDaftar) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Kamu sudah terdaftar di kelas ini"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    EnrollmentModel enrollment = EnrollmentModel(
      idSiswa: user.uid,
      idKelas: widget.kelasId,
      namaSiswa: userData.nama ?? "Siswa",
      emailSiswa: userData.email,
      namaKelas: kelas.namaKelas,
      status: "aktif",
      nilaiProgress: 0,
      tanggalDaftar: DateTime.now().toIso8601String(),
    );

    await EnrollmentController.enrollStudent(enrollment);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text("Berhasil daftar ke ${kelas.namaKelas}!"),
      ),
    );

    setState(() {
      studentsFuture = EnrollmentController.getEnrollmentsByClass(
        widget.kelasId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: FutureBuilder<Kelas?>(
        future: kelasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF6C4FD8)),
            );
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Scaffold(
              appBar: AppBar(),
              body: const Center(child: Text("Kelas tidak ditemukan")),
            );
          }

          final kelas = snapshot.data!;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    kelas.namaKelas,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF6C4FD8), Color(0xFF9966FF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            CurrencyHelper.formatRupiah(kelas.harga),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6C4FD8),
                            ),
                          ),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.check),
                            label: const Text("Daftar"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6C4FD8),
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Daftar Kelas"),
                                  content: Text(
                                    "Daftar ke kelas ${kelas.namaKelas}?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("Batal"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        await daftarKelas(kelas);
                                      },
                                      child: const Text("Daftar"),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      const Text(
                        'Deskripsi Kelas',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        kelas.deskripsi ?? "Tidak ada deskripsi",
                        style: const TextStyle(color: Colors.black87),
                      ),

                      const SizedBox(height: 24),

                      const Text(
                        'Siswa Terdaftar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),

              FutureBuilder<List<EnrollmentModel>>(
                future: studentsFuture,
                builder: (context, studentSnapshot) {
                  if (studentSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    );
                  }

                  final enrollments = studentSnapshot.data ?? [];

                  if (enrollments.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text("Belum ada siswa yang terdaftar"),
                      ),
                    );
                  }

                  return SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final enrollment = enrollments[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: StudentEnrollmentCard(
                          namaSiswa: enrollment.namaSiswa,
                          statusEnrollment: enrollment.status,
                          nilaiProgress: enrollment.nilaiProgress ?? 0.0,
                          tanggalDaftar: enrollment.tanggalDaftar,
                        ),
                      );
                    }, childCount: enrollments.length),
                  );
                },
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 20)),
            ],
          );
        },
      ),
    );
  }
}
