import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

enum AuthStep {
  idle,
  loading,
  deviceRegistered,
  otpSent,
  otpVerified,
  validatedReferralCode,
  registered,
  error,
}

class AuthState {
  final bool onBoard;
  final AuthStep step;
  final String? error;
  final UserModel? user;
  final String? deviceId;
  final String? userId;
  final String? registrationStatus;

  AuthState({
    this.onBoard = false,
    this.step = AuthStep.idle,
    this.error,
    this.user,
    this.deviceId,
    this.userId,
    this.registrationStatus,
  });

  AuthState copyWith({
    bool? onBoard,
    AuthStep? step,
    String? error,
    UserModel? user,
    String? deviceId,
    String? userId,
    String? registrationStatus,
  }) => AuthState(
    onBoard: onBoard ?? this.onBoard,
    step: step ?? this.step,
    error: error,
    user: user ?? this.user,
    deviceId: deviceId ?? this.deviceId,
    userId: userId ?? this.userId,
    registrationStatus: registrationStatus ?? this.registrationStatus,
  );
}

class AuthNotifier extends StateNotifier<AuthState> {
  final ApiService apiService;
  AuthNotifier(this.apiService) : super(AuthState());

  // create method to set authStep to the authProvider
  void setAuthStep(AuthStep step) {
    state = state.copyWith(step: step);
  }

  Future<void> registerDevice(Map<String, dynamic> body) async {
    state = state.copyWith(step: AuthStep.loading, error: null);
    try {
      final response = await apiService.addDevice(body);
      final data = response.statusCode == 200 ? response.body : null;
      if (data != null) {
        final m = jsonDecode(data);
        if (m['status'] == 1) {
          final deviceId = m['data']['deviceId'];
          state = state.copyWith(
            step: AuthStep.deviceRegistered,
            deviceId: deviceId,
            error: null,
          );
        } else {
          state = state.copyWith(
            step: AuthStep.error,
            error: m['data']['message'],
          );
        }
      } else {
        state = state.copyWith(
          step: AuthStep.error,
          error: 'Device registration failed: No response data',
        );
      }
    } catch (e) {
      state = state.copyWith(step: AuthStep.error, error: e.toString());
    }
  }

  Future<void> sendOtp(String phone) async {
    if (state.deviceId == null) {
      state = state.copyWith(
        step: AuthStep.error,
        error: 'Device ID not registered',
      );
      return;
    }
    state = state.copyWith(step: AuthStep.loading, error: null);
    try {
      final response = await apiService.requestOtp(phone, state.deviceId!);
      final m = jsonDecode(response.body);
      if (m['status'] == 1) {
        state = state.copyWith(
          step: AuthStep.otpSent,
          userId: m['data']['userId'],
          error: null,
        );
      } else {
        state = state.copyWith(
          step: AuthStep.error,
          error: m['data']['message'],
        );
      }
    } catch (e) {
      state = state.copyWith(step: AuthStep.error, error: e.toString());
    }
  }

  Future<void> verifyOtp(String otp) async {
    if (state.deviceId == null || state.userId == null) {
      state = state.copyWith(
        step: AuthStep.error,
        error: 'Device ID or User ID missing',
      );
      return;
    }
    state = state.copyWith(step: AuthStep.loading, error: null);
    try {
      final response = await apiService.verifyOtp(
        otp,
        state.deviceId!,
        state.userId!,
      );
      final m = jsonDecode(response.body);
      if (m['status'] == 1) {
        final regStatus = m['data']['registration_status'] as String?;
        state = state.copyWith(
          step: AuthStep.otpVerified,
          error: null,
          registrationStatus: regStatus, // <-- Store registration status
        );
      } else {
        state = state.copyWith(
          step: AuthStep.error,
          error: m['data']['message'],
        );
      }
    } catch (e) {
      state = state.copyWith(step: AuthStep.error, error: e.toString());
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String referralCode,
  }) async {
    await registerEmail(email: email, password: password);

    if (state.step != AuthStep.registered) {
      return;
    } else if (state.step == AuthStep.registered) {
      await validateReferralCode(referralCode);
    }
  }

  Future<void> validateReferralCode(String code) async {
    state = state.copyWith(step: AuthStep.loading, error: null);
    try {
      final response = await apiService.validateReferralCode(
        code,
        state.userId!,
      );
      final m = jsonDecode(response.body);
      if (m['status'] == 1) {
        SharedPreferences.getInstance().then((prefs) {
          prefs.setString(
            'validatedReferralCode',
            AuthStep.validatedReferralCode.name,
          );
        });
        state = state.copyWith(
          step: AuthStep.validatedReferralCode,
          error: null,
        );
      } else {
        state = state.copyWith(
          step: AuthStep.error,
          error: m['message'] ?? "Referral code is invalid",
        );
      }
    } catch (e) {
      state = state.copyWith(step: AuthStep.error, error: e.toString());
    }
  }

  Future<void> registerEmail({
    required String email,
    required String password,
  }) async {
    if (state.userId == null) {
      state = state.copyWith(step: AuthStep.error, error: 'User ID missing');
      return;
    }
    state = state.copyWith(step: AuthStep.loading, error: null);
    try {
      final response = await apiService.registerEmail(
        email: email,
        password: password,
        userId: state.userId!,
      );
      if (response.statusCode == 200) {
        //set shared preferences
        // SharedPreferences.getInstance().then((prefs) {
        //   prefs.setString('auth_step', AuthStep.registered.name);
        // });
        state = state.copyWith(step: AuthStep.registered, error: null);
      } else {
        state = state.copyWith(step: AuthStep.error, error: response.body);
      }
    } catch (e) {
      state = state.copyWith(step: AuthStep.error, error: e.toString());
    }
  }
}

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final api = ref.watch(apiServiceProvider);
  return AuthNotifier(api);
});
