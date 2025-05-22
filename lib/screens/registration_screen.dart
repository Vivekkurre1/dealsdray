import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';

class RegistrationScreen extends ConsumerStatefulWidget {
  const RegistrationScreen({super.key});

  @override
  ConsumerState<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends ConsumerState<RegistrationScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _referralController = TextEditingController();
  bool _obscurePassword = true;
  String? _localError;

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    ref.listen<AuthState>(authProvider, (prev, next) {
      if (next.step == AuthStep.validatedReferralCode) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    });
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
        padding: const EdgeInsets.symmetric(horizontal: 28.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Image.asset("assets/dealsdray_logo.png", width: 120),
                    SizedBox(height: 16),
                  ],
                ),
              ),
              Text(
                "Let's Begin!",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.black,
                  fontFamily: 'Montserrat',
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Please enter your credentials to proceed',
                style: TextStyle(
                  color: Colors.black.withValues(alpha: 0.6),
                  fontSize: 16,
                  fontFamily: 'Montserrat',
                ),
              ),
              SizedBox(height: 34),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Your Email',
                  labelStyle: TextStyle(color: Colors.grey[600]),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red[400]!),
                  ),
                ),
              ),
              SizedBox(height: 28),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Create Password',
                  labelStyle: TextStyle(color: Colors.grey[600]),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red[400]!),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey[500],
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                ),
              ),
              SizedBox(height: 28),
              TextField(
                controller: _referralController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Referral Code',
                  labelStyle: TextStyle(color: Colors.grey[600]),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red[400]!),
                  ),
                ),
              ),
              SizedBox(height: 8),
              if (_localError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    _localError!,
                    style: TextStyle(color: Colors.red, fontSize: 15),
                  ),
                ),
              SizedBox(height: 34),
              if (auth.step == AuthStep.loading)
                Center(
                  child: CircularProgressIndicator(color: Colors.redAccent),
                ),
              if (auth.step == AuthStep.error && auth.error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 18),
                  child: Text(
                    auth.error!,
                    style: TextStyle(color: Colors.red, fontSize: 15),
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _localError = null;
          });
          final email = _emailController.text.trim();
          final password = _passwordController.text.trim();
          final referral = _referralController.text.trim();
          if (referral.isEmpty) {
            setState(() {
              _localError = "Referral code is mandatory";
            });
            return;
          } else if (email.isEmpty) {
            setState(() {
              _localError = "Email is empty";
            });
            return;
          } else if (password.isEmpty) {
            setState(() {
              _localError = "Password is empty";
            });
            return;
          }

          if (email.isNotEmpty && password.isNotEmpty && referral.isNotEmpty) {
            ref
                .read(authProvider.notifier)
                .register(
                  email: email,
                  password: password,
                  referralCode: referral,
                );
            // ref
            //     .read(authProvider.notifier)
            //     .registerEmail(
            //       email: email,
            //       password: password,
            //       // referralCode: referral,
            //     );

            // ref.read(authProvider.notifier).validateReferralCode(referral);
          }
        },
        backgroundColor: Color(0xffb12929),
        elevation: 0,
        child: Icon(Icons.arrow_forward, size: 32, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
