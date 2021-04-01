import 'dart:convert';
import 'package:flutter/material.dart';

class UserModel {
  String email;
  String name;
  String refferedBy;
  UserModel({
    @required this.email,
    @required this.name,
    @required this.refferedBy,
  });

  UserModel copyWith({
    String email,
    String name,
    String refferedBy,
  }) {
    return UserModel(
      email: email ?? this.email,
      name: name ?? this.name,
      refferedBy: refferedBy ?? this.refferedBy,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'refferedBy': refferedBy,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'],
      name: map['name'],
      refferedBy: map['refferedBy'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'UserModel(email: $email, name: $name, refferedBy: $refferedBy)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.email == email &&
        other.name == name &&
        other.refferedBy == refferedBy;
  }

  @override
  int get hashCode => email.hashCode ^ name.hashCode ^ refferedBy.hashCode;
}
