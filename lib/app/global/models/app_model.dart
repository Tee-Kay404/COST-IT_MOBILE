import 'dart:convert';
import 'package:cost_it_mobile/app/global/models/settings_model.dart';
import 'package:cost_it_mobile/feature/auth/models/users_models.dart';
import 'package:equatable/equatable.dart';


class AppStateModel extends Equatable {
  final UserModel? user;
  final SettingsModel settings;
  final bool isFirstTime;
  final bool hasOnboarded;
  /// True when the user chose "Continue as Guest" and has not signed in.
  /// Persisted across restarts so the splash can route them back to the
  /// dashboard rather than the login screen.
  final bool isGuest;

  const AppStateModel({
    this.user,
    this.settings = const SettingsModel(),
    this.isFirstTime = false,
    this.hasOnboarded = false,
    this.isGuest = false,
  });

  AppStateModel copyWith({
    UserModel? user,
    SettingsModel? settings,
    bool? isFirstTime,
    bool? hasOnboarded,
    bool? isGuest,
    // Allow explicitly setting user to null (e.g. on logout)
    bool clearUser = false,
  }) {
    return AppStateModel(
      user: clearUser ? null : (user ?? this.user),
      settings: settings ?? this.settings,
      isFirstTime: isFirstTime ?? this.isFirstTime,
      hasOnboarded: hasOnboarded ?? this.hasOnboarded,
      isGuest: isGuest ?? this.isGuest,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'user': user?.toMap()});
    result.addAll({'settings': settings.toMap()});
    result.addAll({'isFirstTime': isFirstTime});
    result.addAll({'hasOnboarded': hasOnboarded});
    result.addAll({'isGuest': isGuest});

    return result;
  }

  factory AppStateModel.fromMap(Map<String, dynamic> map) {
    return AppStateModel(
      user: map['user'] != null
          ? UserModel.fromMap(Map<String, dynamic>.from(map['user']))
          : null,
      settings: (map['settings'] != null)
          ? SettingsModel.fromMap(Map<String, dynamic>.from(map['settings']))
          : SettingsModel(),
      isFirstTime: map['isFirstTime'] ?? false,
      hasOnboarded: map['hasOnboarded'] ?? false,
      isGuest: map['isGuest'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory AppStateModel.fromJson(String source) =>
      AppStateModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'AppStateModel(user: $user, settings: $settings, isFirstTime: $isFirstTime, hasOnboarded: $hasOnboarded, isGuest: $isGuest)';

  bool get isLoggedIn {
    return user != null;
  }

  bool get isGuestLoggedIn {
    return user == null;
  }

  @override
  List<Object?> get props => [
        user,
        settings,
        isFirstTime,
        hasOnboarded,
        isGuest,
      ];
}
