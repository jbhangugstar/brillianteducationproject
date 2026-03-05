import 'package:flutter/material.dart';
import 'package:brillianteducationproject/controller/kelas_controller.dart';

class KelasSiswaScreen extends StatefulWidget {
  const KelasSiswaScreen({super.key});

  @override
  State<KelasSiswaScreen> createState() => _KelasSiswaScreenState();
}

class _KelasSiswaScreenState extends State<KelasSiswaScreen> {
  late Future<List<Map<String, dynamic>>> kelasFuture;

  @override
  void initState() {
    super.initState();
    kelasFuture = KelasController.getAllKelas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kelas Saya"), centerTitle: true),

      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: kelasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "Belum ada kelas tersedia",
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final kelasList = snapshot.data!;

          return ListView.builder(
            itemCount: kelasList.length,
            itemBuilder: (context, index) {
              final kelas = kelasList[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Nama kelas
                      Text(
                        kelas['nama_kelas'] ?? '',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      /// Tutor
                      Row(
                        children: [
                          const Icon(Icons.person, size: 18),
                          const SizedBox(width: 6),
                          Text("Tutor : ${kelas['tutor']}"),
                        ],
                      ),

                      const SizedBox(height: 6),

                      /// Jadwal
                      Row(
                        children: [
                          const Icon(Icons.schedule, size: 18),
                          const SizedBox(width: 6),
                          Text("Jadwal : ${kelas['jadwal']}"),
                        ],
                      ),

                      const SizedBox(height: 6),

                      /// Harga
                      Row(
                        children: [
                          const Icon(Icons.payments, size: 18),
                          const SizedBox(width: 6),
                          Text("Harga : Rp ${kelas['harga']}"),
                        ],
                      ),

                      const SizedBox(height: 10),

                      /// Deskripsi
                      Text(
                        kelas['deskripsi'] ?? '',
                        style: const TextStyle(color: Colors.grey),
                      ),

                      const SizedBox(height: 10),

                      /// Button Book
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Berhasil booking ${kelas['nama_kelas']}",
                                ),
                              ),
                            );
                          },
                          child: const Text("Book"),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
