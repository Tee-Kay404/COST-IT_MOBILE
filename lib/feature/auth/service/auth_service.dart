import 'package:cost_it_mobile/app/global/providers.dart';
import 'package:cost_it_mobile/app/storage/app_storage.dart';
import 'package:cost_it_mobile/feature/auth/models/users_models.dart';
import 'package:cost_it_mobile/app/network/client.dart';
import 'package:cost_it_mobile/app/network/dio_client.dart';
import 'package:cost_it_mobile/route/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class IAuthService {
  Future<UserModel> login(Map<String, dynamic> payload);
  Future<String> generateOTPToCreateUser(Map<String, dynamic> payload);
  Future<String> generateForgotPasswordOTP(Map<String, dynamic> payload);
  Future<bool> confirmForgotPasswordOTP(Map<String, dynamic> payload);
  Future<bool> verifyOTPToCreateUser(Map<String, dynamic> payload);
  Future<UserModel> getProfile(Map<String, dynamic> payload);
  Future<bool> reSendOTPVerification(Map<String, dynamic> payload);
  Future<bool> reSendOTPForgotPassword(Map<String, dynamic> payload);
  Future<bool> validatePasswordReset(Map<String, dynamic> payload);
  Future<UserModel> googleLogin(Map<String, dynamic> payload);
  Future<UserModel> completeProfile(Map<String, dynamic> payload);
}

class AuthService implements IAuthService {
  final NetworkClient client;
  AuthService({required this.client});

  @override
  Future<String> generateOTPToCreateUser(Map<String, dynamic> payload) async {
    final response = await client.post(
      'user/generate_otp_to_create_user',
      data: payload,
    );
    return response.data['message']?.toString() ?? 'OTP sent';
  }

  @override
  Future<bool> verifyOTPToCreateUser(Map<String, dynamic> payload) async {
    final response = await client.post('user/create', data: payload);
    return response.success;
  }

  @override
  Future<UserModel> getProfile(Map<String, dynamic> payload) async {
    final response = await client.get('/auth/profile');
    final result = response.transform<UserModel>(
      (data) => UserModel.fromMap(data as Map<String, dynamic>),
    );
    return result.data!;
  }

  @override
  Future<bool> reSendOTPVerification(Map<String, dynamic> payload) async {
    final response = await client.post('user/resend-otp', data: payload);
    return response.success;
  }

  @override
  Future<bool> reSendOTPForgotPassword(Map<String, dynamic> payload) async {
    final response = await client.post(
      'auth/resend-forgot-password-otp',
      data: payload,
    );
    return response.data?['status'] == true;
  }

  @override
  Future<UserModel> login(Map<String, dynamic> payload) async {
    final response = await client.post('auth/login', data: payload);
    final result = response.transform<UserModel>(
      (data) => UserModel.fromMap(data as Map<String, dynamic>),
    );
    return result.data!;
  }

  @override
  Future<bool> validatePasswordReset(Map<String, dynamic> payload) async {
    final response = await client.post('auth/reset-password', data: payload);
    return response.data['status'] == true;
  }

  @override
  Future<bool> confirmForgotPasswordOTP(Map<String, dynamic> payload) async {
    final response = await client.post('auth/confirm-reset-otp', data: payload);
    return response.success;
  }

  @override
  Future<String> generateForgotPasswordOTP(Map<String, dynamic> payload) async {
    final response = await client.post('auth/forgot-password', data: payload);
    return response.data['message'].toString();
  }

  @override
  Future<UserModel> completeProfile(Map<String, dynamic> payload) async {
    final response = await client.post('auth/complete-profile', data: payload);
    return response
        .transform<UserModel>(
          (data) => UserModel.fromMap(data as Map<String, dynamic>),
        )
        .data!;
  }

  @override
  Future<UserModel> googleLogin(Map<String, dynamic> payload) async {
    final response = await client.post('auth/google-login', data: payload);

    return response
        .transform<UserModel>(
          (data) => UserModel.fromMap(data as Map<String, dynamic>),
        )
        .data!;
  }

  Future<void> logout(BuildContext context, WidgetRef ref) async {
    await ref.read(rememberMeServiceProvider).clear();

    ref
        .read(appStateProvider.notifier)
        .updateAppState((s) => s.copyWith(user: null));

    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        PageRoutes.login.name,
        (route) => false,
      );
    }
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(client: ref.watch(dioClientProvider));
});
