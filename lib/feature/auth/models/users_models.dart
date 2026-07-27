import 'dart:convert';
import 'package:cost_it_mobile/extensions/string_extension.dart';
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final bool isVerified;
  final bool isPhoneVerified;
  final DateTime? createdAt;
  final List<String>? roles;
  final String? authToken;
  final String? refreshToken;
  final bool isGoogleUser;
  final bool isProfileComplete;
  final bool? isNewUser;
  final String? photoUrl;

  const UserModel({
    required this.id,
    required this.email,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
    required this.isVerified,
    this.isPhoneVerified = false,
    this.createdAt,
    this.roles,
    this.authToken,
    this.refreshToken,
    this.isGoogleUser = false,
    this.isProfileComplete = true,
    this.isNewUser,
    this.photoUrl,
  });

  UserModel copyWith({
    String? id,
    String? email,
    String? phoneNumber,
    String? firstName,
    String? lastName,
    bool? isVerified,
    bool? isPhoneVerified,
    String? authToken,
    String? refreshToken,
    bool? isGoogleUser,
    bool? isProfileComplete,
    bool? isNewUser,
    String? photoUrl,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      isVerified: isVerified ?? this.isVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      authToken: authToken ?? this.authToken,
      refreshToken: refreshToken ?? this.refreshToken,
      isGoogleUser: isGoogleUser ?? this.isGoogleUser,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
      isNewUser: isNewUser ?? this.isNewUser,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    final userData = map['user'] is Map<String, dynamic>
        ? map['user'] as Map<String, dynamic>
        : map;

    return UserModel(
      id: userData['id'] ?? '',
      email: userData['email'] ?? '',
      phoneNumber: userData['phoneNumber'] ?? '',
      firstName: userData['firstName'] ?? '',
      lastName: userData['lastName'] ?? '',
      isVerified: userData['verifiedAt'] != null,
      isPhoneVerified: userData['isPhoneVerified'] ?? false,
      createdAt: userData['createdAt'] != null
          ? DateTime.parse(userData['createdAt'])
          : null,
      roles: userData['roles'] != null
          ? List<String>.from(userData['roles'])
          : [],
      authToken: map['token'] ?? map['access_token'],
      refreshToken: map['refresh_token'] as String?,
      isGoogleUser: userData['isGoogleUser'] ?? false,
      isProfileComplete: userData['isProfileComplete'] ?? true,
      isNewUser: map['isNewUser'] as bool?,
      photoUrl: userData['photoUrl'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'phoneNumber': phoneNumber,
      'firstName': firstName,
      'lastName': lastName,
      'verifiedAt': isVerified ? DateTime.now().toIso8601String() : null,
      'isPhoneVerified': isPhoneVerified,
      'token': authToken,
      'refresh_token': refreshToken,
      'isGoogleUser': isGoogleUser,
      'isProfileComplete': isProfileComplete,
      'isNewUser': isNewUser,
      'photoUrl': photoUrl,
    };
  }

  bool get isAdmin => roles?.contains('admin') ?? false;

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  String get displayName {
    if (firstName.isNotEmpty && lastName.isNotEmpty) {
      return '$firstName $lastName';
    }
    return email.split('@').first.capitalize;
  }

  String get userName {
    if (firstName.isNotEmpty) return firstName;
    return email.split('@').first;
  }

  @override
  String toString() =>
      'UserModel(id: $id, email: $email, phoneNumber: $phoneNumber, '
      'firstName: $firstName, lastName: $lastName, isVerified: $isVerified, '
      'isPhoneVerified: $isPhoneVerified, isGoogleUser: $isGoogleUser, '
      'isProfileComplete: $isProfileComplete, photoUrl: $photoUrl)';

  @override
  List<Object?> get props => [
    id,
    email,
    phoneNumber,
    firstName,
    lastName,
    isVerified,
    isPhoneVerified,
    authToken,
    refreshToken,
    isGoogleUser,
    isProfileComplete,
    photoUrl,
  ];
}
