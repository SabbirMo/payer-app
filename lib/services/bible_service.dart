import 'dart:convert';
import 'package:flutter/services.dart';

class BibleVerse {
  final String book;
  final int chapter;
  final int verseNumber;
  final String text;

  BibleVerse({
    required this.book,
    required this.chapter,
    required this.verseNumber,
    required this.text,
  });
}

class BibleService {
  static final BibleService _instance = BibleService._internal();
  factory BibleService() => _instance;
  BibleService._internal();

  final Map<String, Map<int, List<BibleVerse>>> _groupedVerses = {};
  final List<String> _books = [];

  Future<void> init() async {
    if (_groupedVerses.isNotEmpty) return;

    final String response = await rootBundle.loadString('assets/json/bible.json');
    final data = json.decode(response) as Map<String, dynamic>;

    data.forEach((key, value) {
      try {
        // Key format: "Book Chapter:Verse" (e.g., "Genesis 1:1" or "1 John 1:1")
        final lastSpaceIndex = key.lastIndexOf(' ');
        if (lastSpaceIndex == -1) return;

        final book = key.substring(0, lastSpaceIndex);
        final ref = key.substring(lastSpaceIndex + 1);
        final parts = ref.split(':');
        if (parts.length < 2) return;

        final chapter = int.parse(parts[0]);
        final verseNumber = int.parse(parts[1]);

        if (!_groupedVerses.containsKey(book)) {
          _groupedVerses[book] = {};
          _books.add(book);
        }
        if (!_groupedVerses[book]!.containsKey(chapter)) {
          _groupedVerses[book]![chapter] = [];
        }
        _groupedVerses[book]![chapter]!.add(BibleVerse(
          book: book,
          chapter: chapter,
          verseNumber: verseNumber,
          text: value.toString(),
        ));
      } catch (e) {
        // Skip malformed entries
      }
    });

    // Sort chapters for each book
    _groupedVerses.forEach((book, chapters) {
      // Sorting is done when keys are requested or during display
    });
  }

  List<String> getBooks() => _books;
  
  List<int> getChapters(String book) {
    if (!_groupedVerses.containsKey(book)) return [];
    var chapters = _groupedVerses[book]!.keys.toList();
    chapters.sort();
    return chapters;
  }

  List<BibleVerse> getVerses(String book, int chapter) {
    var verses = _groupedVerses[book]?[chapter] ?? [];
    verses.sort((a, b) => a.verseNumber.compareTo(b.verseNumber));
    return verses;
  }

  String? getNextChapter(String currentBook, int currentChapter) {
    final chapters = getChapters(currentBook);
    final index = chapters.indexOf(currentChapter);
    
    if (index != -1 && index < chapters.length - 1) {
      return "$currentBook|${chapters[index + 1]}";
    }
    
    // Jump to next book
    final bookIndex = _books.indexOf(currentBook);
    if (bookIndex != -1 && bookIndex < _books.length - 1) {
      final nextBook = _books[bookIndex + 1];
      final nextChapters = getChapters(nextBook);
      if (nextChapters.isNotEmpty) {
        return "$nextBook|${nextChapters[0]}";
      }
    }
    
    return null;
  }

  String? getPreviousChapter(String currentBook, int currentChapter) {
    final chapters = getChapters(currentBook);
    final index = chapters.indexOf(currentChapter);
    
    if (index != -1 && index > 0) {
      return "$currentBook|${chapters[index - 1]}";
    }
    
    // Jump to previous book
    final bookIndex = _books.indexOf(currentBook);
    if (bookIndex != -1 && bookIndex > 0) {
      final prevBook = _books[bookIndex - 1];
      final prevChapters = getChapters(prevBook);
      if (prevChapters.isNotEmpty) {
        return "$prevBook|${prevChapters.last}";
      }
    }
    
    return null;
  }
}
