import 'package:flutter/foundation.dart';

@immutable
class SavedLocation {
  final String id;
  final String address;

  const SavedLocation({required this.id, required this.address});

  SavedLocation copyWith({String? address}) {
    return SavedLocation(id: id, address: address ?? this.address);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'address': address};
  }

  factory SavedLocation.fromMap(Map<String, dynamic> map) {
    return SavedLocation(
      id: map['id'] as String? ?? '',
      address: map['address'] as String? ?? '',
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedLocation &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
