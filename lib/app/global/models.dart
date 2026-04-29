import 'dart:convert';

import 'package:cost_it_mobile/feature/auth/models/users_models.dart';
import 'package:equatable/equatable.dart';


class AppStateModel extends Equatable {
  final UserModel? user;
  final SettingsModel settings;
  final bool isFirstTime;

  const AppStateModel({
    this.user,
    this.settings = const SettingsModel(),
    this.isFirstTime = false,
  });

  AppStateModel copyWith({
    UserModel? user,
    SettingsModel? settings,
    bool? isFirstTime,
  }) {
    return AppStateModel(
      user: user ?? this.user,
      settings: settings ?? this.settings,
      isFirstTime: isFirstTime ?? this.isFirstTime,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'user': user?.toMap()});
    result.addAll({'settings': settings.toMap()});
    result.addAll({'isFirstTime': isFirstTime});

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
    );
  }

  String toJson() => json.encode(toMap());

  factory AppStateModel.fromJson(String source) =>
      AppStateModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'AppStateModel(user: $user, settings: $settings, isFirstTime: $isFirstTime)';

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
      ];
}

class SettingsModel extends Equatable {
  final bool firstTime;
  const SettingsModel({
    this.firstTime = false,
  });

  SettingsModel copyWith({
    bool? firstTime,
    String? localeString,
  }) {
    return SettingsModel(
      firstTime: firstTime ?? this.firstTime,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'firstTime': firstTime});

    return result;
  }

  factory SettingsModel.fromMap(Map<String, dynamic> map) {
    return SettingsModel(
      firstTime: map['firstTime'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory SettingsModel.fromJson(String source) =>
      SettingsModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'SettingsModel(firstTime: $firstTime)';

  
  @override
  List<Object> get props => [firstTime];
}
