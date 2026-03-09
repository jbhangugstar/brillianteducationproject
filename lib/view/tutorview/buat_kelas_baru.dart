import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:brillianteducationproject/extension/navigator.dart';
import 'package:brillianteducationproject/view/tutorview/buat_kelas_baru2.dart';
import 'package:brillianteducationproject/view/tutorview/tutor_main_screen.dart';
import 'package:flutter/material.dart';

class BuatKelasBaruScreen extends StatefulWidget {
  const BuatKelasBaruScreen({super.key});

  @override
  State<BuatKelasBaruScreen> createState() => _BuatKelasBaruState();
}

class _BuatKelasBaruState extends State<BuatKelasBaruScreen> {
  late TextEditingController namaKelasController;
  late TextEditingController hargaController;
  late TextEditingController jadwalController;
  late TextEditingController tutorController;
  late TextEditingController deskripsiController;

  String? kategoriController = 'Sains';

  File? coverImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        if (mounted) {
          setState(() {
            coverImage = File(image.path);
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Gambar berhasil dipilih'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 1),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error memilih gambar: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    namaKelasController = TextEditingController();
    hargaController = TextEditingController();
    jadwalController = TextEditingController();
    tutorController = TextEditingController();
    deskripsiController = TextEditingController();
  }

  @override
  void dispose() {
    namaKelasController.dispose();
    hargaController.dispose();
    jadwalController.dispose();
    tutorController.dispose();
    deskripsiController.dispose();
    super.dispose();
  }

  Future<void> pilihJadwal() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );

    if (pickedDate == null) return;

    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime == null) return;

    final String tanggal =
        "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";

    final String jam =
        "${pickedTime.hour}:${pickedTime.minute.toString().padLeft(2, '0')}";

    setState(() {
      jadwalController.text = "$tanggal - $jam";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
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
            /// TAB STEP
            Row(
              children: [
                const Text(
                  "Detail Kelas",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xff3D5AFE),
                  ),
                ),
                const SizedBox(width: 100),
                Text(
                  "Langkah 1 dari 2",
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),

            const SizedBox(height: 4),

            Container(width: 110, height: 3, color: const Color(0xff3D5AFE)),

            const SizedBox(height: 25),

            /// NAMA KELAS
            const Text(
              "Nama Kelas",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: namaKelasController,
              enabled: true,
              autofocus: false,
              cursorColor: Colors.blue,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                hintText: "misal: Kalkulus Tingkat Lanjut & Aljabar Linear",
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// KATEGORI
            const Text(
              "Kategori",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              value: kategoriController,
              items: [
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
              decoration: InputDecoration(
                hintText: "Pilih kategori mata pelajaran",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// JADWAL
            const Text("Jadwal", style: TextStyle(fontWeight: FontWeight.w600)),

            const SizedBox(height: 8),

            TextField(
              controller: jadwalController,
              readOnly: true,
              onTap: pilihJadwal,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.schedule),
                hintText: "Pilih jadwal kelas",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// HARGA
            const Text(
              "Harga per batch",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: hargaController,
              enabled: true,
              autofocus: false,
              keyboardType: TextInputType.number,
              cursorColor: Colors.blue,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.money_sharp),
                suffixText: "Rp",
                hintText: "0.00",
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// Tutor
            const Text("Tutor", style: TextStyle(fontWeight: FontWeight.w600)),

            const SizedBox(height: 8),

            TextField(
              controller: tutorController,
              enabled: true,
              autofocus: false,
              cursorColor: Colors.blue,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.person),
                hintText: "Keisyha Wijaya Salim",
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// DESKRIPSI
            const Text(
              "Deskripsi",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: deskripsiController,
              enabled: true,
              autofocus: false,
              maxLines: 4,
              cursorColor: Colors.blue,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(
                hintText:
                    "Jelaskan apa yang akan dipelajari siswa di kelas ini...",
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
              ),
            ),

            const SizedBox(height: 6),

            Text(
              "Direkomendasikan: Minimal 50 karakter untuk deskripsi yang lebih baik",
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),

            const SizedBox(height: 20),

            /// GAMBAR KELAS
            const Text(
              "Gambar Sampul Kelas",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            GestureDetector(
              onTap: pickImage,
              child: Container(
                width: double.infinity,
                height: 130,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: coverImage == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.camera_alt_outlined,
                            size: 30,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Unggah gambar sampul",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      )
                    : Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              coverImage!,
                              width: double.infinity,
                              height: 130,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  coverImage = null;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Gambar dihapus'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              },
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.8),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: pickImage,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.8),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),

            const SizedBox(height: 30),

            /// BUTTON
            Row(
              children: [
                /// TOMBOL KEMBALI
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      context.push(TutorMainScreen());
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Kembali"),
                  ),
                ),

                const SizedBox(width: 15),

                /// TOMBOL LANJUT
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Validasi input
                      if (namaKelasController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Nama Kelas tidak boleh kosong'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      if (kategoriController == null ||
                          kategoriController!.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Pilih kategori kelas'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      if (jadwalController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Pilih jadwal kelas'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      if (hargaController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Harga tidak boleh kosong'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      if (tutorController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Nama tutor tidak boleh kosong'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      if (deskripsiController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Deskripsi tidak boleh kosong'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      context.push(
                        BuatKelasStep2Screen(
                          namaKelas: namaKelasController.text,
                          kategori: kategoriController ?? "",
                          jadwal: jadwalController.text,
                          harga: hargaController.text,
                          tutor: tutorController.text,
                          deskripsi: deskripsiController.text,
                          gambar: coverImage?.path ?? "",
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff3D5AFE),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Lanjut ke Langkah 2",
                      style: TextStyle(fontSize: 16, color: Colors.white),
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
}
