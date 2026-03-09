import 'package:flutter/material.dart';
import 'package:brillianteducationproject/controller/kelas_controller.dart';
import 'package:brillianteducationproject/controller/enrollment_controller.dart';
import 'package:brillianteducationproject/widget/student_enrollment_card.dart';

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
              // App Bar dengan Header
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
                    child: Stack(
                      children: [
                        Positioned(
                          right: -30,
                          top: -30,
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (kelas['kategori'] != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    kelas['kategori'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Quick Info
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildQuickInfo(
                              icon: Icons.people,
                              label: 'Siswa',
                              value: '${kelas['jumlah_siswa'] ?? 0}',
                            ),
                            _buildQuickInfo(
                              icon: Icons.star,
                              label: 'Rating',
                              value: '${kelas['rating'] ?? 0}',
                            ),
                            _buildQuickInfo(
                              icon: Icons.schedule,
                              label: 'Durasi',
                              value: '${kelas['durasi'] ?? 0} jam',
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Harga dan Tombol
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Harga per Sesi',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Rp ${kelas['harga']}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF6C4FD8),
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton.icon(
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
                                      onPressed: () {
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            backgroundColor: Colors.green,
                                            content: Text(
                                              "Berhasil daftar ke ${kelas['nama_kelas']}!",
                                            ),
                                            behavior: SnackBarBehavior.floating,
                                            margin: const EdgeInsets.all(16),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFF6C4FD8,
                                        ),
                                      ),
                                      child: const Text("Daftar"),
                                    ),
                                  ],
                                ),
                              );
                            },
                            icon: const Icon(Icons.check),
                            label: const Text('Daftar'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6C4FD8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Deskripsi
                      const Text(
                        'Deskripsi Kelas',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.2),
                          ),
                        ),
                        child: Text(
                          kelas['deskripsi'] ??
                              'Tidak ada deskripsi untuk kelas ini.',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                            height: 1.5,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Tujuan Pembelajaran
                      if (kelas['tujuan_pembelajaran'] != null) ...[
                        const Text(
                          'Tujuan Pembelajaran',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6C4FD8).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF6C4FD8).withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            kelas['tujuan_pembelajaran'],
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black87,
                              height: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Jadwal
                      const Text(
                        'Jadwal Kelas',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.schedule,
                              color: Color(0xFF6C4FD8),
                              size: 18,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              kelas['jadwal'] ?? 'Jadwal tidak tersedia',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Tingkat Kesukaran
                      if (kelas['tingkat_kesukaran'] != null) ...[
                        const Text(
                          'Tingkat Kesukaran',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: _getDifficultyColor(
                              kelas['tingkat_kesukaran'],
                            ).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            kelas['tingkat_kesukaran'],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: _getDifficultyColor(
                                kelas['tingkat_kesukaran'],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Section Siswa Terdaftar
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

              // Students List
              FutureBuilder<List<dynamic>>(
                future: studentsFuture,
                builder: (context, studentSnapshot) {
                  if (studentSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(
                          color: Color(0xFF6C4FD8),
                        ),
                      ),
                    );
                  }

                  final students = studentSnapshot.data ?? [];

                  if (students.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.2),
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.people_outline,
                                size: 48,
                                color: Colors.grey.withOpacity(0.3),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Belum ada siswa yang terdaftar',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  return SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final student = students[index];
                      return Padding(
                        padding: EdgeInsets.fromLTRB(
                          16,
                          index == 0 ? 16 : 0,
                          16,
                          16,
                        ),
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

              // Bottom Spacing
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildQuickInfo({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF6C4FD8), size: 24),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'pemula':
      case 'mudah':
        return Colors.green;
      case 'menengah':
      case 'sedang':
        return Colors.orange;
      case 'lanjut':
      case 'sulit':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
