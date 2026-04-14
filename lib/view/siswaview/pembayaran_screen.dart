import 'package:brillianteducationproject/view/siswaview/pembayaran_sukses.dart';
import 'package:flutter/material.dart';
import 'package:brillianteducationproject/models/kelas_model.dart';
import 'package:brillianteducationproject/models/enrollment_model.dart';
import 'package:brillianteducationproject/controller/enrollment_controller.dart';
import 'package:brillianteducationproject/database/preference.dart';

class PembayaranScreen extends StatefulWidget {
  final Kelas kelas;

  const PembayaranScreen({super.key, required this.kelas});

  @override
  State<PembayaranScreen> createState() => _PembayaranScreenState();
}

class _PembayaranScreenState extends State<PembayaranScreen> {
  String metodePembayaran = "ewallet";

  final namaController = TextEditingController();
  final emailController = TextEditingController();
  final promoController = TextEditingController();

  Future<void> prosesBayar() async {
    // VALIDASI INPUT
    if (namaController.text.isEmpty || emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama dan email wajib diisi")),
      );
      return;
    }
    final studentId = await PreferenceHandler.getStudentId() ?? '';

    final enrollment = EnrollmentModel(
      idSiswa: studentId,
      idKelas: widget.kelas.id!,
      namaSiswa: namaController.text,
      namaKelas: widget.kelas.namaKelas,
      tanggalDaftar: DateTime.now().toString(),
      status: "aktif",
    );

    await EnrollmentController.enrollStudent(enrollment);

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PembayaranSuksesPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pembayaran Kelas"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff7F00FF), Color(0xffE100FF)],
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            kelasCard(),
            const SizedBox(height: 20),
            ringkasanPembayaran(),
            const SizedBox(height: 20),
            metodePembayaranCard(),
            const SizedBox(height: 20),
            promoCard(),
            const SizedBox(height: 20),
            detailPeserta(),
            const SizedBox(height: 30),
            bayarButton(),
          ],
        ),
      ),
    );
  }

  Widget kelasCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundImage: AssetImage("assets/class.jpg"),
        ),
        title: Text(widget.kelas.namaKelas),
        subtitle: Text(widget.kelas.tutor),
        trailing: const Icon(Icons.star, color: Colors.orange),
      ),
    );
  }

  Widget ringkasanPembayaran() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              "Ringkasan Pembayaran",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            rowHarga("Harga Kelas", widget.kelas.harga),
            rowHarga("Biaya Layanan", 0),
            const Divider(),
            rowTotal(),
          ],
        ),
      ),
    );
  }

  Widget rowHarga(String label, int harga) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label), Text("Rp $harga")],
      ),
    );
  }

  Widget rowTotal() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [
        const Text(
          "Total Pembayaran",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        Text(
          "Rp ${widget.kelas.harga}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.purple,
          ),
        ),
      ],
    );
  }

  Widget metodePembayaranCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),

      child: Column(
        children: [
          radioMetode("ewallet", "E-Wallet", "OVO, GoPay, Dana"),
          radioMetode("bank", "Transfer Bank", "BCA, Mandiri, BNI"),
          radioMetode("qris", "QRIS", "Scan QR Code"),
        ],
      ),
    );
  }

  Widget radioMetode(value, title, subtitle) {
    return RadioListTile(
      value: value,
      groupValue: metodePembayaran,
      onChanged: (v) {
        setState(() {
          metodePembayaran = v.toString();
        });
      },
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }

  Widget promoCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),

      child: Padding(
        padding: const EdgeInsets.all(12),

        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: promoController,
                decoration: const InputDecoration(
                  hintText: "Masukkan kode promo",
                ),
              ),
            ),
            ElevatedButton(onPressed: () {}, child: const Text("Terapkan")),
          ],
        ),
      ),
    );
  }

  Widget detailPeserta() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),

      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            TextField(
              controller: namaController,
              decoration: const InputDecoration(labelText: "Nama lengkap"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
          ],
        ),
      ),
    );
  }

  Widget bayarButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.purple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: () {
          prosesBayar();
        },
        child: Text(
          "Bayar Sekarang",
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}
