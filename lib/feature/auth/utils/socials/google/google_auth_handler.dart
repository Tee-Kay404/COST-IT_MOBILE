import 'package:cost_it_mobile/app/global/errors/dialog/scaffold_message.dart';
import 'package:cost_it_mobile/app/global/exception.dart';
import 'package:cost_it_mobile/app/global/providers.dart';
import 'package:cost_it_mobile/feature/auth/providers/providers.dart';
import 'package:cost_it_mobile/feature/auth/shared/loaders.dart';
import 'package:cost_it_mobile/route/routes.dart';
import 'package:cost_it_mobile/widgets/progress_loaders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';


final _googleSignIn = GoogleSignIn(
  serverClientId: '416311943816-a4v0v04htsfcbt1q23oal55u32aqgak3.apps.googleusercontent.com',
  scopes: [
    'email',
    'profile',
  ],
);


Future<void> handleGoogleSignIn(
  BuildContext context,
  WidgetRef ref,
) async {
 
  GoogleSignInAccount? googleAccount;
  try {
    googleAccount = await _googleSignIn.signIn();
  } catch (e) {
    showErrorExceptionToast(context, 'Google sign-in failed. Please try again.');
    return;
  }

  if (googleAccount == null) return;

 
  final googleAuth = await googleAccount.authentication;


  final idToken = googleAuth.idToken;

  if (idToken == null) {
    showErrorExceptionToast(
      context,
      'Could not get Google token. Check your client configuration.',
    );
    return;
  }

  
  final user = await futureProgressCaller(
    context,
    loaderType: LoaderType.sheet,
    loadingMessage: 'Signing in with Google...',
    computation: () => ref.read(
      googleLoginProvider({'token': idToken}).future,
    ),
    onError: (error) {
      final ex = error is GlobalException ? error : null;
      showErrorExceptionToast(
        context,
        ex?.message ?? 'Google sign-in failed',
      );
      return null;
    },
  );

  if (user == null || !context.mounted) return;

  
ref.read(appStateProvider.notifier).updateUser(
  user,
  overrideAuthToken: true, 
);
  
  if (user.isNewUser == true || !user.isProfileComplete) {
    Navigator.pushNamed(
      context,
      PageRoutes.completeProfile.name,
    );
  } else {
    Navigator.pushReplacementNamed(
      context,
      PageRoutes.dashBoard.name,
    );
  }
}