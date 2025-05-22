// import 'package:dealsdray/providers/auth_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class ReferralScreen extends ConsumerStatefulWidget {
//   const ReferralScreen({super.key});

//   @override
//   ConsumerState<ReferralScreen> createState() => _ReferralScreenState();
// }

// class _ReferralScreenState extends ConsumerState<ReferralScreen> {
//   final TextEditingController _referralController = TextEditingController();
//   String? _localError;

//   @override
//   Widget build(BuildContext context) {
//     final auth = ref.watch(authProvider);
//     ref.listen<AuthState>(authProvider, (prev, next) {
//       if (next.step == AuthStep.validatedReferralCode) {
//         Navigator.of(context).pushReplacementNamed('/home');
//       }
//     });
//     return PopScope(
//       canPop: false,
//       onPopInvokedWithResult: (didPop, _) {
//         if (!didPop) {
//           // Exit the app
//           SystemNavigator.pop();
//         }
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           elevation: 0,
//           backgroundColor: Colors.transparent,
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back, color: Colors.black),
//             onPressed: () => SystemNavigator.pop(),
//           ),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 28.0),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Center(
//                   child: Column(
//                     children: [
//                       Image.asset("assets/dealsdray_logo.png", width: 120),
//                       SizedBox(height: 16),
//                     ],
//                   ),
//                 ),
//                 Text(
//                   "Let's Begin!",
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 24,
//                     color: Colors.black,
//                     fontFamily: 'Montserrat',
//                   ),
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   'Please enter your credentials to proceed',
//                   style: TextStyle(
//                     color: Colors.black.withValues(alpha: 0.6),
//                     fontSize: 16,
//                     fontFamily: 'Montserrat',
//                   ),
//                 ),
//                 SizedBox(height: 34),
//                 TextField(
//                   controller: _referralController,
//                   keyboardType: TextInputType.number,
//                   decoration: InputDecoration(
//                     labelText: 'Referral Code',
//                     labelStyle: TextStyle(color: Colors.grey[600]),
//                     enabledBorder: UnderlineInputBorder(
//                       borderSide: BorderSide(color: Colors.grey[300]!),
//                     ),
//                     focusedBorder: UnderlineInputBorder(
//                       borderSide: BorderSide(color: Colors.red[400]!),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 8),
//                 if (_localError != null)
//                   Padding(
//                     padding: const EdgeInsets.only(top: 8),
//                     child: Text(
//                       _localError!,
//                       style: TextStyle(color: Colors.red, fontSize: 15),
//                     ),
//                   ),
//                 SizedBox(height: 34),
//                 if (auth.step == AuthStep.loading)
//                   Center(
//                     child: CircularProgressIndicator(color: Colors.redAccent),
//                   ),
//                 if (auth.step == AuthStep.error && auth.error != null)
//                   Padding(
//                     padding: const EdgeInsets.only(top: 18),
//                     child: Text(
//                       auth.error!,
//                       style: TextStyle(color: Colors.red, fontSize: 15),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             setState(() {
//               _localError = null;
//             });
//             final referral = _referralController.text.trim();
//             if (referral.isEmpty) {
//               setState(() {
//                 _localError = "Referral code is mandatory";
//               });
//               return;
//             }
//             ref.read(authProvider.notifier).validateReferralCode(referral);
//           },
//           backgroundColor: Color(0xffb12929),
//           elevation: 0,
//           child: Icon(Icons.arrow_forward, size: 32, color: Colors.white),
//         ),
//         floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//       ),
//     );
//   }
// }
