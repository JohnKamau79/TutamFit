import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tutam_fit/constants/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
    late AnimationController _controller;
    late Animation<double> _fadeAnimation;

    @override
    void initState() {
      super.initState();

      _controller = AnimationController(vsync: this, duration: Duration(seconds: 4));
      _fadeAnimation = TweenSequence([
        TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 1),
        TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 1),
      ]).animate(_controller);

      _controller.forward();

      _controller.addStatusListener((status) {
        if(status == AnimationStatus.completed) {
          context.go('/home');
        }
      });
    } 

    @override
    void dispose() {
      _controller.dispose();
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: Center(
            child: Text(
              'Welcome To TutamFit',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: AppColors.deepNavy
              ),
              ),
          ),
          ),
      );
    }
  }
