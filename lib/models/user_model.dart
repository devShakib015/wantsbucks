import 'dart:convert';
import 'package:flutter/material.dart';

class UserModel {
  String email;

  String refferedBy;
  UserModel({
    @required this.email,
    @required this.refferedBy,
  });

  UserModel copyWith({
    String email,
    String name,
    String refferedBy,
  }) {
    return UserModel(
      email: email ?? this.email,
      refferedBy: refferedBy ?? this.refferedBy,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'refferedBy': refferedBy,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'],
      refferedBy: map['refferedBy'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() => 'UserModel(email: $email, refferedBy: $refferedBy)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.email == email &&
        other.refferedBy == refferedBy;
  }

  @override
  int get hashCode => email.hashCode ^ refferedBy.hashCode;
}
