import 'package:brillianteducationproject/view/siswaview/pembayaran_sukses.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:brillianteducationproject/models/kelas_model.dart';
import 'package:brillianteducationproject/models/enrollment_model.dart';
import 'package:brillianteducationproject/controller/enrollment_controller.dart';

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
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          namaController.text = data['nama'] ?? '';
          emailController.text = data['email'] ?? '';
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } else {
      setState(() => isLoading = false);
    }
  }

  Future<void> prosesBayar() async {
    // VALIDASI INPUT
    if (namaController.text.isEmpty || emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama dan email wajib diisi")),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Silakan login terlebih dahulu")),
      );
      return;
    }

    final enrollment = EnrollmentModel(
      idSiswa: user.uid,
      idKelas: widget.kelas.id!,
      namaSiswa: namaController.text,
      emailSiswa: emailController.text,
      namaKelas: widget.kelas.namaKelas,
      tanggalDaftar: DateTime.now().toIso8601String(),
      status: "aktif",
    );

    setState(() => isLoading = true);
    try {
      await EnrollmentController.enrollStudent(enrollment);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PembayaranSuksesPage(
            totalPembayaran: widget.kelas.harga,
            metodePembayaran: metodePembayaran == "ewallet"
                ? "E-Wallet"
                : metodePembayaran == "bank"
                ? "Transfer Bank"
                : "QRIS",
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal mendaftar: $e")));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.purple.shade50,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.book, color: Colors.purple),
        ),
        title: Text(
          widget.kelas.namaKelas,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text("Tutor: ${widget.kelas.tutor}"),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.star, color: Colors.orange, size: 20),
            Text("${widget.kelas.rating ?? 0}"),
          ],
        ),
      ),
    );
  }

  Widget ringkasanPembayaran() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Ringkasan Pembayaran",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 15),
            rowHarga("Harga Kelas", widget.kelas.harga),
            rowHarga("Biaya Layanan", 0),
            const Divider(height: 30),
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
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(
            "Rp $harga",
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget rowTotal() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Total Pembayaran",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(
          "Rp ${widget.kelas.harga}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.purple,
          ),
        ),
      ],
    );
  }

  Widget metodePembayaranCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Column(
        children: [
          radioMetode("ewallet", "E-Wallet", "OVO, GoPay, Dana"),
          const Divider(height: 0),
          radioMetode("bank", "Transfer Bank", "BCA, Mandiri, BNI"),
          const Divider(height: 0),
          radioMetode("qris", "QRIS", "Scan QR Code"),
        ],
      ),
    );
  }

  Widget radioMetode(value, title, subtitle) {
    return RadioListTile(
      value: value,
      groupValue: metodePembayaran,
      activeColor: Colors.purple,
      onChanged: (v) {
        setState(() {
          metodePembayaran = v.toString();
        });
      },
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
    );
  }

  Widget promoCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            const Icon(Icons.local_offer_outlined, color: Colors.purple),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: promoController,
                decoration: const InputDecoration(
                  hintText: "Masukkan kode promo",
                  border: InputBorder.none,
                ),
              ),
            ),
            TextButton(onPressed: () {}, child: const Text("Terapkan")),
          ],
        ),
      ),
    );
  }

  Widget detailPeserta() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Detail Peserta",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: namaController,
              decoration: const InputDecoration(
                labelText: "Nama lengkap",
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                prefixIcon: Icon(Icons.email_outlined),
              ),
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
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: isLoading ? null : prosesBayar,
        child: Text(
          isLoading ? "Memproses..." : "Bayar Sekarang",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
