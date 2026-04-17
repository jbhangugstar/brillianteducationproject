import 'package:brillianteducationproject/controller/kelas_controller.dart';
import 'package:brillianteducationproject/models/kelas_model.dart';
import 'package:brillianteducationproject/helper/image_helper.dart';
import 'package:brillianteducationproject/helper/currency_helper.dart';
import 'package:flutter/material.dart';

class KelasTutorScreen extends StatefulWidget {
  const KelasTutorScreen({super.key});

  @override
  State<KelasTutorScreen> createState() => _KelasTutorScreenState();
}

class _KelasTutorScreenState extends State<KelasTutorScreen> {
  late Future<List<Kelas>> kelasFuture;

  @override
  void initState() {
    super.initState();
    kelasFuture = KelasController.getAllKelas();
  }

  void _refreshKelas() {
    setState(() {
      kelasFuture = KelasController.getAllKelas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFB23AEE),
        elevation: 0,
        title: const Text(
          "Brilliant Education",
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
      body: FutureBuilder<List<Kelas>>(
        future: kelasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF6C4FD8)),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Belum ada jadwal kelas"));
          }

          final kelasList = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: kelasList.length,
            itemBuilder: (context, index) {
              final kelas = kelasList[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: kelasCard(kelas),
              );
            },
          );
        },
      ),
    );
  }

  Widget kelasCard(Kelas kelas) {
    final title = kelas.namaKelas;
    final tutor = kelas.tutor;
    final price = CurrencyHelper.formatRupiah(kelas.harga);
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
            color: Colors.black.withValues(alpha: 0.08),
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
                      fontSize: 14,
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.2),
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
          ClipRRect(
            borderRadius: BorderRadius.circular(0), // Keeping it consistent
            child: ImageHelper.buildImage(
              kelas.foto,
              width: double.infinity,
              height: 180,
              fit: BoxFit.cover,
            ),
          ),

          /// DETAIL
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// NAMA TUTOR
                Row(
                  children: [
                    const Icon(Icons.person, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      tutor,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                Text(
                  price,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 6),

                Text("Jadwal: $schedule"),

                const SizedBox(height: 6),

                Text(students),

                const SizedBox(height: 6),

                if (kategori != null)
                  Text(
                    "Kategori: $kategori",
                    style: const TextStyle(color: Colors.grey),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
