import 'dart:developer';

import 'package:cost_it_mobile/app/global/models/settings_model.dart';
import 'package:cost_it_mobile/app/storage/app_storage.dart';
import 'package:cost_it_mobile/feature/auth/models/users_models.dart';
import 'package:cost_it_mobile/feature/auth/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_model.dart';

final appStorageServiceProvider = Provider((ref) {
  return HiveStorageService<String, dynamic>(boxName: 'appStore', lazy: false);
});

final appStateLoaderProvider = FutureProvider<AppStateModel>((ref) async {
  AppStateModel appState = AppStateModel();

  try {
    appState = await ref.read(appStateProvider.notifier).initialiseAppState();

    if (appState.user != null) {
      try {
        final user = await ref.read(getProfileFutureProvider({}).future);

        ref
            .read(appStateProvider.notifier)
            .updateUser(user, overrideAuthToken: false);
      } catch (e, stack) {
        log(e.toString());

        log(stack.toString());
      }
    }
  } catch (error, stack) {
    log(error.toString());
    log(stack.toString());
  }

  return appState;
});

class AppStateNotifier extends StateNotifier<AppStateModel> {
  final IStorageService storageService;
  final Ref ref;

  AppStateNotifier(this.ref, this.storageService)
    : super(const AppStateModel());

  Future<AppStateModel> initialiseAppState() async {
    AppStateModel appState = const AppStateModel();

    try {
      final data = await storageService.getAllItemsMapped();

      final appStateData = Map<String, dynamic>.from(data);

      log("Stored App State: $appStateData");

      if (appStateData.isNotEmpty) {
        appState = AppStateModel.fromMap(appStateData);
        final savedToken = await storageService.getItem("token");
        if (savedToken != null && appState.user != null) {
          appState = appState.copyWith(
            user: appState.user!.copyWith(authToken: savedToken as String),
          );
        }
        // Restore guest flag from dedicated key (also present in the full map
        // but we re-read it explicitly for clarity).
        final savedIsGuest = await storageService.getItem('isGuest');
        if (savedIsGuest == true && appState.user == null) {
          appState = appState.copyWith(isGuest: true);
        }
      } else {
        appState = appState.copyWith(isFirstTime: true);
      }
    } catch (error, stack) {
      log(error.toString());
      log(stack.toString());
    }

    state = appState;
    return state;
  }

  Future<void> saveSettings(SettingsModel settings) async {
    state = state.copyWith(settings: settings);

    await storageService.addItem("settings", settings.toMap());
  }

  void updateAppState(AppStateModel Function(AppStateModel state) callback) {
    state = callback(state);
  }

  void updateUser(UserModel user, {bool overrideAuthToken = false}) {
    final currentUser = state.user;

    final preservedToken = overrideAuthToken
        ? user.authToken
        : currentUser?.authToken ?? user.authToken;

    final updatedUser = user.copyWith(authToken: preservedToken);

    state = state.copyWith(user: updatedUser);

    storageService.addItem("user", updatedUser.toMap());

    if (preservedToken != null) {
      storageService.addItem("token", preservedToken);
    }
  }

  /// Called by the token-refresh interceptor after successfully getting a new pair.
  /// Updates both the access and refresh tokens in memory and persists them.
  void updateTokens({required String accessToken, required String refreshToken}) {
    final user = state.user;
    if (user == null) return;

    final updated = user.copyWith(
      authToken: accessToken,
      refreshToken: refreshToken,
    );
    state = state.copyWith(user: updated);

    storageService.addItem('token', accessToken);
    storageService.addItem('user', updated.toMap());
  }

  Future<void> logout() async {
    final hasOnboarded = state.hasOnboarded;
    final settings = state.settings;

    await storageService.removeItem("user");
    await storageService.removeItem("token");
    await storageService.removeItem("isGuest");

    state = AppStateModel(
      hasOnboarded: hasOnboarded,
      settings: settings,
      user: null,
      isGuest: false,
    );
  }

  /// Marks the user as a guest (or clears the flag on sign-in).
  /// Persists the value in Hive so the splash page can restore it on restart.
  Future<void> setGuestMode(bool value) async {
    state = state.copyWith(isGuest: value);
    if (value) {
      await storageService.addItem('isGuest', true);
    } else {
      await storageService.removeItem('isGuest');
    }
  }

  Future<void> completeOnboarding() async {
    state = state.copyWith(hasOnboarded: true);
    await storageService.addItem('hasOnboarded', true);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final updated = state.settings.copyWith(themeMode: mode);
    await saveSettings(updated);
  }
}

final appStateProvider = StateNotifierProvider<AppStateNotifier, AppStateModel>(
  (ref) {
    return AppStateNotifier(ref, ref.watch(appStorageServiceProvider));
  },
);

final themeModeProvider = Provider<ThemeMode>((ref) {
  return ref.watch(appStateProvider).settings.themeMode;
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(appStateProvider).isLoggedIn;
});
