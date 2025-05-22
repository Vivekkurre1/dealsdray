import 'package:dealsdray/providers/device_payload.dart';
import 'package:dealsdray/screens/splash/animated_dot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../providers/auth_provider.dart';
import 'dart:async';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), _handleNavigation);
  }

  void _handleNavigation() async {
    final prefs = await SharedPreferences.getInstance();
    // final authStep = prefs.getString('auth_step');
    final validatedReferralCode = prefs.getString('validatedReferralCode');
    // if (authStep == AuthStep.registered.name) {
    if (validatedReferralCode == AuthStep.validatedReferralCode.name) {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } else {
      _registerDevice();
    }
  }

  void _registerDevice() async {
    await Geolocator.requestPermission();
    final payload = await getDevicePayload();
    await ref.read(authProvider.notifier).registerDevice(payload);
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/phone');
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/dealsdray_splash_screen.png",
              fit: BoxFit.cover,
              colorBlendMode: BlendMode.lighten,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 80.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (auth.step == AuthStep.loading)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        3,
                        (index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: AnimatedDot(index: index),
                        ),
                      ),
                    )
                  else if (auth.step == AuthStep.error)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 28),
                      child: Text(
                        auth.error ?? 'Device registration failed!',
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    )
                  else
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        3,
                        (index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: AnimatedDot(index: index),
                        ),
                      ),
                    ),
                  SizedBox(height: 36),
                  Image.asset("assets/dealsdray_logo.png", width: 110),
                  SizedBox(height: 12),
                  Text(
                    'DealsDray',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      fontSize: 26,
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.82),
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
