import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/bible_service.dart';

class BibleQuotesScreen extends StatefulWidget {
  const BibleQuotesScreen({super.key});

  @override
  State<BibleQuotesScreen> createState() => _BibleQuotesScreenState();
}

class _BibleQuotesScreenState extends State<BibleQuotesScreen> {
  final BibleService _bibleService = BibleService();
  String _currentBook = 'Genesis';
  int _currentChapter = 1;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBible();
  }

  Future<void> _loadBible() async {
    await _bibleService.init();
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  void _nextChapter() {
    final next = _bibleService.getNextChapter(_currentBook, _currentChapter);
    if (next != null) {
      final parts = next.split('|');
      setState(() {
        _currentBook = parts[0];
        _currentChapter = int.parse(parts[1]);
      });
    }
  }

  void _prevChapter() {
    final prev = _bibleService.getPreviousChapter(_currentBook, _currentChapter);
    if (prev != null) {
      final parts = prev.split('|');
      setState(() {
        _currentBook = parts[0];
        _currentChapter = int.parse(parts[1]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFF0D0D1A),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded, color: Color(0xFFD4A017)),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Color(0xFFD4A017)),
              SizedBox(height: 20),
              Text(
                "Loading Sacred Scripture...",
                style: TextStyle(color: Colors.white70, fontStyle: FontStyle.italic),
              )
            ],
          ),
        ),
      );
    }

    final verses = _bibleService.getVerses(_currentBook, _currentChapter);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      appBar: AppBar(
        title: Text(
          'Bible Quotes',
          style: GoogleFonts.cinzel(color: const Color(0xFFD4A017), fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Color(0xFFD4A017)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              itemCount: verses.length,
              itemBuilder: (context, index) {
                final verse = verses[index];
                return _buildVerseItem(verse);
              },
            ),
          ),
          _buildNavigation(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1400).withValues(alpha: 0.3),
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFD4A017).withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: Center(
        child: Text(
          "$_currentBook $_currentChapter",
          style: GoogleFonts.cinzel(
            color: const Color(0xFFD4A017),
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildVerseItem(BibleVerse verse) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "${verse.verseNumber} ",
              style: GoogleFonts.cinzel(
                color: const Color(0xFFD4A017),
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: verse.text,
              style: GoogleFonts.cormorantGaramond(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 19,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigation() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 24),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A15),
        border: Border(
          top: BorderSide(
            color: const Color(0xFFD4A017).withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _navButton(
              icon: Icons.chevron_left_rounded,
              label: "PREV",
              onPressed: _prevChapter,
              enabled: _bibleService.getPreviousChapter(_currentBook, _currentChapter) != null,
            ),
            _navButton(
              icon: Icons.chevron_right_rounded,
              label: "NEXT",
              onPressed: _nextChapter,
              enabled: _bibleService.getNextChapter(_currentBook, _currentChapter) != null,
              isRight: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _navButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required bool enabled,
    bool isRight = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onPressed : null,
        borderRadius: BorderRadius.circular(8),
        child: Opacity(
          opacity: enabled ? 1.0 : 0.2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                if (!isRight) Icon(icon, color: const Color(0xFFD4A017), size: 28),
                if (!isRight) const SizedBox(width: 4),
                Text(
                  label,
                  style: GoogleFonts.cinzel(
                    color: const Color(0xFFD4A017),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    letterSpacing: 1.5,
                  ),
                ),
                if (isRight) const SizedBox(width: 4),
                if (isRight) Icon(icon, color: const Color(0xFFD4A017), size: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
