import 'dart:io';
import 'package:flutter/material.dart';

class ClassCard extends StatelessWidget {
  final String namaKelas;
  final String namaTutor;
  final String jadwal;
  final int harga;
  final String? deskripsi;
  final int? jumlahSiswa;
  final double? rating;
  final VoidCallback? onTap;
  final VoidCallback? onBook;
  final String? kategori;
  final String? foto;

  const ClassCard({
    super.key,
    required this.namaKelas,
    required this.namaTutor,
    required this.jadwal,
    required this.harga,
    this.deskripsi,
    this.jumlahSiswa,
    this.rating,
    this.onTap,
    this.onBook,
    this.kategori,
    this.foto,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header dengan kategori
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6C4FD8), Color(0xFF9966FF)],
                ),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (kategori != null)
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
                        kategori!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  if (rating != null)
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.yellow, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          rating.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),

            // GAMBAR SAMPUL KELAS
            if (foto != null && foto!.isNotEmpty)
              Container(
                width: double.infinity,
                height: 140,
                decoration: const BoxDecoration(color: Colors.grey),
                child: _buildImage(foto!),
              ),

            // Content
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama Kelas
                  Text(
                    namaKelas,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  // Info Row
                  Row(
                    children: [
                      const Icon(Icons.person, size: 16, color: Colors.grey),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          namaTutor,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Jadwal
                  Row(
                    children: [
                      const Icon(Icons.schedule, size: 16, color: Colors.grey),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          jadwal,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  if (deskripsi != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      deskripsi!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],

                  const SizedBox(height: 12),

                  // Footer dengan harga dan tombol
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Harga',
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Rp ${harga.toString()}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6C4FD8),
                            ),
                          ),
                        ],
                      ),
                      if (jumlahSiswa != null)
                        Text(
                          '$jumlahSiswa siswa',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      if (onBook != null)
                        ElevatedButton(
                          onPressed: onBook,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6C4FD8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            'Daftar',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String fotoPath) {
    if (fotoPath.isEmpty) {
      return Container(
        width: double.infinity,
        height: 140,
        color: Colors.grey[300],
        child: const Icon(Icons.image_outlined, color: Colors.grey),
      );
    }

    // Check if it's a network URL
    if (fotoPath.startsWith('http://') || fotoPath.startsWith('https://')) {
      return Image.network(
        fotoPath,
        width: double.infinity,
        height: 140,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: double.infinity,
            height: 140,
            color: Colors.grey[300],
            child: const Icon(Icons.error_outline, color: Colors.grey),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
      );
    }

    try {
      final file = File(fotoPath);
      if (file.existsSync()) {
        return Image.file(
          file,
          width: double.infinity,
          height: 140,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: double.infinity,
              height: 140,
              color: Colors.grey[300],
              child: const Icon(Icons.broken_image_outlined, color: Colors.grey),
            );
          },
        );
      }
    } catch (e) {
      print('Error loading image: $e');
    }

    // Fallback if image not found or invalid path
    return Container(
      width: double.infinity,
      height: 140,
      color: Colors.grey[300],
      child: const Icon(Icons.image_outlined, color: Colors.grey),
    );
  }
}
