import 'package:cost_it_mobile/app/global/dialog/scaffold_message.dart';
import 'package:cost_it_mobile/app/global/utils/exception.dart';
import 'package:cost_it_mobile/app/global/utils/providers.dart';
import 'package:cost_it_mobile/feature/auth/providers/providers.dart';
import 'package:cost_it_mobile/feature/auth/shared/loaders.dart';
import 'package:cost_it_mobile/route/routes.dart';
import 'package:cost_it_mobile/widgets/progress_loaders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// Handles Apple Sign-In flow on Android (web OAuth sheet) and iOS/macOS.
///
/// On Android this triggers a Safari-like web sheet — no Apple device needed
/// for the OAuth itself. A backend `auth/apple-login` endpoint and an Apple
/// Developer Program membership ($99/yr) are required for the full flow.
Future<void> handleAppleSignIn(BuildContext context, WidgetRef ref) async {
  // ── 1. Check platform availability ───────────────────────────────────────
  final isAvailable = await SignInWithApple.isAvailable();
  if (!isAvailable) {
    // On Android < API 21 or if the web-auth flow isn't supported.
    showErrorExceptionToast(
      context,
      'Apple Sign-In is not available on this device.',
    );
    return;
  }

  // ── 2. Trigger Apple OAuth ────────────────────────────────────────────────
  AuthorizationCredentialAppleID credential;
  try {
    credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      // Required for Android — opens a web-auth URL in a Chrome Custom Tab.
      webAuthenticationOptions: WebAuthenticationOptions(
        // TODO: Replace with your actual Apple Services ID and redirect URL
        // registered in your Apple Developer account.
        clientId: 'com.costit.mobile.apple-signin',
        redirectUri: Uri.parse(
          'https://YOUR_BACKEND_DOMAIN/auth/apple/callback',
        ),
      ),
    );
  } on SignInWithAppleAuthorizationException catch (e) {
    if (e.code == AuthorizationErrorCode.canceled) return; // user dismissed
    showErrorExceptionToast(context, 'Apple Sign-In was cancelled or failed.');
    return;
  } catch (_) {
    showErrorExceptionToast(context, 'Apple Sign-In failed. Please try again.');
    return;
  }

  final identityToken = credential.identityToken;
  if (identityToken == null) {
    showErrorExceptionToast(
      context,
      'Could not retrieve Apple token. Please try again.',
    );
    return;
  }

  // ── 3. Exchange token with backend ────────────────────────────────────────
  // TODO: Backend must implement POST auth/apple-login that accepts
  //       { token, email, firstName, lastName } and returns the same
  //       UserModel shape as auth/google-login.
  final user = await futureProgressCaller(
    context,
    loaderType: LoaderType.sheet,
    loadingMessage: 'Signing in with Apple...',
    computation: () => ref.read(
      appleLoginProvider({
        'token': identityToken,
        if (credential.email != null) 'email': credential.email,
        if (credential.givenName != null) 'firstName': credential.givenName,
        if (credential.familyName != null) 'lastName': credential.familyName,
      }).future,
    ),
    onError: (error) {
      final ex = error is GlobalException ? error : null;
      showErrorExceptionToast(
        context,
        ex?.message ?? 'Apple Sign-In failed. Please try again.',
      );
      return null;
    },
  );

  if (user == null || !context.mounted) return;

  // ── 4. Persist user and navigate ─────────────────────────────────────────
  ref.read(appStateProvider.notifier).updateUser(user, overrideAuthToken: true);

  if (user.isNewUser == true || !user.isProfileComplete) {
    Navigator.pushNamed(context, PageRoutes.completeProfile.name);
  } else {
    Navigator.pushReplacementNamed(context, PageRoutes.dashBoard.name);
  }
}
