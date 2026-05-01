import 'dart:developer';

import 'package:cost_it_mobile/app/storage/app_storage.dart';
import 'package:cost_it_mobile/feature/auth/models/users_models.dart';
import 'package:cost_it_mobile/feature/auth/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models.dart';

// Storage Provider
final appStorageServiceProvider = Provider((ref) {
  return HiveStorageService<String, dynamic>(boxName: 'appStore', lazy: false);
});

// Load App State On Start
final appStateLoaderProvider = FutureProvider<AppStateModel>((ref) async {
  AppStateModel appState = AppStateModel();

  try {
    // Load stored state
    appState = await ref.read(appStateProvider.notifier).initialiseAppState();

    // If user exists → refresh profile
    if (appState.user != null) {
      try {
        final user = await ref.read(getProfileFutureProvider({}).future);

        // preserve the existing token explicitly
        ref
            .read(appStateProvider.notifier)
            .updateUser(
              user,
              overrideAuthToken: false, // ← this keeps currentUser?.authToken
            );
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

//  App State Notitfier
class AppStateNotifier extends StateNotifier<AppStateModel> {
  final IStorageService storageService;
  final Ref ref;

  AppStateNotifier(this.ref, this.storageService)
    : super(const AppStateModel());

  // Initialize App State from Storage
  Future<AppStateModel> initialiseAppState() async {
    AppStateModel appState = const AppStateModel();

    try {
      final data = await storageService.getAllItemsMapped();

      final appStateData = Map<String, dynamic>.from(data);

      log("Stored App State: $appStateData");

      if (appStateData.isNotEmpty) {
        appState = AppStateModel.fromMap(appStateData);
        // Restore token separately stored
        final savedToken = await storageService.getItem("token");
        if (savedToken != null && appState.user != null) {
          appState = appState.copyWith(
            user: appState.user!.copyWith(authToken: savedToken as String),
          );
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

  // Save Settings
  Future<void> saveSettings(SettingsModel settings) async {
    state = state.copyWith(settings: settings);

    await storageService.addItem("settings", settings.toMap());
  }

  // Generic State Update
  void updateAppState(AppStateModel Function(AppStateModel state) callback) {
    state = callback(state);
  }

  // Update User
  void updateUser(UserModel user, {bool overrideAuthToken = false}) {
    final currentUser = state.user;

    final preservedToken = overrideAuthToken
        ? user.authToken
        : currentUser?.authToken ?? user.authToken;

    final updatedUser = user.copyWith(authToken: preservedToken);

    state = state.copyWith(user: updatedUser);

    // Save user data
    storageService.addItem("user", updatedUser.toMap());

    // Save token separately so it survives profile refreshes
    if (preservedToken != null) {
      storageService.addItem("token", preservedToken);
    }
  }

  // Logout
  Future<void> logout() async {
    final isFirstTime = state.isFirstTime;
    final settings = state.settings;

    // remove only auth-related data
    await storageService.removeItem("user");
    await storageService.removeItem("token"); // if stored separately

    // reset memory state but keep preferences
    state = AppStateModel(
      isFirstTime: isFirstTime,
      settings: settings,
      user: null,
    );
  }
}

// Global State Provider
final appStateProvider = StateNotifierProvider<AppStateNotifier, AppStateModel>(
  (ref) {
    return AppStateNotifier(ref, ref.watch(appStorageServiceProvider));
  },
);
