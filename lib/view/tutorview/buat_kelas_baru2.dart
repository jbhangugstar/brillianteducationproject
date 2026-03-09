import 'package:brillianteducationproject/controller/kelas_controller.dart';
import 'package:brillianteducationproject/extension/navigator.dart';
import 'package:brillianteducationproject/models/kelas_model.dart';
import 'package:brillianteducationproject/view/tutorview/buat_kelas_baru.dart';
import 'package:brillianteducationproject/view/tutorview/tutor_main_screen.dart';
import 'package:flutter/material.dart';

class BuatKelasStep2Screen extends StatefulWidget {
  final String namaKelas;
  final String kategori;
  final String jadwal;
  final String harga;
  final String tutor;
  final String deskripsi;
  final String gambar;

  const BuatKelasStep2Screen({
    super.key,
    required this.namaKelas,
    required this.kategori,
    required this.jadwal,
    required this.harga,
    required this.tutor,
    required this.deskripsi,
    required this.gambar,
  });

  @override
  State<BuatKelasStep2Screen> createState() => _BuatKelasStep2ScreenState();
}

class _BuatKelasStep2ScreenState extends State<BuatKelasStep2Screen> {
  bool _isLoading = false;

  Future<void> _terbitkanKelas() async {
    print('\n===============================================');
    print('MULAI TERBITKAN KELAS');
    print('===============================================');

    setState(() {
      _isLoading = true;
    });

    try {
      // 1. Log data
      print('\n1️⃣ DATA YANG DITERIMA:');
      print('   Nama: ${widget.namaKelas}');
      print('   Kategori: ${widget.kategori}');
      print('   Jadwal: ${widget.jadwal}');
      print('   Harga: ${widget.harga}');
      print('   Tutor: ${widget.tutor}');
      print('   Deskripsi: ${widget.deskripsi}');

      // 2. Validate
      if (widget.namaKelas.isEmpty) {
        throw Exception('Nama kelas kosong!');
      }

      // 3. Convert harga to int
      final hargaInt = int.tryParse(widget.harga);
      print('\n2️⃣ VALIDASI:');
      print('   Harga as int: $hargaInt');

      if (hargaInt == null) {
        throw Exception('Harga tidak valid: ${widget.harga}');
      }

      // 4. Create Kelas object
      print('\n3️⃣ CREATE KELAS OBJECT:');
      final kelas = Kelas(
        namaKelas: widget.namaKelas,
        harga: hargaInt,
        jadwal: widget.jadwal,
        tutor: widget.tutor,
        deskripsi: widget.deskripsi,
        foto: widget.gambar.isNotEmpty ? widget.gambar : null,
        kategori: widget.kategori,
        status: 'aktif',
        jumlahSiswa: 0,
        rating: 0.0,
      );
      print('   ✅ Kelas object created');
      print('   Map: ${kelas.toMap()}');

      // 5. Save to database
      print('\n4️⃣ SAVE TO DATABASE:');
      late int result;
      try {
        result = await KelasController.createKelas(kelas);
      } catch (e) {
        print('   ❌ Exception caught: $e');
        throw Exception('Gagal menyimpan ke database: $e');
      }
      print('   Raw Result: $result (type: ${result.runtimeType})');

      // 6. Check result
      print('\n5️⃣ CHECK RESULT:');
      print('   Checking: $result > 0 = ${result > 0}');

      if (result > 0) {
        print('   ✅✅✅ BERHASIL! ID: $result ✅✅✅');

        if (mounted) {
          // Success notification
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('✅ Kelas berhasil diterbitkan!'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );

          // Tunggu 1.5 detik baru navigate
          await Future.delayed(const Duration(milliseconds: 1500));

          if (mounted) {
            print('   Navigating to TutorMainScreen...');
            context.push(TutorMainScreen());
          }
        }
      } else if (result == -1) {
        print('   ❌ GAGAL! Database Error (result: -1)');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('❌ Gagal menyimpan ke database!'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
        }
      } else {
        print('   ❌ GAGAL! Unexpected result: $result');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ Gagal menerbitkan kelas (result: $result)'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e, st) {
      print('❌ ERROR: $e');
      print('Stack: $st');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('ERROR: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }

    print('\n===============================================');
    print('END TERBITKAN KELAS');
    print('===============================================\n');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            context.push(BuatKelasBaruScreen());
          },
        ),
        title: const Text(
          "Buat Kelas Baru",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// STEP INFO
            const Text(
              "Langkah 2 dari 2",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 4),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Hampir Selesai",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "100%",
                  style: TextStyle(
                    color: Color(0xff3D5AFE),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            LinearProgressIndicator(
              value: 1,
              backgroundColor: Colors.grey.shade300,
              color: const Color(0xff3D5AFE),
              minHeight: 6,
            ),

            const SizedBox(height: 25),

            /// REVIEW DATA KELAS
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ringkasan Data Kelas',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  _buildReviewItem('Nama Kelas', widget.namaKelas),
                  _buildReviewItem('Kategori', widget.kategori),
                  _buildReviewItem('Jadwal', widget.jadwal),
                  _buildReviewItem('Harga', 'Rp ${widget.harga}'),
                  _buildReviewItem('Tutor', widget.tutor),
                  _buildReviewItem(
                    'Deskripsi',
                    widget.deskripsi,
                    isMultiline: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            /// MATERI KELAS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Kurikulum / Materi Kelas",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xffE8EDFF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    "3 Materi",
                    style: TextStyle(color: Color(0xff3D5AFE), fontSize: 12),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            materiItem("Materi 1: Pengenalan Aljabar", "Durasi: 10 Menit"),

            materiItem("Materi 2: Latihan Dasar Logika", "Kuis: 10 Soal"),

            materiItem("Materi 3: Fungsi Kuadrat Dasar", "Video: 20 Menit"),

            const SizedBox(height: 10),

            /// TAMBAH MATERI
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.shade400,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  "+ Tambah Materi Baru",
                  style: TextStyle(
                    color: Color(0xff3D5AFE),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// VISIBILITAS
            const Text(
              "Pengaturan Visibilitas",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            visibilityCard(
              title: "Publik",
              subtitle: "Dapat ditemukan semua orang di pencarian",
              selected: true,
            ),

            const SizedBox(height: 10),

            visibilityCard(
              title: "Privat",
              subtitle: "Hanya siswa dengan link yang bisa masuk",
              selected: false,
            ),

            const SizedBox(height: 25),

            /// PERSYARATAN
            const Text(
              "Persyaratan Siswa (OPSIONAL)",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Contoh: Memahami operasi hitung dasar matematika...",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 40),

            /// BUTTON
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      context.push(BuatKelasBaruScreen());
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text("Kembali"),
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _terbitkanKelas,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff3D5AFE),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text(
                            "Terbitkan Kelas",
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// WIDGET REVIEW ITEM
  Widget _buildReviewItem(
    String label,
    String value, {
    bool isMultiline = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: isMultiline ? 3 : 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  /// WIDGET MATERI ITEM
  Widget materiItem(String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.description, color: Color(0xff3D5AFE)),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),

          const Icon(Icons.delete_outline, color: Colors.grey),
        ],
      ),
    );
  }

  /// WIDGET VISIBILITY
  Widget visibilityCard({
    required String title,
    required String subtitle,
    required bool selected,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: selected ? const Color(0xffEEF1FF) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: selected ? const Color(0xff3D5AFE) : Colors.grey.shade300,
        ),
      ),
      child: Row(
        children: [
          Icon(
            selected ? Icons.radio_button_checked : Icons.radio_button_off,
            color: const Color(0xff3D5AFE),
          ),

          const SizedBox(width: 12),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
