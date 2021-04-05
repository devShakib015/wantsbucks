import 'dart:convert';

import 'package:flutter/material.dart';

class UserModel {
  String email;
  String name;
  String phone;
  String refferedBy;
  DateTime joiningDate;
  DateTime dueDate;
  DateTime reRegisterDate;
  UserModel({
    @required this.email,
    @required this.name,
    @required this.phone,
    @required this.refferedBy,
    @required this.joiningDate,
    @required this.dueDate,
    @required this.reRegisterDate,
  });

  UserModel copyWith({
    String email,
    String name,
    String phone,
    String refferedBy,
    DateTime joiningDate,
    DateTime dueDate,
    DateTime reRegisterDate,
  }) {
    return UserModel(
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      refferedBy: refferedBy ?? this.refferedBy,
      joiningDate: joiningDate ?? this.joiningDate,
      dueDate: dueDate ?? this.dueDate,
      reRegisterDate: reRegisterDate ?? this.reRegisterDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'phone': phone,
      'refferedBy': refferedBy,
      'joiningDate': joiningDate.millisecondsSinceEpoch,
      'dueDate': dueDate.millisecondsSinceEpoch,
      'reRegisterDate': reRegisterDate.millisecondsSinceEpoch,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'],
      name: map['name'],
      phone: map['phone'],
      refferedBy: map['refferedBy'],
      joiningDate: DateTime.fromMillisecondsSinceEpoch(map['joiningDate']),
      dueDate: DateTime.fromMillisecondsSinceEpoch(map['dueDate']),
      reRegisterDate:
          DateTime.fromMillisecondsSinceEpoch(map['reRegisterDate']),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(email: $email, name: $name, phone: $phone, refferedBy: $refferedBy, joiningDate: $joiningDate, dueDate: $dueDate, reRegisterDate: $reRegisterDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.email == email &&
        other.name == name &&
        other.phone == phone &&
        other.refferedBy == refferedBy &&
        other.joiningDate == joiningDate &&
        other.dueDate == dueDate &&
        other.reRegisterDate == reRegisterDate;
  }

  @override
  int get hashCode {
    return email.hashCode ^
        name.hashCode ^
        phone.hashCode ^
        refferedBy.hashCode ^
        joiningDate.hashCode ^
        dueDate.hashCode ^
        reRegisterDate.hashCode;
  }
}
