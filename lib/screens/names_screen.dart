// lib/screens/names_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/names_data.dart';

class NamesScreen extends StatefulWidget {
  const NamesScreen({super.key});
  @override
  State<NamesScreen> createState() => _NamesScreenState();
}

class _NamesScreenState extends State<NamesScreen> {
  String _gender = 'All';
  String _religion = 'All';
  String _search = '';
  final _searchController = TextEditingController();

  final genders = ['All', 'Girl', 'Boy'];
  final religions = ['All', 'Christian', 'Muslim', 'Hindu', 'Universal'];

  final religionColors = {
    'Christian': const Color(0xFFD4A017),
    'Muslim': const Color(0xFF4EC9FF),
    'Hindu': const Color(0xFFFF6B35),
    'Universal': const Color(0xFF4CAF50),
    'All': const Color(0xFFD4A017),
  };

  List<BabyName> get filtered {
    return allBabyNames.where((n) {
      final genderOk = _gender == 'All' || n.gender == _gender;
      final religionOk = _religion == 'All' || n.religion == _religion;
      final searchOk = _search.isEmpty || n.name.toLowerCase().contains(_search.toLowerCase()) || n.meaning.toLowerCase().contains(_search.toLowerCase());
      return genderOk && religionOk && searchOk;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      appBar: AppBar(title: const Text('Baby Names')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _search = v),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search names or meanings...',
                hintStyle: const TextStyle(color: Colors.white38),
                prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFFD4A017)),
                filled: true,
                fillColor: const Color(0xFF0F0F20),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: const Color(0xFFD4A017).withOpacity(0.3))),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFD4A017))),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Gender filter
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: genders.map((g) => _chip(g, _gender, const Color(0xFFFF6B9D), () => setState(() => _gender = g))).toList(),
            ),
          ),
          const SizedBox(height: 6),
          // Religion filter
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: religions.map((r) => _chip(r, _religion, religionColors[r]!, () => setState(() => _religion = r))).toList(),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text('${filtered.length} names found', style: GoogleFonts.cormorantGaramond(color: Colors.white38, fontSize: 13, fontStyle: FontStyle.italic)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filtered.length,
              itemBuilder: (context, i) => _buildNameCard(filtered[i]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, String selected, Color color, VoidCallback onTap) {
    final isSelected = label == selected;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Text(label, style: GoogleFonts.cinzel(color: isSelected ? Colors.black : color, fontSize: 11, fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _buildNameCard(BabyName name) {
    final color = religionColors[name.religion] ?? const Color(0xFFD4A017);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color.withOpacity(0.08), const Color(0xFF0F0F20)]),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Text(name.gender == 'Girl' ? '👧' : '👦', style: const TextStyle(fontSize: 30)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(name.name, style: GoogleFonts.cinzel(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                      child: Text(name.religion, style: GoogleFonts.cinzel(color: color, fontSize: 9, letterSpacing: 0.5)),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(name.meaning, style: GoogleFonts.cormorantGaramond(color: Colors.white60, fontSize: 13, fontStyle: FontStyle.italic)),
                Text('${name.origin} • ${name.gender}', style: GoogleFonts.cormorantGaramond(color: Colors.white38, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
