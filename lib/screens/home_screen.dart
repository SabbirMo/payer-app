// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'bible_screen.dart';
import 'prayer_screen.dart';
import 'baby_screen.dart';
import 'songs_screen.dart';
import 'wallpapers_screen.dart';
import 'names_screen.dart';
import 'donation_screen.dart';
import 'dart:math' as math;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _floatController;

  final List<Widget> _screens = [
    const _HomeTab(),
    const BibleScreen(),
    const PrayerScreen(),
    const SongsScreen(),
    const BabyScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _floatController =
        AnimationController(duration: const Duration(seconds: 3), vsync: this)
          ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0A0A15),
          border: Border(
              top: BorderSide(
                  color: const Color(0xFFD4A017).withOpacity(0.25), width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFFD4A017),
          unselectedItemColor: Colors.white24,
          selectedLabelStyle:
              GoogleFonts.cinzel(fontSize: 9, fontWeight: FontWeight.w600),
          unselectedLabelStyle: GoogleFonts.cinzel(fontSize: 9),
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.menu_book_rounded), label: 'Bible'),
            BottomNavigationBarItem(
                icon: Icon(Icons.self_improvement_rounded), label: 'Prayer'),
            BottomNavigationBarItem(
                icon: Icon(Icons.music_note_rounded), label: 'Hymns'),
            BottomNavigationBarItem(
                icon: Icon(Icons.child_care_rounded), label: 'Baby'),
          ],
        ),
      ),
    );
  }
}

class _HomeTab extends StatefulWidget {
  const _HomeTab();
  @override
  State<_HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<_HomeTab> with TickerProviderStateMixin {
  late AnimationController _floatCtrl;
  late AnimationController _glowCtrl;

  @override
  void initState() {
    super.initState();
    _floatCtrl =
        AnimationController(duration: const Duration(seconds: 3), vsync: this)
          ..repeat(reverse: true);
    _glowCtrl =
        AnimationController(duration: const Duration(seconds: 2), vsync: this)
          ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatCtrl.dispose();
    _glowCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: const Color(0xFF0D0D1A),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                      center: Alignment.topCenter,
                      radius: 1.5,
                      colors: [Color(0xFF2A1F00), Color(0xFF0D0D1A)]),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _floatCtrl,
                        builder: (_, child) => Transform.translate(
                          offset: Offset(
                              0, -8 * math.sin(_floatCtrl.value * math.pi)),
                          child: child,
                        ),
                        child: AnimatedBuilder(
                          animation: _glowCtrl,
                          builder: (_, child) => Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      color: const Color(0xFFD4A017)
                                          .withOpacity(
                                              0.4 + 0.3 * _glowCtrl.value),
                                      blurRadius: 30 + 20 * _glowCtrl.value,
                                      spreadRadius: 5)
                                ]),
                            child: child,
                          ),
                          child: ClipOval(
                              child: Image.asset('assets/images/logo.jpg',
                                  width: 90, height: 90, fit: BoxFit.cover)),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text('GLOBAL DAILY DEVOTIONAL',
                          style: GoogleFonts.cinzel(
                              color: const Color(0xFFD4A017),
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2)),
                      const SizedBox(height: 4),
                      Text(_greeting(),
                          style: GoogleFonts.cormorantGaramond(
                              color: Colors.white,
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              letterSpacing: 1)),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _verseCard(),
                const SizedBox(height: 18),
                _sectionLabel('EXPLORE'),
                const SizedBox(height: 10),
                _mainGrid(context),
                const SizedBox(height: 18),
                _sectionLabel('SUPPORT THE MINISTRY'),
                const SizedBox(height: 10),
                _donationBanner(context),
                const SizedBox(height: 18),
                _challengeCard(),
                const SizedBox(height: 80),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good Morning, Beloved ✨';
    if (h < 17) return 'Good Afternoon, Child of God ✨';
    return 'Good Evening, Blessed One ✨';
  }

  Widget _sectionLabel(String text) => Text(text,
      style: GoogleFonts.cinzel(
          color: const Color(0xFFD4A017),
          fontSize: 11,
          letterSpacing: 3,
          fontWeight: FontWeight.w600));

  Widget _verseCard() => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xFF1A1400), Color(0xFF0F0F20)]),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFD4A017).withOpacity(0.35)),
          boxShadow: [
            BoxShadow(
                color: const Color(0xFFD4A017).withOpacity(0.08),
                blurRadius: 20)
          ],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Icon(Icons.auto_awesome, color: Color(0xFFD4A017), size: 14),
            const SizedBox(width: 6),
            Text('VERSE OF THE DAY',
                style: GoogleFonts.cinzel(
                    color: const Color(0xFFD4A017),
                    fontSize: 10,
                    letterSpacing: 2))
          ]),
          const SizedBox(height: 12),
          Text(
              '"For I know the plans I have for you, declares the Lord, plans to prosper you and not to harm you, plans to give you hope and a future."',
              style: GoogleFonts.cormorantGaramond(
                  color: Colors.white,
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  height: 1.7)),
          const SizedBox(height: 8),
          Text('— Jeremiah 29:11',
              style: GoogleFonts.cinzel(
                  color: const Color(0xFFD4A017),
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
        ]),
      );

  Widget _mainGrid(BuildContext context) {
    final items = [
      {
        'icon': Icons.menu_book_rounded,
        'label': 'Bible Stories',
        'color': const Color(0xFF6B4EFF),
        'screen': const BibleScreen()
      },
      {
        'icon': Icons.self_improvement_rounded,
        'label': 'Prayer',
        'color': const Color(0xFFD4A017),
        'screen': const PrayerScreen()
      },
      {
        'icon': Icons.music_note_rounded,
        'label': 'Hymns & Songs',
        'color': const Color(0xFFFF6B35),
        'screen': const SongsScreen()
      },
      {
        'icon': Icons.child_care_rounded,
        'label': 'Baby Corner',
        'color': const Color(0xFFFF6B9D),
        'screen': const BabyScreen()
      },
      {
        'icon': Icons.abc_rounded,
        'label': 'Baby Names',
        'color': const Color(0xFF4EC9FF),
        'screen': const NamesScreen()
      },
      {
        'icon': Icons.wallpaper_rounded,
        'label': 'Wallpapers',
        'color': const Color(0xFF4CAF50),
        'screen': const WallpapersScreen()
      },
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.0),
      itemCount: items.length,
      itemBuilder: (context, i) {
        final item = items[i];
        return GestureDetector(
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => item['screen'] as Widget)),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                (item['color'] as Color).withOpacity(0.15),
                const Color(0xFF0F0F20)
              ]),
              borderRadius: BorderRadius.circular(14),
              border:
                  Border.all(color: (item['color'] as Color).withOpacity(0.35)),
            ),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(item['icon'] as IconData,
                  color: item['color'] as Color, size: 30),
              const SizedBox(height: 8),
              Text(item['label'] as String,
                  style: GoogleFonts.cinzel(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center),
            ]),
          ),
        );
      },
    );
  }

  Widget _donationBanner(BuildContext context) => GestureDetector(
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const DonationScreen())),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [Color(0xFF1A1400), Color(0xFF0A0A15)]),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFD4A017).withOpacity(0.5)),
          ),
          child: Row(children: [
            const Text('💝', style: TextStyle(fontSize: 40)),
            const SizedBox(width: 16),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text('Support This Ministry',
                      style: GoogleFonts.cinzel(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text('PayPal • Stripe • PayNow\nHelp us reach the world 🌍',
                      style: GoogleFonts.cormorantGaramond(
                          color: Colors.white54,
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                          height: 1.5)),
                ])),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                  color: const Color(0xFFD4A017),
                  borderRadius: BorderRadius.circular(12)),
              child: Text('Give',
                  style: GoogleFonts.cinzel(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 13)),
            ),
          ]),
        ),
      );

  Widget _challengeCard() => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            const Color(0xFF2D7D32).withOpacity(0.2),
            const Color(0xFF0D0D1A)
          ]),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFF2D7D32).withOpacity(0.4)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Text('🌱', style: TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Text('TODAY\'S CHALLENGE',
                style: GoogleFonts.cinzel(
                    color: const Color(0xFF4CAF50),
                    fontSize: 11,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w600))
          ]),
          const SizedBox(height: 10),
          Text(
              'Show kindness to someone unexpected today. A smile, a kind word, or a helping hand — let God\'s love flow through you.',
              style: GoogleFonts.cormorantGaramond(
                  color: Colors.white70, fontSize: 15, height: 1.6)),
          const SizedBox(height: 12),
          Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2D7D32).withOpacity(0.4),
                      foregroundColor: const Color(0xFF4CAF50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      elevation: 0),
                  child: Text('✓ I Did It!',
                      style: GoogleFonts.cinzel(
                          fontSize: 12, fontWeight: FontWeight.w700)))),
        ]),
      );
}
