import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  ConsumerState<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  final List<TextEditingController> _otpControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  late FocusNode _node1, _node2, _node3, _node4;
  int _seconds = 117;
  late final timer = Ticker(_onTick);

  @override
  void initState() {
    super.initState();
    _node1 = FocusNode();
    _node2 = FocusNode();
    _node3 = FocusNode();
    _node4 = FocusNode();
    timer.start();
  }

  void _onTick(Duration elapsed) {
    if (!mounted) return;
    if (_seconds > 0) {
      setState(() => _seconds = 117 - elapsed.inSeconds);
    } else {
      timer.stop();
    }
  }

  void _resendOtp() async {
    final auth = ref.read(authProvider);
    final phone = auth.user?.phone;
    if (phone != null && phone.isNotEmpty) {
      await ref.read(authProvider.notifier).sendOtp(phone);
      setState(() {
        _seconds = 117;
        for (var c in _otpControllers) {
          c.clear();
        }
      });
      timer.start();
    }
  }

  @override
  void dispose() {
    timer.dispose();
    _node1.dispose();
    _node2.dispose();
    _node3.dispose();
    _node4.dispose();
    for (var c in _otpControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void onOtpChanged() {
    final code = _otpControllers.map((c) => c.text).join();
    if (code.length == 4 && code.runes.every((r) => r >= 48 && r <= 57)) {
      ref.read(authProvider.notifier).verifyOtp(code);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    // ref.listen<AuthState>(authProvider, (prev, next) {
    //   if (next.step == AuthStep.otpVerified) {
    //     if (next.registrationStatus == 'Incomplete') {
    //       Navigator.of(context).pushReplacementNamed('/register');
    //     } else {
    //       Navigator.of(context).pushReplacementNamed('/home');
    //     }
    //   }
    // });
    ref.listen<AuthState>(authProvider, (prev, next) {
      if (next.step == AuthStep.otpVerified) {
        if (next.registrationStatus == 'Incomplete') {
          Navigator.of(context).pushReplacementNamed('/register');
        } else {
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil('/home', (route) => false);
        }
      }
    });
    String phone = auth.user?.phone ?? '';
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          // onPressed: () => Navigator.of(context).pop(),
          onPressed: () async {
            Navigator.of(context).pushReplacementNamed('/phone');
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            Image.asset("assets/recived_otp.png", width: 95, height: 95),
            SizedBox(height: 20),
            Text(
              'OTP Verification',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 25,
                fontFamily: 'Montserrat',
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 13),
            Text(
              'We have sent a unique OTP number to your mobile $phone',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black.withValues(alpha: 0.68),
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (i) => _otpBox(i)),
            ),
            SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _formatTimer(_seconds),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: Colors.black.withValues(alpha: 0.73),
                    fontFamily: 'Montserrat',
                  ),
                ),
                SizedBox(width: 32),
                InkWell(
                  onTap: _seconds == 0 ? _resendOtp : null,
                  child: Text(
                    'SEND AGAIN',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: _seconds == 0 ? Colors.red[400] : Colors.grey,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            if (auth.step == AuthStep.loading) ...[
              SizedBox(height: 16),
              CircularProgressIndicator(color: Colors.redAccent),
            ],
            if (auth.step == AuthStep.error && auth.error != null) ...[
              SizedBox(height: 18),
              Text(
                auth.error!,
                style: TextStyle(color: Colors.red, fontSize: 15),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _otpBox(int i) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      width: 48,
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.3),
          width: 1.5,
        ),
        color: Colors.white,
      ),
      alignment: Alignment.center,
      child: TextField(
        controller: _otpControllers[i],
        focusNode: [_node1, _node2, _node3, _node4][i],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 25,
          fontFamily: 'Montserrat',
        ),
        decoration: InputDecoration(border: InputBorder.none, counterText: ''),
        onChanged: (val) {
          if (val.length == 1 && i < 3) {
            FocusScope.of(
              context,
            ).requestFocus([_node1, _node2, _node3, _node4][i + 1]);
          } else if (val.isEmpty && i > 0) {
            FocusScope.of(
              context,
            ).requestFocus([_node1, _node2, _node3, _node4][i - 1]);
          }
          onOtpChanged();
        },
      ),
    );
  }

  String _formatTimer(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m : $s';
  }
}

// Simple ticker class for timer
class Ticker {
  final void Function(Duration) onTick;
  late final Stopwatch _stopwatch;
  late final bool active;
  Ticker(this.onTick) {
    _stopwatch = Stopwatch();
    active = false;
  }
  void start() {
    _stopwatch.start();
    _tick();
  }

  void stop() {
    _stopwatch.stop();
  }

  void dispose() {
    _stopwatch.stop();
  }

  void _tick() async {
    while (_stopwatch.isRunning) {
      await Future.delayed(Duration(seconds: 1));
      onTick(_stopwatch.elapsed);
    }
  }
}
