import 'package:cost_it_mobile/app/global/utils/providers.dart';
import 'package:cost_it_mobile/app/global/dialog/auth_gate_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void guardAuth(
  BuildContext context,
  WidgetRef ref,
  VoidCallback authenticatedAction,
) {
  final isAuthenticated = ref.read(isAuthenticatedProvider);

  if (isAuthenticated) {
    authenticatedAction();
  } else {
    showAuthGateModal(context);
  }
}
