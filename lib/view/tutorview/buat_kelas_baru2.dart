import 'package:brillianteducationproject/controller/kelas_controller.dart';
import 'package:brillianteducationproject/extension/navigator.dart';
import 'package:brillianteducationproject/models/kelas_model.dart';
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
  final String? kelasId;
  final String? tutorId;

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
    this.tutorId,
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

      final kelas = Kelas(
        id: widget.kelasId,
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
        idTutor: widget.tutorId,
      );

      // MODE EDIT
      if (widget.kelasId != null) {
        await KelasController.updateKelas(kelas);
      } else {
        // MODE CREATE
        await KelasController.createKelas(kelas);
      }

      if (mounted) {
        final message = widget.kelasId != null
            ? "Kelas berhasil diperbarui"
            : "Kelas berhasil diterbitkan";

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.green),
        );

        await Future.delayed(const Duration(milliseconds: 1200));

        if (mounted) {
          context.pushAndRemoveAll(const TutorMainScreen());
        }
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
            Navigator.pop(context);
          },
        ),
        title: Text(
          isEdit ? "Konfirmasi Edit" : "Konfirmasi Terbit",
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
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ringkasan Data Kelas',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const Divider(height: 30),
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
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Ubah Data"),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _terbitkanKelas,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff3D5AFE),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            isEdit ? "Simpan Perubahan" : "Terbitkan Sekarang",
                            style: const TextStyle(fontWeight: FontWeight.bold),
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
      padding: const EdgeInsets.only(bottom: 15),
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
            maxLines: isMultiline ? 5 : 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
