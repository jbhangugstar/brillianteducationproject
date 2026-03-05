import 'package:flutter/material.dart';

class SearchSiswaScreen extends StatefulWidget {
  const SearchSiswaScreen({super.key});

  @override
  State<SearchSiswaScreen> createState() => _SearchSiswaScreenState();
}

class _SearchSiswaScreenState extends State<SearchSiswaScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> searchResults = [];

  void _performSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        searchResults = [];
      } else {
        searchResults =
            [
                  'Matematika - Bu keishya Wijaya',
                  'Bahasa Inggris - Pak Ahmad Rizki',
                  'Bahasa Korea - Bu Maria Olivia',
                  'IPA - Prof. Budi',
                  'IPS - Ibu Ratna',
                ]
                .where(
                  (item) => item.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cari Tutor'),
        centerTitle: true,
        backgroundColor: const Color(0xFFB23AEE),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari tutor atau mata pelajaran...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: _performSearch,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: searchResults.isEmpty
                  ? Center(
                      child: Text(
                        _searchController.text.isEmpty
                            ? 'Mulai mencari tutor atau pelajaran'
                            : 'Tidak ada hasil ditemukan',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const Icon(Icons.person_outline),
                          title: Text(searchResults[index]),
                          trailing: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFB23AEE),
                            ),
                            onPressed: () {},
                            child: const Text('Lihat'),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
