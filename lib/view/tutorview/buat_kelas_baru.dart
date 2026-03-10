import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:brillianteducationproject/extension/navigator.dart';
import 'package:brillianteducationproject/view/tutorview/buat_kelas_baru2.dart';
import 'package:brillianteducationproject/view/tutorview/tutor_main_screen.dart';
import 'package:flutter/material.dart';

class JadwalKelas {
  String hari;
  String jam;

  JadwalKelas({required this.hari, required this.jam});
}

class BuatKelasBaruScreen extends StatefulWidget {
  const BuatKelasBaruScreen({super.key});

  @override
  State<BuatKelasBaruScreen> createState() => _BuatKelasBaruState();
}

class _BuatKelasBaruState extends State<BuatKelasBaruScreen> {
  late TextEditingController namaKelasController;
  late TextEditingController hargaController;
  late TextEditingController tutorController;
  late TextEditingController deskripsiController;

  String? kategoriController = 'Sains';

  File? coverImage;

  final ImagePicker _picker = ImagePicker();

  List<JadwalKelas> jadwalList = [];

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        coverImage = File(image.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    namaKelasController = TextEditingController();
    hargaController = TextEditingController();
    tutorController = TextEditingController();
    deskripsiController = TextEditingController();
  }

  @override
  void dispose() {
    namaKelasController.dispose();
    hargaController.dispose();
    tutorController.dispose();
    deskripsiController.dispose();
    super.dispose();
  }

  Future<void> tambahJadwal() async {
    String? hariDipilih;
    TimeOfDay? pickedTime;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Tambah Jadwal"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                hint: const Text("Pilih Hari"),
                items: const [
                  DropdownMenuItem(value: "Senin", child: Text("Senin")),
                  DropdownMenuItem(value: "Selasa", child: Text("Selasa")),
                  DropdownMenuItem(value: "Rabu", child: Text("Rabu")),
                  DropdownMenuItem(value: "Kamis", child: Text("Kamis")),
                  DropdownMenuItem(value: "Jumat", child: Text("Jumat")),
                  DropdownMenuItem(value: "Sabtu", child: Text("Sabtu")),
                  DropdownMenuItem(value: "Minggu", child: Text("Minggu")),
                ],
                onChanged: (value) {
                  hariDipilih = value;
                },
              ),

              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: () async {
                  pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );

                  if (hariDipilih != null && pickedTime != null) {
                    setState(() {
                      jadwalList.add(
                        JadwalKelas(
                          hari: hariDipilih!,
                          jam: pickedTime!.format(context),
                        ),
                      );
                    });

                    Navigator.pop(context);
                  }
                },
                child: const Text("Pilih Jam"),
              ),
            ],
          ),
        );
      },
    );
  }

  String getJadwalString() {
    return jadwalList.map((e) => "${e.hari} ${e.jam}").join(", ");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),

      appBar: AppBar(title: const Text("Buat Kelas Baru")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text("Nama Kelas"),
            const SizedBox(height: 8),

            TextField(
              controller: namaKelasController,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),

            const SizedBox(height: 20),

            const Text("Kategori"),
            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              value: kategoriController,
              items: const [
                DropdownMenuItem(value: "Sains", child: Text("Sains")),
                DropdownMenuItem(
                  value: "Literature",
                  child: Text("Literature"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  kategoriController = value;
                });
              },
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),

            const SizedBox(height: 20),

            const Text("Jadwal Kelas"),
            const SizedBox(height: 10),

            Column(
              children: [
                ...jadwalList.map((jadwal) {
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.schedule),
                      title: Text(jadwal.hari),
                      subtitle: Text(jadwal.jam),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            jadwalList.remove(jadwal);
                          });
                        },
                      ),
                    ),
                  );
                }).toList(),

                const SizedBox(height: 10),

                ElevatedButton.icon(
                  onPressed: tambahJadwal,
                  icon: const Icon(Icons.add),
                  label: const Text("Tambah Jadwal"),
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Text("Harga"),
            const SizedBox(height: 8),

            TextField(
              controller: hargaController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),

            const SizedBox(height: 20),

            const Text("Tutor"),
            const SizedBox(height: 8),

            TextField(
              controller: tutorController,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),

            const SizedBox(height: 20),

            const Text("Deskripsi"),
            const SizedBox(height: 8),

            TextField(
              controller: deskripsiController,
              maxLines: 4,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),

            const SizedBox(height: 20),

            const Text("Gambar Sampul"),
            const SizedBox(height: 10),

            GestureDetector(
              onTap: pickImage,
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10),
                ),

                child: coverImage == null
                    ? const Center(child: Text("Upload Gambar"))
                    : Image.file(coverImage!, fit: BoxFit.cover),
              ),
            ),

            const SizedBox(height: 30),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      context.push(TutorMainScreen());
                    },
                    child: const Text("Kembali"),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (namaKelasController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Nama kelas kosong")),
                        );
                        return;
                      }

                      if (jadwalList.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Tambahkan jadwal")),
                        );
                        return;
                      }

                      context.push(
                        BuatKelasStep2Screen(
                          namaKelas: namaKelasController.text,
                          kategori: kategoriController ?? "",
                          jadwal: getJadwalString(),
                          harga: hargaController.text,
                          tutor: tutorController.text,
                          deskripsi: deskripsiController.text,
                          gambar: coverImage?.path ?? "",
                        ),
                      );
                    },

                    child: const Text("Lanjut ke Langkah 2"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
