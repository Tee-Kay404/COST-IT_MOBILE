import 'package:cost_it_mobile/app/global/providers.dart';
import 'package:cost_it_mobile/constants/constants.dart';
import 'package:cost_it_mobile/feature/auth/models/users_models.dart';
import 'package:cost_it_mobile/feature/auth/service/auth_service.dart';
import 'package:cost_it_mobile/feature/auth/utils/socials/google/google_auth_handler.dart';
import 'package:cost_it_mobile/widgets/dialogbox.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final signUpFutureProvider = FutureProvider.autoDispose
    .family<String, Map<String, dynamic>>((ref, payload) async {
      return ref.read(authServiceProvider).generateOTPToCreateUser(payload);
    });

final verifyFutureProvider = FutureProvider.autoDispose
    .family<bool, Map<String, dynamic>>((ref, payload) async {
      final result = await ref
          .read(authServiceProvider)
          .verifyOTPToCreateUser(payload);
      ref
          .read(appStateProvider.notifier)
          .updateAppState(
            (state) =>
                state.copyWith(user: state.user?.copyWith(isVerified: true)),
          );
      return result;
    });

final resendOTPFutureProvider = FutureProvider.autoDispose
    .family<bool, Map<String, dynamic>>((ref, payload) async {
      return ref.read(authServiceProvider).reSendOTPVerification(payload);
    });

final loginFutureProvider = FutureProvider.autoDispose
    .family<UserModel, Map<String, dynamic>>((ref, payload) async {
      return ref.read(authServiceProvider).login(payload);
    });

final generateForgotPasswordOTPProvider = FutureProvider.autoDispose
    .family<String, Map<String, dynamic>>((ref, payload) async {
      return ref.read(authServiceProvider).generateForgotPasswordOTP(payload);
    });

final confirmForgotPasswordOTPProvider = FutureProvider.autoDispose
    .family<bool, Map<String, dynamic>>((ref, payload) async {
      return ref.read(authServiceProvider).confirmForgotPasswordOTP(payload);
    });

final resendForgotPasswordOTPProvider = FutureProvider.autoDispose
    .family<bool, Map<String, dynamic>>((ref, payload) async {
      return ref.read(authServiceProvider).reSendOTPForgotPassword(payload);
    });

final validateForgotPasswordProvider = FutureProvider.autoDispose
    .family<bool, Map<String, dynamic>>((ref, payload) async {
      return ref.read(authServiceProvider).validatePasswordReset(payload);
    });

final getProfileFutureProvider = FutureProvider.autoDispose
    .family<UserModel, Map<String, dynamic>>((ref, payload) async {
      return ref.read(authServiceProvider).getProfile(payload);
    });

final completeProfileProvider = FutureProvider.autoDispose
    .family<UserModel, Map<String, dynamic>>((ref, payload) async {
      final response = await ref
          .read(authServiceProvider)
          .completeProfile(payload);
      return response;
    });

final googleLoginProvider = FutureProvider.autoDispose
    .family<UserModel, Map<String, dynamic>>((ref, payload) async {
      final response = ref.read(authServiceProvider).googleLogin(payload);
      return response;
    });

final logoutProvider =
    Provider<Future<void> Function(BuildContext context, WidgetRef ref)>((ref) {
      return (context, refParam) async {
        await ref.read(authServiceProvider).logout(context, refParam);
      };
    });

// — Shared state
final userEmailProvider = StateProvider<String?>((ref) => null);

enum SocialLoginProvider { apple, google }

extension SocialLoginProviderExtension on SocialLoginProvider {
  String get logoPath {
    switch (this) {
      case SocialLoginProvider.google:
        return AppImages.google;
      case SocialLoginProvider.apple:
        return AppImages.apple;
    }
  }

  String get displayText {
    switch (this) {
      case SocialLoginProvider.google:
        return 'Continue with Google';
      case SocialLoginProvider.apple:
        return 'Continue with Apple';
    }
  }

  VoidCallback? tapHandler(BuildContext context, WidgetRef ref) {
    switch (this) {
      case SocialLoginProvider.google:
        return () => handleGoogleSignIn(context, ref);
      case SocialLoginProvider.apple:
        return () => showFeatureNotEnabledDialog(context);
    }
  }
}
