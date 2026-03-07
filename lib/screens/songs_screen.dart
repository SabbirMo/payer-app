// lib/screens/songs_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/songs_data.dart';

class SongsScreen extends StatefulWidget {
  const SongsScreen({super.key});
  @override
  State<SongsScreen> createState() => _SongsScreenState();
}

class _SongsScreenState extends State<SongsScreen> with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() { _tab.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      appBar: AppBar(
        title: const Text('Hymns & Worship'),
        bottom: TabBar(
          controller: _tab,
          indicatorColor: const Color(0xFFD4A017),
          labelColor: const Color(0xFFD4A017),
          unselectedLabelColor: Colors.white38,
          labelStyle: GoogleFonts.cinzel(fontSize: 10, letterSpacing: 0.5),
          isScrollable: true,
          tabs: const [
            Tab(text: 'CLASSIC HYMNS'),
            Tab(text: 'WORSHIP'),
            Tab(text: 'GOSPEL'),
            Tab(text: 'HEALING'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _buildSongList(classicHymns, const Color(0xFFD4A017)),
          _buildSongList(modernWorship, const Color(0xFF6B4EFF)),
          _buildSongList(gospelSongs, const Color(0xFFFF6B35)),
          _buildSongList(therapyPrayers, const Color(0xFF4CAF50)),
        ],
      ),
    );
  }

  Widget _buildSongList(List<Song> songs, Color color) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: songs.length,
      itemBuilder: (context, index) {
        final song = songs[index];
        return GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(
            builder: (_) => SongDetailScreen(song: song, color: color),
          )),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [color.withOpacity(0.1), const Color(0xFF0F0F20)]),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(color: color.withOpacity(0.15), shape: BoxShape.circle),
                  child: Center(child: Text(song.emoji, style: const TextStyle(fontSize: 22))),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(song.title, style: GoogleFonts.cinzel(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 3),
                      Text(song.artist, style: GoogleFonts.cormorantGaramond(color: color, fontSize: 13, fontStyle: FontStyle.italic)),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: color),
              ],
            ),
          ),
        );
      },
    );
  }
}

class SongDetailScreen extends StatelessWidget {
  final Song song;
  final Color color;
  const SongDetailScreen({super.key, required this.song, required this.color});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      appBar: AppBar(
        title: Text(song.category),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded), onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: 90, height: 90,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 30)],
              ),
              child: Center(child: Text(song.emoji, style: const TextStyle(fontSize: 44))),
            ),
            const SizedBox(height: 16),
            Text(song.title, style: GoogleFonts.cinzel(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700), textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text(song.artist, style: GoogleFonts.cormorantGaramond(color: color, fontSize: 15, fontStyle: FontStyle.italic)),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [color.withOpacity(0.08), const Color(0xFF0F0F20)]),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: color.withOpacity(0.25)),
              ),
              child: Text(
                song.lyrics,
                style: GoogleFonts.cormorantGaramond(color: Colors.white, fontSize: 17, height: 2.0, fontStyle: FontStyle.italic),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Text('🙏', style: TextStyle(fontSize: 18)),
                  label: Text('Amen', style: GoogleFonts.cinzel(fontWeight: FontWeight.w700, fontSize: 15)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
