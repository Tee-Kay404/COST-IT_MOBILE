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
  final DateTime? createdAt;
  final List<String>? roles;
  final String? authToken;

  final bool isGoogleUser;

  final bool isProfileComplete;

  final bool? isNewUser;

  const UserModel({
    required this.id,
    required this.email,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
    required this.isVerified,
    this.createdAt,
    this.roles,
    this.authToken,
    this.isGoogleUser = false,
    this.isProfileComplete = true,
    this.isNewUser,
  });

  UserModel copyWith({
    String? id,
    String? email,
    String? phoneNumber,
    String? firstName,
    String? lastName,
    bool? isVerified,
    String? authToken,
    bool? isGoogleUser,
    bool? isProfileComplete,
    bool? isNewUser,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      isVerified: isVerified ?? this.isVerified,
      authToken: authToken ?? this.authToken,
      isGoogleUser: isGoogleUser ?? this.isGoogleUser,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
      isNewUser: isNewUser ?? this.isNewUser,
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
      createdAt: userData['createdAt'] != null
          ? DateTime.parse(userData['createdAt'])
          : null,
      roles: userData['roles'] != null
          ? List<String>.from(userData['roles'])
          : [],
      authToken: map['token'] ?? map['access_token'],
      isGoogleUser: userData['isGoogleUser'] ?? false,
      isProfileComplete: userData['isProfileComplete'] ?? true,
      isNewUser: map['isNewUser'] as bool?,
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
      'token': authToken,
      'isGoogleUser': isGoogleUser,
      'isProfileComplete': isProfileComplete,
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
      'isGoogleUser: $isGoogleUser, isProfileComplete: $isProfileComplete)';

  @override
  List<Object?> get props => [
    id,
    email,
    phoneNumber,
    firstName,
    lastName,
    isVerified,
    authToken,
    isGoogleUser,
    isProfileComplete,
  ];
}
