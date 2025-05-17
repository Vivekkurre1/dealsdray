import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';

class PhoneInputScreen extends ConsumerStatefulWidget {
  const PhoneInputScreen({super.key});

  @override
  ConsumerState<PhoneInputScreen> createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends ConsumerState<PhoneInputScreen> {
  bool isPhone = true;
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    ref.listen<AuthState>(authProvider, (prev, next) {
      if (next.step == AuthStep.otpSent) {
        Navigator.of(context).pushReplacementNamed('/otp');
      }
    });
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          // Exit the app
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            // Exits the app
            onPressed: () => SystemNavigator.pop(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Column(
            children: [
              SizedBox(height: 10),
              Image.asset("assets/dealsdray_logo.png", width: 120),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ToggleButton(
                    text: 'Phone',
                    selected: isPhone,
                    onTap: () => setState(() => isPhone = true),
                  ),
                  SizedBox(width: 8),
                  ToggleButton(
                    text: 'Email',
                    selected: !isPhone,
                    onTap: () => setState(() => isPhone = false),
                  ),
                ],
              ),
              SizedBox(height: 32),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Glad to see you!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.black,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
              SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  isPhone
                      ? 'Please provide your phone number'
                      : 'Please provide your email',
                  style: TextStyle(
                    color: Colors.black.withValues(alpha: 0.6),
                    fontSize: 16,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
              SizedBox(height: 30),
              TextField(
                controller: _phoneController,
                keyboardType:
                    isPhone ? TextInputType.phone : TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: isPhone ? 'Phone' : 'Email',
                  labelStyle: TextStyle(color: Colors.grey[700]),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red[400]!),
                  ),
                ),
              ),
              SizedBox(height: 40),
              if (auth.step == AuthStep.loading)
                CircularProgressIndicator(color: Colors.redAccent)
              else ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                        Color(0xffb12929),
                      ),
                      padding: WidgetStateProperty.all<EdgeInsets>(
                        EdgeInsets.symmetric(vertical: 18),
                      ),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      elevation: WidgetStateProperty.all<double>(0),
                    ),
                    onPressed: () {
                      if (_phoneController.text.trim().isEmpty ||
                          (isPhone &&
                              !RegExp(
                                r'^\+?[0-9]{10,15}$',
                              ).hasMatch(_phoneController.text.trim()))) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isPhone
                                  ? 'Please enter a valid phone number'
                                  : 'Please enter a valid email address',
                            ),
                            duration: Duration(seconds: 2),
                          ),
                        );
                        return;
                      }
                      final phone = _phoneController.text.trim();
                      if (phone.isNotEmpty) {
                        ref.read(authProvider.notifier).sendOtp(phone);
                      }
                    },
                    child: Text(
                      'SEND CODE',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        letterSpacing: 0.8,
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ),
                ),
                if (auth.step == AuthStep.error && auth.error != null) ...[
                  SizedBox(height: 18),
                  Text(
                    auth.error!,
                    style: TextStyle(color: Colors.red, fontSize: 15),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class ToggleButton extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;
  const ToggleButton({
    super.key,
    required this.text,
    required this.selected,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Color(0xffb12929) : Color(0xffe1e1e1),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black45,
            fontWeight: FontWeight.w600,
            fontSize: 16,
            fontFamily: 'Montserrat',
          ),
        ),
      ),
    );
  }
}
