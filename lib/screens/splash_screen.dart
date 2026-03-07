// lib/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoCtrl, _textCtrl, _glowCtrl;
  late Animation<double> _scale, _opacity, _textOpacity;

  @override
  void initState() {
    super.initState();
    _logoCtrl = AnimationController(
        duration: const Duration(milliseconds: 1400), vsync: this);
    _textCtrl = AnimationController(
        duration: const Duration(milliseconds: 900), vsync: this);
    _glowCtrl =
        AnimationController(duration: const Duration(seconds: 2), vsync: this)
          ..repeat(reverse: true);

    _scale = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _logoCtrl, curve: Curves.elasticOut));
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _logoCtrl, curve: const Interval(0.0, 0.5)));
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _textCtrl, curve: Curves.easeIn));

    _start();
  }

  void _start() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _logoCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 800));
    _textCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 2500));
    if (mounted) {
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const HomeScreen(),
            transitionsBuilder: (_, anim, __, child) =>
                FadeTransition(opacity: anim, child: child),
            transitionDuration: const Duration(milliseconds: 700),
          ));
    }
  }

  @override
  void dispose() {
    _logoCtrl.dispose();
    _textCtrl.dispose();
    _glowCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      body: Container(
        decoration: const BoxDecoration(
            gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.2,
                colors: [Color(0xFF1A1400), Color(0xFF0D0D1A)])),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _glowCtrl,
                builder: (_, child) => Container(
                  decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                    BoxShadow(
                        color: const Color(0xFFD4A017)
                            .withOpacity(0.3 + 0.3 * _glowCtrl.value),
                        blurRadius: 60 + 30 * _glowCtrl.value,
                        spreadRadius: 10)
                  ]),
                  child: child,
                ),
                child: FadeTransition(
                  opacity: _opacity,
                  child: ScaleTransition(
                    scale: _scale,
                    child: ClipOval(
                        child: Image.asset('assets/images/logo.jpg',
                            width: 150, height: 150, fit: BoxFit.cover)),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              FadeTransition(
                opacity: _textOpacity,
                child: Column(children: [
                  Text('GLOBAL DAILY',
                      style: GoogleFonts.cinzel(
                          color: const Color(0xFFD4A017),
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 6)),
                  Text('DEVOTIONAL',
                      style: GoogleFonts.cinzel(
                          color: const Color(0xFFD4A017),
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 6)),
                  const SizedBox(height: 10),
                  Text('Faith • Family • Love',
                      style: GoogleFonts.cormorantGaramond(
                          color: Colors.white,
                          fontSize: 16,
                          letterSpacing: 3,
                          fontStyle: FontStyle.italic)),
                ]),
              ),
              const SizedBox(height: 60),
              FadeTransition(
                  opacity: _textOpacity,
                  child: const SizedBox(
                      width: 36,
                      height: 36,
                      child: CircularProgressIndicator(
                          color: Color(0xFFD4A017), strokeWidth: 2))),
            ],
          ),
        ),
      ),
    );
  }
}
