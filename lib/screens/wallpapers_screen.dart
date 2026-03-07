// lib/screens/wallpapers_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/wallpapers_data.dart';
import 'dart:math' as math;

class WallpapersScreen extends StatefulWidget {
  const WallpapersScreen({super.key});
  @override
  State<WallpapersScreen> createState() => _WallpapersScreenState();
}

class _WallpapersScreenState extends State<WallpapersScreen> {
  String _filter = 'All';

  List<Wallpaper> get filtered {
    if (_filter == 'All') return wallpapers;
    return wallpapers.where((w) => w.category == _filter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      appBar: AppBar(title: const Text('Wallpapers')),
      body: Column(
        children: [
          const SizedBox(height: 12),
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: ['All', 'Nature', 'Verse'].map((f) {
                final selected = f == _filter;
                return GestureDetector(
                  onTap: () => setState(() => _filter = f),
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: selected ? const Color(0xFFD4A017) : const Color(0xFFD4A017).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFD4A017).withOpacity(0.4)),
                    ),
                    child: Text(f, style: GoogleFonts.cinzel(color: selected ? Colors.black : const Color(0xFFD4A017), fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 0.75),
              itemCount: filtered.length,
              itemBuilder: (context, index) => _buildWallpaperCard(filtered[index], index),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWallpaperCard(Wallpaper wallpaper, int index) {
    final gradient = _getGradient(wallpaper.gradientType);
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => WallpaperDetailScreen(wallpaper: wallpaper, gradient: gradient))),
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
        ),
        child: Stack(
          children: [
            // Stars decoration
            ...List.generate(6, (i) {
              final rand = math.Random(index * 10 + i);
              return Positioned(
                left: rand.nextDouble() * 150,
                top: rand.nextDouble() * 200,
                child: Icon(Icons.star, color: Colors.white.withOpacity(0.15 + rand.nextDouble() * 0.2), size: 4 + rand.nextDouble() * 6),
              );
            }),
            // Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(wallpaper.emoji, style: const TextStyle(fontSize: 32)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(color: Colors.black.withOpacity(0.3), borderRadius: BorderRadius.circular(8)),
                    child: Text(wallpaper.category, style: GoogleFonts.cinzel(color: Colors.white70, fontSize: 9, letterSpacing: 1)),
                  ),
                  const SizedBox(height: 5),
                  Text(wallpaper.title, style: GoogleFonts.cinzel(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700, shadows: [const Shadow(color: Colors.black, blurRadius: 8)])),
                  const SizedBox(height: 4),
                  Text(wallpaper.reference, style: GoogleFonts.cormorantGaramond(color: Colors.white70, fontSize: 11, fontStyle: FontStyle.italic, shadows: [const Shadow(color: Colors.black, blurRadius: 6)])),
                ],
              ),
            ),
            // Download icon
            Positioned(
              top: 8, right: 8,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.4), shape: BoxShape.circle),
                child: const Icon(Icons.download_rounded, color: Colors.white, size: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  LinearGradient _getGradient(String type) {
    final gradients = {
      'sunrise': const LinearGradient(colors: [Color(0xFF1A0533), Color(0xFF8B2252), Color(0xFFFF6B35)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      'ocean': const LinearGradient(colors: [Color(0xFF0D1B4B), Color(0xFF0A4B8C), Color(0xFF0099CC)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      'forest': const LinearGradient(colors: [Color(0xFF0A1A0A), Color(0xFF1B4332), Color(0xFF2D6A4F)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      'sunset': const LinearGradient(colors: [Color(0xFF1A0000), Color(0xFF8B0000), Color(0xFFD4A017)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      'night': const LinearGradient(colors: [Color(0xFF000033), Color(0xFF000066), Color(0xFF1A0066)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      'green': const LinearGradient(colors: [Color(0xFF0A2A0A), Color(0xFF1B5E20), Color(0xFF388E3C)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      'rainbow': const LinearGradient(colors: [Color(0xFF4A0080), Color(0xFF0066CC), Color(0xFF00994D)], begin: Alignment.topLeft, end: Alignment.bottomRight),
      'rain': const LinearGradient(colors: [Color(0xFF1A1A2E), Color(0xFF2C3E50), Color(0xFF4A6741)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      'desert': const LinearGradient(colors: [Color(0xFF2C1810), Color(0xFF8B4513), Color(0xFFD4A017)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      'sky': const LinearGradient(colors: [Color(0xFF0D1B4B), Color(0xFF1565C0), Color(0xFF42A5F5)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      'autumn': const LinearGradient(colors: [Color(0xFF1A0A00), Color(0xFF8B2500), Color(0xFFD4521A)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      'winter': const LinearGradient(colors: [Color(0xFF0D0D2E), Color(0xFF1A237E), Color(0xFF3949AB)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      'spring': const LinearGradient(colors: [Color(0xFF1A2E1A), Color(0xFF2E7D32), Color(0xFF66BB6A)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      'garden': const LinearGradient(colors: [Color(0xFF0A1A0A), Color(0xFF1B5E20), Color(0xFFD4A017)], begin: Alignment.topLeft, end: Alignment.bottomRight),
      'river': const LinearGradient(colors: [Color(0xFF0D1B4B), Color(0xFF006064), Color(0xFF00838F)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      'love': const LinearGradient(colors: [Color(0xFF1A0010), Color(0xFF8B0057), Color(0xFFD4A017)], begin: Alignment.topLeft, end: Alignment.bottomRight),
      'gold': const LinearGradient(colors: [Color(0xFF1A1400), Color(0xFF5C4A00), Color(0xFFD4A017)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      'purple': const LinearGradient(colors: [Color(0xFF0D0020), Color(0xFF4A0080), Color(0xFF7B1FA2)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      'trust': const LinearGradient(colors: [Color(0xFF0D1B4B), Color(0xFF1565C0), Color(0xFFD4A017)], begin: Alignment.topLeft, end: Alignment.bottomRight),
      'courage': const LinearGradient(colors: [Color(0xFF1A0000), Color(0xFF7B0000), Color(0xFFD4521A)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      'rest': const LinearGradient(colors: [Color(0xFF0D1B3E), Color(0xFF1A2E52), Color(0xFF4A6741)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      'pink': const LinearGradient(colors: [Color(0xFF1A0010), Color(0xFF8B0057), Color(0xFFE91E8C)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      'pastoral': const LinearGradient(colors: [Color(0xFF0D1B0D), Color(0xFF1B5E20), Color(0xFF4CAF50)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      'shield': const LinearGradient(colors: [Color(0xFF0D0D2E), Color(0xFF283593), Color(0xFFD4A017)], begin: Alignment.topLeft, end: Alignment.bottomRight),
      'kingdom': const LinearGradient(colors: [Color(0xFF1A1400), Color(0xFF4A3800), Color(0xFFD4A017)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      'morning': const LinearGradient(colors: [Color(0xFF0D0D2E), Color(0xFF8B2252), Color(0xFFFF9800)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      'joy': const LinearGradient(colors: [Color(0xFF1A0A00), Color(0xFF6A1B9A), Color(0xFFD4A017)], begin: Alignment.topLeft, end: Alignment.bottomRight),
      'eternal': const LinearGradient(colors: [Color(0xFF0D0D2E), Color(0xFF1A237E), Color(0xFF4A0080)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      'light': const LinearGradient(colors: [Color(0xFF1A1400), Color(0xFFD4A017), Color(0xFFFFF8E1)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      'victory': const LinearGradient(colors: [Color(0xFF0D1B4B), Color(0xFF1B4332), Color(0xFFD4A017)], begin: Alignment.topLeft, end: Alignment.bottomRight),
      'armor': const LinearGradient(colors: [Color(0xFF1A0A00), Color(0xFF37474F), Color(0xFFD4A017)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
    };
    return gradients[type] ?? gradients['gold']!;
  }
}

class WallpaperDetailScreen extends StatelessWidget {
  final Wallpaper wallpaper;
  final LinearGradient gradient;
  const WallpaperDetailScreen({super.key, required this.wallpaper, required this.gradient});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      body: Stack(
        children: [
          // Full screen wallpaper preview
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(gradient: gradient),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(wallpaper.emoji, style: const TextStyle(fontSize: 80)),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    '"${wallpaper.verse}"',
                    style: GoogleFonts.cormorantGaramond(color: Colors.white, fontSize: 22, fontStyle: FontStyle.italic, height: 1.7, shadows: [const Shadow(color: Colors.black, blurRadius: 15)]),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                Text('— ${wallpaper.reference}', style: GoogleFonts.cinzel(color: const Color(0xFFD4A017), fontSize: 14, fontWeight: FontWeight.w600, shadows: [const Shadow(color: Colors.black, blurRadius: 10)])),
              ],
            ),
          ),
          // Back + Save buttons
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), shape: BoxShape.circle),
                      child: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 20),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('📱 Screenshot to save this wallpaper!', style: GoogleFonts.cinzel(color: Colors.black)),
                          backgroundColor: const Color(0xFFD4A017),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), shape: BoxShape.circle),
                      child: const Icon(Icons.download_rounded, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
