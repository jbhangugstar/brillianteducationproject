import 'package:flutter/material.dart';
import 'package:brillianteducationproject/controller/kelas_controller.dart';
import 'package:brillianteducationproject/controller/enrollment_controller.dart';
import 'package:brillianteducationproject/widget/student_enrollment_card.dart';
import 'package:brillianteducationproject/database/preference.dart';
import 'package:brillianteducationproject/models/enrollment_model.dart';
import 'package:brillianteducationproject/controller/siswa_controller.dart';
import 'package:brillianteducationproject/models/siswa_model.dart';

class ClassDetailScreen extends StatefulWidget {
  final int kelasId;
  final String namaKelas;

  const ClassDetailScreen({
    Key? key,
    required this.kelasId,
    required this.namaKelas,
  }) : super(key: key);

  @override
  State<ClassDetailScreen> createState() => _ClassDetailScreenState();
}

class _ClassDetailScreenState extends State<ClassDetailScreen> {
  late Future<dynamic> kelasFuture;
  late Future<List<dynamic>> studentsFuture;

  @override
  void initState() {
    super.initState();
    kelasFuture = KelasController.getKelasById(widget.kelasId);
    studentsFuture = EnrollmentController.getEnrollmentsByClass(widget.kelasId);
  }

  Future<void> daftarKelas(dynamic kelas) async {
    String? studentId = await PreferenceHandler.getStudentId();

    if (studentId == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Student ID tidak ditemukan"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    String? email = await PreferenceHandler.getUserEmail();

    if (email == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Email tidak ditemukan"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    SiswaModel? siswa = await SiswaController.getSiswaByEmail(email);

    if (siswa == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Data siswa tidak ditemukan"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    bool sudahDaftar = await EnrollmentController.isStudentEnrolled(
      studentId,
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
      idSiswa: studentId,
      idKelas: widget.kelasId,
      namaSiswa: siswa.nama,
      namaKelas: kelas['nama_kelas'],
      status: "aktif",
      nilaiProgress: 0,
      tanggalDaftar: DateTime.now().toString(),
    );

    await EnrollmentController.enrollStudent(enrollment);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text("Berhasil daftar ke ${kelas['nama_kelas']}!"),
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
      body: FutureBuilder<dynamic>(
        future: kelasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF6C4FD8)),
            );
          }

          if (!snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(),
              body: const Center(child: Text("Kelas tidak ditemukan")),
            );
          }

          final kelas = snapshot.data;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    kelas['nama_kelas'] ?? 'Kelas',
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
                            'Rp ${kelas['harga']}',
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
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Daftar Kelas"),
                                  content: Text(
                                    "Daftar ke kelas ${kelas['nama_kelas']}?",
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

              FutureBuilder<List<dynamic>>(
                future: studentsFuture,
                builder: (context, studentSnapshot) {
                  if (studentSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final students = studentSnapshot.data ?? [];

                  if (students.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text("Belum ada siswa yang terdaftar"),
                      ),
                    );
                  }

                  return SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final student = students[index];

                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: StudentEnrollmentCard(
                          namaSiswa:
                              student['nama_siswa'] ?? 'Siswa Tidak Diketahui',
                          statusEnrollment: student['status'] ?? 'aktif',
                          nilaiProgress: (student['nilai_progress'] ?? 0)
                              .toDouble(),
                          tanggalDaftar:
                              student['tanggal_daftar'] ?? 'Tidak diketahui',
                        ),
                      );
                    }, childCount: students.length),
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
