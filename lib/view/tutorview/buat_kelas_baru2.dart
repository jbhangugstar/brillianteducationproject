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
  final int? kelasId;
  final int? tutorId; // ⭐ tutorId ditambahkan

  const BuatKelasStep2Screen({
    super.key,
    required this.namaKelas,
    required this.kategori,
    required this.jadwal,
    required this.harga,
    required this.tutor,
    required this.deskripsi,
    required this.gambar,
    this.kelasId,
    this.tutorId, // ⭐ wajib kirim dari Step 1
  });

  @override
  State<BuatKelasStep2Screen> createState() => _BuatKelasStep2ScreenState();
}

class _BuatKelasStep2ScreenState extends State<BuatKelasStep2Screen> {
  bool _isLoading = false;

  Future<void> _terbitkanKelas() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (widget.namaKelas.isEmpty) {
        throw Exception("Nama kelas tidak boleh kosong");
      }

      final hargaInt = int.tryParse(widget.harga);
      if (hargaInt == null) {
        throw Exception("Harga tidak valid");
      }

      // Buat object Kelas
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
        idTutor: widget.tutorId, // ⭐ penting! supaya muncul di Jadwal Tutor
      );

      late int result;

      // MODE EDIT
      if (widget.kelasId != null) {
        result = await KelasController.updateKelas(widget.kelasId!, kelas);
      } else {
        // MODE CREATE
        result = await KelasController.createKelas(kelas);
      }

      if (result > 0) {
        final message = widget.kelasId != null
            ? "Kelas berhasil diperbarui"
            : "Kelas berhasil diterbitkan";

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message), backgroundColor: Colors.green),
          );

          await Future.delayed(const Duration(milliseconds: 1200));

          if (mounted) {
            context.push(TutorMainScreen());
          }
        }
      } else {
        throw Exception("Gagal menyimpan kelas");
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("ERROR: $e"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isEdit = widget.kelasId != null;

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
        title: Text(
          isEdit ? "Edit Kelas" : "Buat Kelas Baru",
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                    style: TextStyle(fontWeight: FontWeight.bold),
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
            const SizedBox(height: 40),
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
                        : Text(
                            isEdit ? "Simpan Perubahan" : "Terbitkan Kelas",
                            style: const TextStyle(color: Colors.white),
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
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
