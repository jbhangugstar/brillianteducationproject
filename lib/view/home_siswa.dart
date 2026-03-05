import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeSiswaScreen extends StatelessWidget {
  const HomeSiswaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Brilliant Education",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFB23AEE),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 199, 196, 201),
              Color.fromARGB(255, 222, 216, 224),
              Color.fromARGB(255, 224, 175, 222),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// SEARCH
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        icon: Icon(Icons.search),
                        hintText: "Cari mata pelajaran",
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// BANNER
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        colors: [Color(0xffB23AEF), Color(0xff7B2FF7)],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.videocam_outlined,
                          color: Colors.white,
                          size: 30,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Belajar dengan Live Tutor",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "Sesi 1-on-1 dengan tutor berpengalaman",
                          style: TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 15),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.purple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () {},
                          child: const Text("Mulai Sekarang"),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  /// KATEGORI
                  const Text(
                    "Kategori Pelajaran",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 15),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      CategoryItem(
                        icon: Icons.menu_book,
                        label: "Matematika",
                        color: Color(0xffEAD9FF),
                      ),
                      CategoryItem(
                        icon: Icons.language,
                        label: "Bahasa Inggris",
                        color: Color(0xffD9E7FF),
                      ),
                      CategoryItem(
                        icon: Icons.science,
                        label: "IPA",
                        color: Color(0xffD9FFE4),
                      ),
                      CategoryItem(
                        icon: Icons.location_on,
                        label: "IPS",
                        color: Color(0xffFFE8CC),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  /// TUTOR POPULER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Tutor Populer",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Lihat Semua",
                        style: TextStyle(
                          color: Colors.purple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  TutorCard(
                    name: "Bu Keishya Wijaya",
                    subject: "Matematika",
                    rating: "4.9",
                    reviews: "127",
                    foto:
                        "https://avatars.preply.com/i/logos/i/logos/avatar_facvevr7sw.jpg",
                  ),

                  const SizedBox(height: 12),

                  TutorCard(
                    name: "Pak Ahmad Rizki",
                    subject: "Bahasa Inggris",
                    rating: "4.8",
                    reviews: "95",
                    foto:
                        "https://www.quipper.com/id/blog/wp-content/uploads/2022/12/pexels-yan-krukov-8617763.jpg",
                  ),

                  const SizedBox(height: 12),

                  TutorCard(
                    name: "Bu Maria Olivia",
                    subject: "Bahasa Korea",
                    rating: "4.8",
                    reviews: "95",
                    foto:
                        "https://akcdn.detik.net.id/visual/2025/12/19/ilustrasi-awet-muda-1766148279919_11.jpeg?w=720&q=90",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const CategoryItem({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: Colors.purple),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

class TutorCard extends StatelessWidget {
  final String name;
  final String subject;
  final String rating;
  final String reviews;
  final String foto;

  const TutorCard({
    super.key,
    required this.name,
    required this.subject,
    required this.rating,
    required this.reviews,
    required this.foto,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.grey.withValues(alpha: 0.2), blurRadius: 8),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 28, backgroundImage: NetworkImage(foto)),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(subject),

                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.orange, size: 16),
                    const SizedBox(width: 4),
                    Text("$rating ($reviews)"),
                  ],
                ),
              ],
            ),
          ),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB23AEE),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {},
            child: const Text(
              "Book",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: CupertinoColors.extraLightBackgroundGray,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
