import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class AnimatedSplashScreen extends StatefulWidget {
  const AnimatedSplashScreen({super.key});

  @override
  State<AnimatedSplashScreen> createState() => _AnimatedSplashScreenState();
}

class _AnimatedSplashScreenState extends State<AnimatedSplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _ghostController;
  late Animation<Offset> _ghostOffset;

  late AnimationController _textController;
  late Animation<double> _textBounce;

  @override
  void initState() {
    super.initState();

    // Ghost animation (right -> center -> left)
    _ghostController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _ghostOffset = TweenSequence([
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: const Offset(1.5, 0),
          end: const Offset(0, 0),
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: const Offset(0, 0),
          end: const Offset(-2.0, 0),
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(_ghostController);

    _ghostController.forward();

    // Floating text animation
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _textBounce = Tween<double>(
      begin: 0.0,
      end: 10.0,
    ).chain(CurveTween(curve: Curves.easeInOut)).animate(_textController);

    // Navigate to home after 6 seconds
    Future.delayed(const Duration(seconds: 6), () {
      context.go('/home');
    });
  }

  @override
  void dispose() {
    _ghostController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SlideTransition(
              position: _ghostOffset,
              child: Image.asset(
                "assets/splash/splash.png", // Your cute ghost here
                height: 140,
              ),
            ),
            const SizedBox(height: 24),
            AnimatedBuilder(
              animation: _textBounce,
              builder: (_, child) => Transform.translate(
                offset: Offset(0, -_textBounce.value),
                child: child,
              ),
              child: Text(
                "Foggi",
                style: GoogleFonts.play(
                  fontSize: 38,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  letterSpacing: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
