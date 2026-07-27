import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SettingsModel extends Equatable {
  final bool firstTime;
  final ThemeMode themeMode;

  const SettingsModel({
    this.firstTime = false,
    this.themeMode = ThemeMode.light,
  });

  SettingsModel copyWith({bool? firstTime, ThemeMode? themeMode}) {
    return SettingsModel(
      firstTime: firstTime ?? this.firstTime,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  Map<String, dynamic> toMap() {
    return {'firstTime': firstTime, 'themeMode': themeMode.index};
  }

  factory SettingsModel.fromMap(Map<String, dynamic> map) {
    return SettingsModel(
      firstTime: map['firstTime'] ?? false,
      themeMode: ThemeMode.values[map['themeMode'] ?? 0],
    );
  }

  String toJson() => json.encode(toMap());

  factory SettingsModel.fromJson(String source) =>
      SettingsModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'SettingsModel(firstTime: $firstTime, themeMode: $themeMode)';

  @override
  List<Object> get props => [firstTime, themeMode];
}
