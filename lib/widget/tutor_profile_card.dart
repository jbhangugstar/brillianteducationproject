import 'package:brillianteducationproject/helper/image_helper.dart';
import 'package:flutter/material.dart';

class TutorProfileCard extends StatelessWidget {
  final String nama;
  final String mataaPelajaran;
  final String? foto;
  final double? rating;
  final int? jumlahSiswa;
  final String? pendidikan;
  final String? deskripsi;
  final VoidCallback? onTap;
  final VoidCallback? onContact;

  const TutorProfileCard({
    super.key,
    required this.nama,
    required this.mataaPelajaran,
    this.foto,
    this.rating,
    this.jumlahSiswa,
    this.pendidikan,
    this.deskripsi,
    this.onTap,
    this.onContact,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(14),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: ImageHelper.buildImage(
                foto,
                width: 70,
                height: 70,
                errorWidget: Container(
                  width: 70,
                  height: 70,
                  color: Colors.grey[300],
                  child: const Icon(Icons.person, size: 35, color: Colors.grey),
                ),
              ),
            ),

            const SizedBox(width: 14),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama
                  Text(
                    nama,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Mata Pelajaran
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6C4FD8).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      mataaPelajaran,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF6C4FD8),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Rating dan Students
                  Row(
                    children: [
                      if (rating != null) ...[
                        const Icon(Icons.star, size: 14, color: Colors.amber),
                        const SizedBox(width: 3),
                        Text(
                          rating.toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                      if (jumlahSiswa != null) ...[
                        const Icon(Icons.people, size: 14, color: Colors.grey),
                        const SizedBox(width: 3),
                        Text(
                          '$jumlahSiswa siswa',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ],
                  ),

                  if (pendidikan != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      pendidikan!,
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),

            // Contact Button
            if (onContact != null) ...[
              const SizedBox(width: 8),
              Column(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: const Color(0xFF6C4FD8),
                    child: IconButton(
                      icon: const Icon(
                        Icons.call,
                        size: 16,
                        color: Colors.white,
                      ),
                      onPressed: onContact,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
