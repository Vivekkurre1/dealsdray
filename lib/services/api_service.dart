import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service for all authentication-related APIs for DealsDray.
class ApiService {
  static const String _baseUrl = 'http://devapiv4.dealsdray.com/api/v2/user';
  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
  };

  /// Register/add a device
  Future<http.Response> addDevice(Map<String, dynamic> body) async {
    return await http.post(
      Uri.parse('$_baseUrl/device/add'),
      headers: _headers,
      body: jsonEncode(body),
    );
  }

  /// Request OTP to phone
  Future<http.Response> requestOtp(String mobileNumber, String deviceId) async {
    return await http.post(
      Uri.parse('$_baseUrl/otp'),
      headers: _headers,
      body: jsonEncode({'mobileNumber': mobileNumber, 'deviceId': deviceId}),
    );
  }

  /// Verify OTP
  Future<http.Response> verifyOtp(
    String otp,
    String deviceId,
    String userId,
  ) async {
    return await http.post(
      Uri.parse('$_baseUrl/otp/verification'),
      headers: _headers,
      body: jsonEncode({'otp': otp, 'deviceId': deviceId, 'userId': userId}),
    );
  }

  /// dummy Register email with referral code
  Future<http.Response> registerEmail({
    required String email,
    required String password,
    required String referralCode,
    required String userId,
  }) async {
    final response = http.Response(
      jsonEncode({
        'status': 1,
        'data': {
          'email': email,
          'password': password,
          'referralCode': referralCode,
          'userId': userId,
        },
      }),
      200,
    );
    return response;
  }
}


//   /// Register email with referral code
//   Future<http.Response> registerEmail({
//     required String email,
//     required String password,
//     required String referralCode,
//     required String userId,
//   }) async {
//     return await http.post(
//       Uri.parse('$_baseUrl/email/referral'),
//       headers: _headers,
//       body: jsonEncode({
//         'email': email,
//         'password': password,
//         'referralCode': referralCode,
//         'userId': userId,
//       }),
//     );
//   }
// }